#!/usr/bin/env python3
"""Cover art for Waybar's `image` module: round, rotated, always current.

Every tick this asks the active MPRIS player (via playerctl) for its status and
art URL, and prints the path of a circular, rotated PNG of that art.

  * Playing / Paused, art available  -> path of that track's cover
  * Playing / Paused, no art / error -> path of a plain disc (keeps the slot)
  * Stopped / no player              -> prints double newline so Waybar resets
                                        the image path to empty and applies .empty

One file is cached per art URL (~/.cache/waybar-cover), so a new track always
produces a new path and Waybar can never show a stale image.

Run it by hand with --debug to see what it decides and why.

Needs: Pillow, playerctl.
"""
import hashlib
import io
import os
import subprocess
import sys
import time
import urllib.request
from urllib.parse import urlparse

SIZE = 128
CACHE = os.environ.get("WAYBAR_COVER_CACHE") or os.path.join(
    os.environ.get("XDG_CACHE_HOME") or os.path.expanduser("~/.cache"),
    "waybar-cover",
)
SHOW_WHEN = ("Playing", "Paused")  # drop "Paused" to hide the cover on pause
KEEP = 30  # cached covers to keep
RETRY_AFTER = 15  # seconds before retrying a failed download
DEBUG = "--debug" in sys.argv


def log(*args):
    if DEBUG:
        print("[cover]", *args, file=sys.stderr)


def playerctl(*args):
    try:
        r = subprocess.run(
            ["playerctl", *args], capture_output=True, text=True, timeout=2
        )
    except Exception as e:  # missing binary, timeout, ...
        log("playerctl failed:", e)
        return None
    if r.returncode != 0:
        log("playerctl", *args, "->", r.stderr.strip() or f"exit {r.returncode}")
        return None
    return r.stdout.strip()


def circle_mask():
    from PIL import Image, ImageDraw

    # Anti-aliased circle: draw at 4x, then shrink.
    big = SIZE * 4
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, big - 1, big - 1), fill=255)
    return mask.resize((SIZE, SIZE), Image.LANCZOS)


def fallback():
    """A plain translucent disc, used when there is no (usable) art."""
    path = os.path.join(CACHE, "disc.png")
    if not os.path.exists(path):
        from PIL import Image

        disc = Image.new("RGBA", (SIZE, SIZE), (255, 255, 255, 46))
        disc.putalpha(circle_mask().point(lambda v: v * 46 // 255))
        save_atomic(disc, path)
    print(path)


def save_atomic(im, path):
    tmp = path + ".tmp"
    im.save(tmp, "PNG")
    os.replace(tmp, path)  # atomic: Waybar never reads a half-written file


def fetch(url):
    if urlparse(url).scheme not in ("http", "https", "file", "data"):
        raise ValueError(f"unsupported art URL: {url[:60]}")
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=4) as resp:
        return resp.read(12_000_000)


def build(data, out):
    from PIL import Image, ImageChops, ImageOps

    im = Image.open(io.BytesIO(data))
    im = ImageOps.fit(im.convert("RGBA"), (SIZE, SIZE), Image.LANCZOS)
    # The title is rotated 90 degrees counter-clockwise (reads bottom to top),
    # so turn the art the same way. For clockwise use ROTATE_270.
    im = im.transpose(Image.Transpose.ROTATE_90)
    im.putalpha(ImageChops.multiply(im.getchannel("A"), circle_mask()))
    save_atomic(im, out)


def prune():
    covers = [
        os.path.join(CACHE, f)
        for f in os.listdir(CACHE)
        if f.endswith(".png") and f != "disc.png"
    ]
    covers.sort(key=os.path.getmtime, reverse=True)
    for old in covers[KEEP:]:
        os.unlink(old)
    for f in os.listdir(CACHE):
        p = os.path.join(CACHE, f)
        if f.endswith(".fail") and time.time() - os.path.getmtime(p) > 3600:
            os.unlink(p)


def main():
    status = playerctl("status")
    log("status:", status)
    if status not in SHOW_WHEN:
        sys.stdout.write("\n\n")
        sys.stdout.flush()
        return

    os.makedirs(CACHE, exist_ok=True)
    url = playerctl("metadata", "mpris:artUrl")
    log("art url:", url)
    if not url:
        return fallback()

    key = hashlib.sha1(url.encode()).hexdigest()[:16]
    out = os.path.join(CACHE, key + ".png")
    fail = os.path.join(CACHE, key + ".fail")

    if not os.path.exists(out):
        if os.path.exists(fail) and time.time() - os.path.getmtime(fail) < RETRY_AFTER:
            log("recent failure, waiting before retry")
            return fallback()
        try:
            build(fetch(url), out)
        except Exception as e:
            log("could not build cover:", repr(e))
            open(fail, "w").close()
            return fallback()
        prune()

    print(out)


if __name__ == "__main__":
    main()