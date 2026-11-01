#!/usr/bin/env python3
"""Inline fonts and icons into a diagram HTML (or TSX) file as data URIs.

Usage:
  python3 build.py DRAFT ICONDIR OUT [--fonts FONTSDIR]

Replaces:
  %%FONT_DISPLAY%%  base64 of FONTSDIR/Geist.woff2
  %%FONT_JBM%%      base64 of FONTSDIR/JetBrainsMono.woff2
  %%ICON_<name>%%   data URI of ICONDIR/<name>.(svg|png|webp)

Fails loudly if any %%...%% token is left unresolved.
"""
import base64, pathlib, re, sys

MIME = {"svg": "image/svg+xml", "png": "image/png", "webp": "image/webp",
        "jpg": "image/jpeg", "jpeg": "image/jpeg"}

def b64(p): return base64.b64encode(pathlib.Path(p).read_bytes()).decode()

def main():
    args = sys.argv[1:]
    fontsdir = None
    if "--fonts" in args:
        i = args.index("--fonts"); fontsdir = pathlib.Path(args[i + 1]); del args[i:i + 2]
    if len(args) != 3:
        print(__doc__); sys.exit(1)
    draft, icondir, out = pathlib.Path(args[0]), pathlib.Path(args[1]), pathlib.Path(args[2])
    html = draft.read_text(encoding="utf-8")

    if fontsdir:
        for tok, fn in (("%%FONT_DISPLAY%%", "Geist.woff2"), ("%%FONT_JBM%%", "JetBrainsMono.woff2")):
            if tok in html:
                html = html.replace(tok, b64(fontsdir / fn))

    for f in sorted(icondir.iterdir()):
        if f.suffix.lstrip(".") not in MIME:
            continue
        tok = f"%%ICON_{f.stem}%%"
        if tok in html:
            html = html.replace(tok, f"data:{MIME[f.suffix.lstrip('.')]};base64,{b64(f)}")

    leftover = sorted(set(re.findall(r"%%[A-Za-z0-9_-]+%%", html)))
    if leftover:
        sys.exit(f"unresolved tokens: {', '.join(leftover)}\n"
                 f"(missing icon files in {icondir}? forgot --fonts?)")
    out.write_text(html, encoding="utf-8")
    print(f"built {out} ({len(html) // 1024} KB)")

if __name__ == "__main__":
    main()
