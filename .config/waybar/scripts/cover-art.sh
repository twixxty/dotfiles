#!/usr/bin/env bash
# Prints the path of a circular, cached copy of the current track's cover art.
# Used by Waybar's `image` module. Needs: playerctl, curl, ImageMagick.

SIZE=128
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-cover"
mkdir -p "$CACHE"

IM=$(command -v magick || command -v convert) || exit 0

circle() { # circle <src> <out>
  "$IM" "$1" -resize "${SIZE}x${SIZE}^" -gravity center -extent "${SIZE}x${SIZE}" \
    \( -size "${SIZE}x${SIZE}" xc:none -fill white \
       -draw "circle $((SIZE / 2)),$((SIZE / 2)) $((SIZE / 2)),0" \) \
    -compose DstIn -composite "$2" 2>/dev/null
}

# Plain translucent disc, used when there is no player or no artwork
FALLBACK="$CACHE/fallback.png"
if [ ! -f "$FALLBACK" ]; then
  "$IM" -size "${SIZE}x${SIZE}" xc:none -fill 'rgba(255,255,255,0.18)' \
    -draw "circle $((SIZE / 2)),$((SIZE / 2)) $((SIZE / 2)),0" "$FALLBACK" 2>/dev/null
fi

url=$(playerctl metadata mpris:artUrl 2>/dev/null)
if [ -z "$url" ]; then
  echo "$FALLBACK"
  exit 0
fi

out="$CACHE/$(printf '%s' "$url" | md5sum | cut -d' ' -f1).png"

if [ ! -f "$out" ]; then
  tmp=$(mktemp "$CACHE/src.XXXXXX")
  case "$url" in
    file://*)
      path=${url#file://}
      printf '%b' "${path//%/\\x}" >"$tmp.path"   # url-decode
      cp "$(cat "$tmp.path")" "$tmp" 2>/dev/null
      rm -f "$tmp.path"
      ;;
    http://* | https://*)
      curl -sL --max-time 5 "$url" -o "$tmp" 2>/dev/null
      ;;
  esac
  if [ -s "$tmp" ]; then circle "$tmp" "$out"; fi
  rm -f "$tmp"
  # keep the cache small
  find "$CACHE" -name '*.png' ! -name fallback.png -mtime +7 -delete 2>/dev/null
fi

if [ -f "$out" ]; then echo "$out"; else echo "$FALLBACK"; fi
