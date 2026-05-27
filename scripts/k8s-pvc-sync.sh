#!/usr/bin/env bash
#
# K8s local-path PVC 数据同步脚本
#
# 1. /data/local_path/k8s_data 顶层只保留 pvc-* 目录
# 2. 从 backup 按「目录名第一个 _ 之后」的后缀匹配并同步到 local_path
# 3. 同步完成后逐文件校验 MD5
#

set -euo pipefail

DST_ROOT="${DST_ROOT:-/data/local_path/k8s_data}"
SRC_ROOT="${SRC_ROOT:-/data/local_path_backup/k8s_data}"
DRY_RUN="${DRY_RUN:-0}"
RSYNC_DELETE="${RSYNC_DELETE:-0}"

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
warn() { printf '[%s] WARN: %s\n' "$(date '+%H:%M:%S')" "$*" >&2; }
die()  { log "ERROR: $*"; exit 1; }

# 目录名 pvc-<uuid>_<suffix> → 返回 <suffix>（第一个 _ 之后）
get_suffix() {
  local name="$1"
  [[ "$name" == *_* ]] || return 1
  echo "${name#*_}"
}

is_pvc_dir() {
  local name="$1"
  [[ "$name" =~ ^pvc-[^_]+_.+ ]]
}

require_root() {
  [[ "$(id -u)" -eq 0 ]] || die "请使用 root 执行（路径在 /data 下）"
}

require_dirs() {
  [[ -d "$SRC_ROOT" ]] || die "源目录不存在: $SRC_ROOT"
  [[ -d "$DST_ROOT" ]] || die "目标目录不存在: $DST_ROOT"
}

run_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[DRY_RUN] $*"
  else
    "$@"
  fi
}

