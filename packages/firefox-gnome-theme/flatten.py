#!/usr/bin/env python3
"""Inline @import rules so the theme works as a single Firefox user sheet."""

import os
import re
import sys

root, entry, base_url = sys.argv[1:4]

IMPORT = re.compile(r'@import\s+(?:url\()?"([^"]+)"\)?\s*([^;]*);')
NAMESPACE = re.compile(r"^\s*@namespace[^;]*;\s*$", re.MULTILINE)


def load(rel):
    path = os.path.join(root, rel)
    if not os.path.exists(path):
        return ""
    with open(path, encoding="utf-8") as handle:
        css = handle.read()

    def expand(match):
        target, condition = match.group(1), match.group(2).strip()
        body = load(os.path.normpath(os.path.join(os.path.dirname(rel), target)))
        return f"@media {condition} {{\n{body}\n}}" if condition else body

    css = IMPORT.sub(expand, css)
    css = NAMESPACE.sub("", css)
    # assets are resolved against the store path, not the profile
    css = css.replace("url(../icons/", f"url({base_url}/theme/icons/")
    css = css.replace('url("../icons/', f'url("{base_url}/theme/icons/')
    css = css.replace("url(../icon.svg)", f"url({base_url}/icon.svg)")
    return css


sys.stdout.write(load(entry))
