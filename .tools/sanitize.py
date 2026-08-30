#!/usr/bin/env python3
"""Rename dropped images to URL-safe names (spaces -> dashes, odd characters stripped)."""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".avif", ".ico"}
SKIP = {".git", ".tools", "node_modules"}

def safe(name):
    stem, ext = os.path.splitext(name)
    stem = stem.strip().replace("&", "and")
    stem = re.sub(r"[\s_]+", "-", stem)
    stem = re.sub(r"[^A-Za-z0-9\-.]", "", stem)
    stem = re.sub(r"-{2,}", "-", stem).strip("-.") or "image"
    return stem + ext.lower()

renamed = 0
for dirpath, dirnames, filenames in os.walk(ROOT):
    dirnames[:] = [d for d in dirnames if d not in SKIP and not d.startswith(".")]
    for f in filenames:
        if os.path.splitext(f)[1].lower() not in EXTS:
            continue
        new = safe(f)
        if new == f:
            continue
        target = os.path.join(dirpath, new)
        if os.path.exists(target):                       # never clobber
            stem, ext = os.path.splitext(new)
            n = 2
            while os.path.exists(os.path.join(dirpath, f"{stem}-{n}{ext}")):
                n += 1
            new = f"{stem}-{n}{ext}"
            target = os.path.join(dirpath, new)
        os.rename(os.path.join(dirpath, f), target)
        print(f"  renamed: {f}  ->  {new}")
        renamed += 1
if renamed:
    print(f"  ({renamed} file(s) made URL-safe)")
