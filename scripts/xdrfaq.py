#!/usr/bin/env python3
"""
XDR FAQ 知识库问答工具
用法: python xdrfaq.py [问题关键词]
或: python xdrfaq.py (交互式)
"""
import os
import sys
import re
from pathlib import Path
from typing import List, Tuple
import yaml

NOTES_DIR = Path("notes")

# 停用词列表
STOPWORDS = {"的", "了", "在", "是", "和", "与", "或", "如何", "怎么", "怎样", "什么", "哪里", "哪个", "为什么"}

def load_notes() -> List[Tuple[str, str, dict]]:
    """加载所有笔记，返回 (文件名, 内容, frontmatter) 列表"""
    notes = []
    for note_file in NOTES_DIR.glob("*.md"):
        if note_file.name == "index.md":
            continue
        content = note_file.read_text(encoding="utf-8")
        meta, body = parse_frontmatter(content)
        notes.append((note_file.name, body, meta))
    return notes

def parse_frontmatter(content: str):
    """解析 YAML frontmatter"""
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

def extract_keywords(query: str) -> List[str]:
    """提取查询关键词"""
    # 简单分词：按空格和中文标点分割
    words = re.split(r"[\s，。、！？；：]+", query)
    keywords = []
    for w in words:
        w = w.strip()
        if w and w not in STOPWORDS and len(w) >= 2:
            keywords.append(w.lower())
    return keywords

def search_notes(query: str, notes: List[Tuple[str, str, dict]], top_k: int = 3) -> List[Tuple[str, str, float]]:
    """搜索笔记，返回 (文件名, 匹配内容, 得分) 列表"""
    keywords = extract_keywords(query)
    if not keywords:
        return []
    
    results = []
    for filename, content, meta in notes:
        content_lower = content.lower()
        score = 0
        matched_content = ""
        
        # 提取标题匹配的分数
        title = meta.get("title", filename.replace(".md", ""))
        title_lower = title.lower()
        
        for kw in keywords:
            # 关键词在标题中，得分更高
            if kw in title_lower:
                score += 10
            
            # 关键词在内容中
            if kw in content_lower:
                score += 1
                # 找到匹配的位置，提取前后文
                idx = content_lower.find(kw)
                if idx >= 0:
                    start = max(0, idx - 30)
                    end = min(len(content), idx + len(kw) + 50)
                    snippet = content[start:end].strip()
                    if snippet:
                        matched_content = f"...{snippet}..."
        
        if score > 0:
            results.append((filename, matched_content, score, meta.get("title", filename)))
    
    # 按得分排序
    results.sort(key=lambda x: x[2], reverse=True)
    return [(r[0], r[1], r[2]) for r in results[:top_k]]

def format_result(filename: str, content_snippet: str, title: str) -> str:
    """格式化搜索结果"""
    display_name = title or filename.replace(".md", "")
    display_name = re.sub(r"^[A-Za-z]+-", "", display_name)
    display_name = display_name.replace("-", " ").replace("_", " ")
    
    result = f"\n[ {display_name}\n"
    if content_snippet:
        result += f"   {content_snippet}\n"
    result += f"   → notes/{filename}"
    return result

def interactive():
    """交互式问答"""
    print("=" * 50)
    print("XDR FAQ 知识库问答工具")
    print("输入问题关键词，按回车搜索，输入 q 退出")
    print("=" * 50)
    
    notes = load_notes()
    print(f"\n已加载 {len(notes)} 篇笔记\n")
    
    while True:
        try:
            query = input("问题> ").strip()
        except EOFError:
            break
        
        if not query:
            continue
        if query.lower() in ["q", "quit", "exit"]:
            break
        
        results = search_notes(query, notes)
        
        if results:
            print(f"\n找到 {len(results)} 条相关结果:")
            for filename, snippet, score in results:
                title = filename.replace(".md", "").replace("_", " ")
                print(format_result(filename, snippet, title))
        else:
            print("\n未找到相关内容，请尝试其他关键词")
        
        print()

def main():
    if len(sys.argv) > 1:
        # 命令行参数模式
        query = " ".join(sys.argv[1:])
        notes = load_notes()
        results = search_notes(query, notes)
        
        if results:
            print(f"搜索: {query}\n")
            for filename, snippet, score in results:
                title = filename.replace(".md", "").replace("_", " ")
                print(format_result(filename, snippet, title))
        else:
            print(f"未找到: {query}")
    else:
        # 交互式模式
        interactive()

if __name__ == "__main__":
    main()