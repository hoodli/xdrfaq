#!/usr/bin/env python3
"""
同步 notes/ 到 docs/，自动生成 mkdocs nav
"""
import os
import re
import yaml
from pathlib import Path
from datetime import datetime

NOTES_DIR = Path("notes")
DOCS_DIR = Path("docs")

# 分类映射：文件名前缀 -> docs 子目录
CATEGORY_MAP = {
    "XDR-": "xdr",
    "k8s-": "k8s",
    "kubesphere-": "kubesphere",
    "Linux-": "linux",
    "ClickHouse-": "linux",
    "Redis-": "linux",
}

def parse_frontmatter(content: str) -> tuple[dict, str]:
    """解析 YAML frontmatter，返回 (metadata, body)"""
    if not content.startswith("---"):
        return {}, content
    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}, content
    try:
        meta = yaml.safe_load(parts[1]) or {}
    except:
        meta = {}
    return meta, parts[2].strip()

def get_category(filename: str) -> str:
    """根据文件名前缀返回分类目录"""
    for prefix, cat in CATEGORY_MAP.items():
        if filename.startswith(prefix):
            return cat
    return "other"

def get_display_name(filename: str, meta: dict) -> str:
    """获取显示名称"""
    if "title" in meta:
        return meta["title"]
    # 从文件名生成
    name = filename.replace(".md", "")
    name = re.sub(r"^[A-Za-z]+-", "", name)
    return name.replace("-", " ").replace("_", " ")

def sync_notes():
    """同步 notes/ 到 docs/"""
    nav_sections = {}
    
    for note_file in NOTES_DIR.glob("*.md"):
        if note_file.name == "index.md":
            continue
        
        content = note_file.read_text(encoding="utf-8")
        meta, body = parse_frontmatter(content)
        
        # 确定目标目录
        category = get_category(note_file.name)
        target_dir = DOCS_DIR / category
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # 目标文件名（去掉前缀）
        target_name = note_file.name
        for prefix in CATEGORY_MAP:
            if target_name.startswith(prefix):
                target_name = target_name[len(prefix):]
                break
        
        target_file = target_dir / target_name
        
        # 写入文件（不含 frontmatter）
        target_file.write_text(body, encoding="utf-8")
        print(f"同步: {note_file} -> {target_file}")
        
        # 收集 nav 信息
        display_name = get_display_name(note_file.name, meta)
        nav_path = f"{category}/{target_name}"
        if category not in nav_sections:
            nav_sections[category] = []
        nav_sections[category].append((display_name, nav_path))
    
    return nav_sections

def update_mkdocs_yml(nav_sections: dict):
    """更新 mkdocs.yml 的 nav 部分"""
    mkdocs_file = Path("mkdocs.yml")
    content = mkdocs_file.read_text(encoding="utf-8")
    
    # 分类显示名称
    category_names = {
        "xdr": "XDR",
        "k8s": "Kubernetes",
        "kubesphere": "KubeSphere",
        "linux": "Linux",
        "other": "其他",
    }
    
    # 构建 nav 列表
    nav_lines = ["nav:", "  - 首页: index.md"]
    
    for cat in ["xdr", "k8s", "kubesphere", "linux", "other"]:
        if cat not in nav_sections:
            continue
        cat_name = category_names.get(cat, cat)
        nav_lines.append(f"  - {cat_name}:")
        for display_name, nav_path in sorted(nav_sections[cat]):
            nav_lines.append(f"      - {display_name}: {nav_path}")
    
    nav_content = "\n".join(nav_lines)
    
    # 替换 nav 部分
    new_content = re.sub(
        r"^nav:.*?(?=^[a-zA-Z]|\Z)",
        nav_content + "\n",
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    mkdocs_file.write_text(new_content, encoding="utf-8")
    print(f"已更新 mkdocs.yml")

def main():
    print(f"=== 同步 notes -> docs ({datetime.now().isoformat()}) ===")
    nav_sections = sync_notes()
    update_mkdocs_yml(nav_sections)
    print("完成")

if __name__ == "__main__":
    main()