# 1. 目标路径顶层只保留 pvc-* 目录
cleanup_dst_top_level() {
  log "清理目标顶层，只保留 pvc-* 目录: $DST_ROOT"
  local item base
  for item in "$DST_ROOT"/*; do
    [[ -e "$item" ]] || continue
    base="$(basename "$item")"
    if is_pvc_dir "$base"; then
      log "  保留: $base"
    else
      warn "  删除非 pvc 项: $base"
      run_cmd rm -rf "$item"
    fi
  done
}

# 建立 suffix -> 绝对路径 映射（关联数组）
declare -A SRC_BY_SUFFIX=()
declare -A DST_BY_SUFFIX=()

index_directories() {
  local root="$1"
  local -n _map="$2"
  local d base suffix

  for d in "$root"/pvc-*_*; do
    [[ -d "$d" ]] || continue
    base="$(basename "$d")"
    is_pvc_dir "$base" || continue
    suffix="$(get_suffix "$base")" || continue
    if [[ -n "${_map[$suffix]:-}" ]]; then
      warn "后缀重复 [$suffix]: ${_map[$suffix]} 与 $d"
    fi
    _map[$suffix]="$d"
  done
}

sync_pair() {
  local src_dir="$1"
  local dst_dir="$2"
  local suffix="$3"

  log "同步 [$suffix]"
  log "  源: $src_dir"
  log "  目标: $dst_dir"

  local -a rsync_opts=(-aH --info=stats2,progress2)
  [[ "$RSYNC_DELETE" == "1" ]] && rsync_opts+=(--delete)

  if [[ "$DRY_RUN" == "1" ]]; then
    log "[DRY_RUN] rsync ${rsync_opts[*]} \"$src_dir/\" \"$dst_dir/\""
    return 0
  fi

  rsync "${rsync_opts[@]}" "$src_dir/" "$dst_dir/"
}

verify_md5_pair() {
  local src_dir="$1"
  local dst_dir="$2"
  local suffix="$3"

  log "MD5 校验 [$suffix]"

  local failed=0
  local missing=0
  local mismatch=0
  local ok=0
  local file rel src_md5 dst_md5

  while IFS= read -r -d '' file; do
    rel="${file#"$src_dir"/}"
    rel="${rel#/}"

    if [[ ! -f "$dst_dir/$rel" ]]; then
      warn "  目标缺少文件: $rel"
      missing=$((missing + 1))
      failed=1
      continue
    fi

    src_md5="$(md5sum "$file" | awk '{print $1}')"
    dst_md5="$(md5sum "$dst_dir/$rel" | awk '{print $1}')"

    if [[ "$src_md5" != "$dst_md5" ]]; then
      warn "  MD5 不一致: $rel (源=$src_md5 目标=$dst_md5)"
      mismatch=$((mismatch + 1))
      failed=1
    else
      ok=$((ok + 1))
    fi
  done < <(find "$src_dir" -type f -print0)

  # 检查目标是否有多余文件（源没有）
  local extra=0
  while IFS= read -r -d '' file; do
    rel="${file#"$dst_dir"/}"
    rel="${rel#/}"
    if [[ ! -f "$src_dir/$rel" ]]; then
      warn "  目标多余文件（源中不存在）: $rel"
      extra=$((extra + 1))
      failed=1
    fi
  done < <(find "$dst_dir" -type f -print0)

  log "  校验结果: 一致=$ok 缺失=$missing 不一致=$mismatch 多余=$extra"
  return "$failed"
}

main() {
  require_root
  require_dirs

  log "K8s PVC 同步开始"
  log "  源: $SRC_ROOT"
  log "  目标: $DST_ROOT"
  [[ "$DRY_RUN" == "1" ]] && log "  模式: DRY_RUN（不实际写入）"
  [[ "$RSYNC_DELETE" == "1" ]] && log "  rsync --delete 已启用"

  cleanup_dst_top_level

  index_directories "$SRC_ROOT" SRC_BY_SUFFIX
  index_directories "$DST_ROOT" DST_BY_SUFFIX

  log "源目录 pvc 数量: ${#SRC_BY_SUFFIX[@]}"
  log "目标目录 pvc 数量: ${#DST_BY_SUFFIX[@]}"

  local suffix src_dir dst_dir
  local sync_count=0
  local skip_count=0
  local verify_fail=0

  for suffix in "${!SRC_BY_SUFFIX[@]}"; do
    src_dir="${SRC_BY_SUFFIX[$suffix]}"
    dst_dir="${DST_BY_SUFFIX[$suffix]:-}"

    if [[ -z "$dst_dir" ]]; then
      warn "目标无匹配后缀，跳过: $suffix (源: $(basename "$src_dir"))"
      skip_count=$((skip_count + 1))
      continue
    fi

    sync_pair "$src_dir" "$dst_dir" "$suffix"
    sync_count=$((sync_count + 1))
  done

  log "同步完成: 成功匹配 $sync_count 对, 跳过 $skip_count 个源目录"

  # 目标有、源无的后缀（仅提示）
  for suffix in "${!DST_BY_SUFFIX[@]}"; do
    [[ -z "${SRC_BY_SUFFIX[$suffix]:-}" ]] \
      && warn "目标存在但源无匹配: $suffix → $(basename "${DST_BY_SUFFIX[$suffix]}")"
  done

  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY_RUN 模式，跳过 MD5 校验"
    exit 0
  fi

  log "========== MD5 校验 =========="
  for suffix in "${!SRC_BY_SUFFIX[@]}"; do
    src_dir="${SRC_BY_SUFFIX[$suffix]}"
    dst_dir="${DST_BY_SUFFIX[$suffix]:-}"
    [[ -z "$dst_dir" ]] && continue
    verify_md5_pair "$src_dir" "$dst_dir" "$suffix" || verify_fail=1
  done

  if [[ "$verify_fail" -ne 0 ]]; then
    die "MD5 校验未全部通过，请检查上方 WARN 日志"
  fi

  log "全部完成：同步与 MD5 校验均通过"
}

main "$@"
