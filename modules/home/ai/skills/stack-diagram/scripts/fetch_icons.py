#!/usr/bin/env python3
"""Fetch brand logos with a fallback chain, unmodified, for diagram builds.

Usage:
  python3 fetch_icons.py OUTDIR spec [spec ...]

Spec forms:
  name              -> slug == name          (e.g. hono)
  name:slug         -> different slug        (e.g. betterauth:better-auth)
  name=URL          -> explicit URL          (e.g. orpc=https://orpc.unnoq.com/logo.webp)
  name:aws/Service  -> official AWS icon     (e.g. lambda:aws/AWS-Lambda)

Sources tried in order:
  1. svgl              api.svgl.app?search={s} -> route (light variant when split)
  2. devicon           raw.githubusercontent.com/devicons/devicon/master/icons/{s}/{s}-original.svg
  3. gilbarbara/logos  cdn.jsdelivr.net/gh/gilbarbara/logos/logos/{s}-icon.svg then {s}.svg

simple-icons is deliberately not a source: its glyphs are monochrome redraws, not the
official marks. When every source misses, pass the official file as name=URL.

aws/ specs and the slugs aws, amazonwebservices and aws-* skip the chain and read AWS's own
package (aws.amazon.com/architecture/icons): gilbarbara's aws-* files keep an older color set.

svgl is matched by normalized title equality (search is fuzzy — a loose match would
silently ship the wrong brand's logo, so non-exact hits fall through to next source).

Writes OUTDIR/<name>.<ext> and OUTDIR/manifest.json, plus OUTDIR/<name>_dark.<ext> when
the source has a dark-theme variant (for group labels). Flags white/near-white fills
(use a dark tile for those). Never modifies icon colors.
"""
import base64, functools, http.client, io, json, pathlib, re, sys, urllib.request, urllib.error, urllib.parse, zipfile

UA = {"User-Agent": "Mozilla/5.0 (stack-diagram-skill)"}
NAME_RE = re.compile(r"[A-Za-z0-9_-]+")   # becomes a filename and an %%ICON_<name>%% token
AWS_ICONS_PAGE = "https://aws.amazon.com/architecture/icons/"
AWS_PACKAGE_RE = re.compile(r"""(?:https:)?//[\w.-]+\.awsstatic\.com/[^"'\s]+/Icon-package_[^"'\s/]+\.zip""")
AWS_ICON_RE = re.compile(r"Architecture-Service-Icons_[^/]+/[^/]+/64/Arch_(.+)_64\.svg"
                         r"|Architecture-Group-Icons_[^/]+/(.+)_32\.svg"
                         r"|Resource-Icons_[^/]+/Res_General-Icons/Res_48_Light/Res_(.+)_48_Light\.svg")
AWS_ALIASES = {
    "s3": "Amazon-Simple-Storage-Service", "glacier": "Amazon-Simple-Storage-Service-Glacier",
    "sqs": "Amazon-Simple-Queue-Service", "sns": "Amazon-Simple-Notification-Service",
    "ses": "Amazon-Simple-Email-Service", "ecs": "Amazon-Elastic-Container-Service",
    "eks": "Amazon-Elastic-Kubernetes-Service", "ecr": "Amazon-Elastic-Container-Registry",
    "elb": "Elastic-Load-Balancing", "alb": "Elastic-Load-Balancing", "nlb": "Elastic-Load-Balancing",
    "iam": "AWS-Identity-and-Access-Management", "kms": "AWS-Key-Management-Service",
    "msk": "Amazon-Managed-Streaming-for-Apache-Kafka", "opensearch": "Amazon-OpenSearch-Service",
    "vpc": "Virtual-private-cloud-VPC",
}
AWS_PACKAGES = {}

def get(url, timeout=15):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()

def read(url):
    """Bytes of url; '<AWS package URL>#<member>' reads from the already-downloaded zip."""
    zip_url, _, member = url.partition("#")
    return AWS_PACKAGES[zip_url].read(member) if zip_url in AWS_PACKAGES else get(url)

def looks_svg(b): return b.lstrip()[:200].lstrip().startswith((b"<svg", b"<?xml", b"<!DOC"))
def ext_of(b, url):
    if looks_svg(b): return "svg"
    if b[:8] == b"\x89PNG\r\n\x1a\n": return "png"
    if b[:4] == b"RIFF" and b[8:12] == b"WEBP": return "webp"
    m = re.search(r"\.(png|webp|jpe?g|svg)(\?|$)", url)
    return m.group(1) if m else None

