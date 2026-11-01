#!/usr/bin/env python3
"""Render a diagram HTML to PNG with headless Chromium (Playwright).

Usage:
  python3 render_png.py IN.html OUT.png [--selector .canvas] [--scale 2] [--full-page] [--single]

Default behavior:
  - captures BOTH themes: OUT.png (light) and OUT-dark.png (data-theme="dark")
  - strips border-radius on .scroller/.canvas for the screenshot only, so the PNG
    has square corners (the HTML keeps its rounded look)
--selector .canvas   screenshots just the diagram element (default)
--full-page          screenshots the whole page instead
--single             capture only the document as authored (no theme toggling)

Setup if Playwright is missing:
  pip install playwright
  python3 -m playwright install --with-deps chromium
Sandboxed hosts without root, if launch fails on a missing shared library (e.g. libXdamage.so.1):
  apt-get download libxdamage1 && dpkg -x libxdamage1_*.deb /tmp/libs
  (this script auto-adds /tmp/libs/usr/lib/*/ to LD_LIBRARY_PATH when that folder exists)
"""
import glob, os, pathlib, sys

SQUARE_CORNERS = (".scroller{border-radius:0!important;border:none!important}"
                  ".canvas{border-radius:0!important}")

def main():
    args = sys.argv[1:]
    sel, scale, full, single = ".canvas", 2, False, False
    if "--selector" in args:
        i = args.index("--selector"); sel = args[i + 1]; del args[i:i + 2]
    if "--scale" in args:
        i = args.index("--scale"); scale = float(args[i + 1]); del args[i:i + 2]
    if "--full-page" in args:
        args.remove("--full-page"); full = True
    if "--single" in args:
        args.remove("--single"); single = True
    if len(args) != 2:
        print(__doc__); sys.exit(1)
    src, out = pathlib.Path(args[0]).resolve(), pathlib.Path(args[1])

    lib_dirs = glob.glob("/tmp/libs/usr/lib/*")
    if lib_dirs:
        os.environ["LD_LIBRARY_PATH"] = ":".join(
            lib_dirs + [os.environ.get("LD_LIBRARY_PATH", "")]).rstrip(":")

    # Japanese text renders with Chinese-variant glyphs when no JP font is installed
    import subprocess
    try:
        ja = subprocess.run(["fc-list", ":lang=ja"], capture_output=True, text=True).stdout
        if "Sans" not in ja:
            print("WARNING: no Japanese sans font found — JP text will render with Chinese glyph "
                  "variants. Install a Japanese font, e.g. on Debian/Ubuntu: sudo apt-get install fonts-noto-cjk\n"
                  "  or without root:\n"
                  "  apt-get download fonts-noto-cjk && dpkg -x fonts-noto-cjk_*.deb /tmp/fontx\n"
                  "  mkdir -p ~/.fonts && cp /tmp/fontx/usr/share/fonts/opentype/noto/NotoSansCJK-*.ttc ~/.fonts/ && fc-cache -f")
    except FileNotFoundError:
        pass

    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        sys.exit("playwright not installed — see setup notes in this script's docstring")

    def shoot(page, path):
        if full:
            page.screenshot(path=str(path), full_page=True)
        else:
            el = page.query_selector(sel)
            if not el:
                sys.exit(f"selector {sel!r} not found in {src.name}")
            el.screenshot(path=str(path))
        print(f"rendered {path}")

    with sync_playwright() as p:
        # headless Chromium hints glyph advances to whole pixels by default: uneven letter spacing
        b = p.chromium.launch(args=["--no-sandbox", "--font-render-hinting=none"])
        page = b.new_page(viewport={"width": 1200, "height": 1000}, device_scale_factor=scale)
        page.goto(src.as_uri())
        # .scroller clips a canvas wider than the viewport
        width = page.evaluate("document.querySelector('.canvas')?.offsetWidth ?? 0")
        if width + 100 > 1200:
            page.set_viewport_size({"width": width + 100, "height": 1000})
        page.wait_for_timeout(1000)  # let embedded fonts settle
        page.add_style_tag(content=SQUARE_CORNERS)
        if single:
            shoot(page, out)
        else:
            page.evaluate("document.documentElement.removeAttribute('data-theme')")
            page.wait_for_timeout(120)
            shoot(page, out)
            page.evaluate("document.documentElement.setAttribute('data-theme','dark')")
            page.wait_for_timeout(120)
            shoot(page, out.with_name(out.stem + "-dark" + out.suffix))
        b.close()

if __name__ == "__main__":
    main()
