#!/usr/bin/env bash
#
# XDR Flyway 迁移失败修复脚本

# 将 patrol / xdr / bigdata-web 三个库中 success=0 的 Flyway 记录改为 success=1，
# 解决 "Schema contains a failed migration" 导致服务无法启动的问题。
#

set -euo pipefail

NAMESPACE_XDR="${NAMESPACE_XDR:-ailpha-xdr}"
NAMESPACE_MYSQL="${NAMESPACE_MYSQL:-mysql}"
MYSQL_POD="${MYSQL_POD:-mysql-primary-0}"
MYSQL_USER="${MYSQL_USER:-dbapp}"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
die() { log "ERROR: $*"; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "未找到命令: $1"
}

get_mysql_password() {
  local mirror_pod
  mirror_pod="$(kubectl get pods -n "$NAMESPACE_XDR" -o name 2>/dev/null \
    | sed 's|pod/||' \
    | grep -E '^mirror-' \
    | head -1)"

  [[ -n "$mirror_pod" ]] || die "在命名空间 $NAMESPACE_XDR 中未找到 mirror pod"

  log "从 pod $mirror_pod 读取 MYSQL_SERVICE_PASSWORD ..."
  kubectl exec -n "$NAMESPACE_XDR" "$mirror_pod" -- env 2>/dev/null \
    | grep '^MYSQL_SERVICE_PASSWORD=' \
    | cut -d= -f2- \
    | tr -d '\r'
}

run_mysql() {
  local password="$1"
  local sql="$2"
  kubectl exec -n "$NAMESPACE_MYSQL" "$MYSQL_POD" -- \
    mysql -u"$MYSQL_USER" -p"$password" -N -e "$sql"
}

fix_schema() {
  local password="$1"
  local db="$2"
  local table="$3"

  log "检查库 $db 表 $table ..."
  local failed_rows
  failed_rows="$(run_mysql "$password" \
    "SELECT COUNT(*) FROM \`$db\`.\`$table\` WHERE success = 0;")"

  log "  success=0 行数: $failed_rows"

  if [[ "$failed_rows" == "0" ]]; then
    log "  无需修复，跳过"
    return 0
  fi

  log "  失败记录详情:"
  run_mysql "$password" \
    "SELECT installed_rank, version, description, success FROM \`$db\`.\`$table\` WHERE success = 0;" \
    | while IFS= read -r line; do log "    $line"; done

  if [[ "$DRY_RUN" == "1" ]]; then
    log "  DRY_RUN=1，跳过 UPDATE"
    return 0
  fi

  log "  执行 UPDATE ..."
  run_mysql "$password" \
    "UPDATE \`$db\`.\`$table\` SET success = 1 WHERE success = 0;"
  log "  已修复 $failed_rows 行"
}

main() {
  need_cmd kubectl

  log "XDR Flyway 修复开始"
  log "  XDR 命名空间: $NAMESPACE_XDR"
  log "  MySQL 命名空间: $NAMESPACE_MYSQL"
  log "  MySQL Pod: $MYSQL_POD"
  [[ "$DRY_RUN" == "1" ]] && log "  模式: 仅检查 (DRY_RUN=1)"

  kubectl get pod -n "$NAMESPACE_MYSQL" "$MYSQL_POD" >/dev/null 2>&1 \
    || die "MySQL pod $NAMESPACE_MYSQL/$MYSQL_POD 不存在或无法访问"

  local password
  password="$(get_mysql_password)"
  [[ -n "$password" ]] || die "未能获取 MYSQL_SERVICE_PASSWORD"

  fix_schema "$password" "patrol" "patrol_flyway_schema"
  fix_schema "$password" "xdr" "xdr_schema_version"
  fix_schema "$password" "bigdata-web" "schema_version"

  log "修复完成。可观察 pod 恢复: kubectl get pods -n $NAMESPACE_XDR -w"
}

main "$@"