def white_fill(b):
    """True only when the mark is white overall: at least one white paint and no
    non-white paint anywhere (a white detail on a colored logo is not a white logo)."""
    if not looks_svg(b): return False
    s = b.decode("utf-8", "ignore")
    paints = re.findall(r'(?:fill|stroke|stop-color)[=:]\s*"?([#a-zA-Z][^";\s>]*)', s)
    white = colored = False
    for p in paints:
        p = p.strip().lower()
        if p in ("none", "transparent", "currentcolor") or p.startswith("url("):
            continue
        if re.fullmatch(r"#f{3}(f{3})?|white", p): white = True
        else: colored = True
    return white and not colored

def norm(s): return re.sub(r"[^a-z0-9]", "", s.lower())

def svgl_lookup(slug):
    """Exact-normalized-title match on svgl's search API: (url, dark_url or None), or
    None if no exact hit. svgl's search matches title substrings ('better-auth' misses
    'Better Auth', 'nextjs' misses 'Next.js'), so also try the slug with separators
    turned into spaces and without a trailing 'js' (svgl titles Vue 'Vue', not 'Vue.js')."""
    queries = [slug, re.sub(r"[-_.]+", " ", slug).strip()]
    targets = {norm(slug)}
    if len(slug) > 4 and slug.endswith("js"):
        queries.append(slug[:-2]); targets.add(norm(slug[:-2]))
    for q in dict.fromkeys(queries):
        try:
            items = json.loads(get(f"https://api.svgl.app?search={urllib.parse.quote(q)}"))
        except Exception:
            continue
        for it in items if isinstance(items, list) else []:
            if norm(it.get("title", "")) in targets:
                route = it.get("route")
                if isinstance(route, dict):    # light/dark split: tiles are white -> light
                    light, dark = route.get("light"), route.get("dark")
                    return (light, dark) if light else (dark, None)
                return route, None
    return None

@functools.lru_cache(maxsize=1)
def aws_index():
    """AWS's icon package as {normalized name: (name, url, dark url or None)}. The package URL
    changes with each release, so it is read from the icons page; the zip is downloaded once
    per run and stays in memory."""
    link = AWS_PACKAGE_RE.search(get(AWS_ICONS_PAGE).decode("utf-8", "ignore"))
    if not link:
        raise OSError(f"no Icon-package link on {AWS_ICONS_PAGE}")
    url = urllib.parse.urljoin(AWS_ICONS_PAGE, link.group())
    AWS_PACKAGES[url] = zipfile.ZipFile(io.BytesIO(get(url)))
    files = set(AWS_PACKAGES[url].namelist())
    index = {}
    for f in sorted(files):
        m = AWS_ICON_RE.fullmatch(f)
        if m:
            # the General- prefix keeps General-Shield from taking the short name of AWS-Shield
            name = m.group(1) or m.group(2) or f"General-{m.group(3)}"
            dark = f.replace("_Light", "_Dark") if m.group(3) else f[:-4] + "_Dark.svg"
            index.setdefault(norm(name), (name, f"{url}#{f}", f"{url}#{dark}" if dark in files else None))
    return index

def aws_sources(query):
    """Exact match on the package's names or an acronym, with the AWS-/Amazon- prefix optional.
    A miss lists every name: a partial match could ship the wrong service's icon."""
    try:
        index = aws_index()
    except (OSError, zipfile.BadZipFile, http.client.HTTPException) as e:
        print(f"AWS  icon package unavailable: {e}")
        return []
    q = norm(AWS_ALIASES.get(norm(query), query))
    hit = index.get(q) or next((v for k, v in index.items() if re.sub(r"^(aws|amazon)", "", k) == q), None)
    if hit:
        return [("aws", hit[1], hit[2])]
    print(f"AWS  {query!r} is not a name in the package. Names: {', '.join(sorted(v[0] for v in index.values()))}")
    return []

def sources(slug):
    # concept icons: slug "lucide/<icon-name>" -> Lucide line icon (browse: lucide.dev/icons)
    if slug.startswith("lucide/"):
        return [("lucide", f"https://cdn.jsdelivr.net/npm/lucide-static/icons/{slug[7:]}.svg", None)]
    if slug.startswith("aws/"):
        return aws_sources(slug[4:])
    if norm(slug) in ("aws", "amazonwebservices"):
        return aws_sources("AWS-Cloud-logo")
    if slug[:4].lower() == "aws-":
        return aws_sources(slug[4:])
    out = []
    svgl = svgl_lookup(slug)
    if svgl:
        out.append(("svgl", *svgl))
    return out + [
        ("devicon", f"https://raw.githubusercontent.com/devicons/devicon/master/icons/{slug}/{slug}-original.svg", None),
        ("gilbarbara", f"https://cdn.jsdelivr.net/gh/gilbarbara/logos/logos/{slug}-icon.svg", None),
        ("gilbarbara", f"https://cdn.jsdelivr.net/gh/gilbarbara/logos/logos/{slug}.svg", None),
    ]

def main():
    if len(sys.argv) < 3:
        print(__doc__); sys.exit(1)
    outdir = pathlib.Path(sys.argv[1]); outdir.mkdir(parents=True, exist_ok=True)
    mpath = outdir / "manifest.json"
    manifest = json.loads(mpath.read_text()) if mpath.exists() else {}   # merge across runs
    failed = []
    bad_names = False
    for spec in sys.argv[2:]:
        if "=" in spec:
            name, url = spec.split("=", 1); tries = [("explicit", url, None)]
        elif ":" in spec:
            name, slug = spec.split(":", 1); tries = sources(slug)
        else:
            name = spec; tries = sources(name.lower().replace(" ", ""))
        if not NAME_RE.fullmatch(name):
            print(f"SKIP {name!r}: icon name must match [A-Za-z0-9_-]+ (it becomes a filename)")
            bad_names = True; continue
        got = None
        for src, url, dark_url in tries:
            try:
                b = read(url)
            except (urllib.error.URLError, urllib.error.HTTPError, OSError):
                continue
            ext = ext_of(b, url)
            if not ext or len(b) < 50:      # 404 pages, empty bodies
                continue
            got = (src, url, dark_url, b, ext); break
        if not got:
            failed.append(name); continue
        src, url, dark_url, b, ext = got
        if src == "lucide":
            # concept icon, not a brand logo — tinting it to the diagram's slate ink is fine
            b = b.replace(b'stroke="currentColor"', b'stroke="#3d4660"')
            b = b.replace(b'stroke-width="2"', b'stroke-width="1.7"')
        # build.py embeds whichever <name>.* sorts first, so a re-fetch must not leave the old file
        for old in [*outdir.glob(f"{name}.*"), *outdir.glob(f"{name}_dark.*")]:
            if old != mpath:
                old.unlink()
        path = outdir / f"{name}.{ext}"
        path.write_bytes(b)
        entry = {"source": src, "url": url, "file": path.name, "bytes": len(b)}
        if white_fill(b):
            entry["white_fill"] = True
            entry["note"] = ("white fill detected — MAY be a false positive (an inner detail on a "
                             "colored logo). Inspect the SVG; only use a dark tile if the mark is "
                             "actually white overall. Never recolor.")
        if dark_url:
            try:
                db = read(dark_url)
            except (urllib.error.URLError, urllib.error.HTTPError, OSError):
                db = b""
            dext = ext_of(db, dark_url) if len(db) >= 50 else None
            if dext:
                dpath = outdir / f"{name}_dark.{dext}"
                dpath.write_bytes(db); entry["dark_file"] = dpath.name
        manifest[name] = entry
        flag = " [WHITE FILL -> dark tile]" if entry.get("white_fill") else ""
        if "dark_file" in entry:
            flag += f" +{entry['dark_file']} (dark-theme group label)"
        print(f"OK   {name:<16} {src:<12} {len(b):>7}B .{ext}{flag}")
    (outdir / "manifest.json").write_text(json.dumps(manifest, indent=2))
    for name in failed:
        print(f"FAIL {name:<16} no source has it — try name:otherslug, or name=URL with the official "
              f"file (the project's repo root/docs/assets, or its site's /logo.svg, /favicon.svg)")
    sys.exit(1 if failed or bad_names else 0)

if __name__ == "__main__":
    main()
