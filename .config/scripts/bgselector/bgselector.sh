#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/thumbnails/bgselector-qs"
CACHE_LIST="$CACHE_DIR/.list"
CACHE_SIG="$CACHE_DIR/.sig"
# Bump this whenever the thumbnail size/format below changes: it forces a rebuild.
SCHEME="v3-800x600"

mkdir -p "$CACHE_DIR"

# Only one picker at a time (fd is closed for quickshell below)
exec 9>"$CACHE_DIR/.lock"
flock -n 9 || exit 0

# Thumbnail file name for a wallpaper, returned in $REPLY (no subshell, no fork).
# '_' -> '_u' and '/' -> '_s' keeps the mapping one-to-one, so a/b_c.jpg and
# a_b/c.jpg can never share a thumbnail. Very long paths fall back to a hash.
thumb_name() {
    local rel="${1#$WALL_DIR/}"
    rel="${rel%.*}"
    local n="${rel//_/_u}"
    n="${n//\//_s}"
    if [ ${#n} -gt 200 ]; then
        n="h_$(printf '%s' "$1" | md5sum | cut -d' ' -f1)"
    fi
    REPLY="$n.jpg"
}

# New thumbnail settings -> throw the old ones away once
if [ "$(cat "$CACHE_DIR/.scheme" 2>/dev/null)" != "$SCHEME" ]; then
    rm -f "$CACHE_DIR"/*.jpg "$CACHE_SIG" "$CACHE_LIST"
    printf '%s\n' "$SCHEME" > "$CACHE_DIR/.scheme"
fi

# Current wallpaper index: path, mtime, size
listing=$(mktemp)
find -H "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.avif' \) -printf '%p\t%T@\t%s\n' \
    | sort -t $'\t' -k1,1 > "$listing"

sig=$({ echo "$SCHEME"; cat "$listing"; } | md5sum | cut -d' ' -f1)

# Fast path: nothing was added, removed or changed since the last run
if [ -s "$CACHE_LIST" ] && [ "$(cat "$CACHE_SIG" 2>/dev/null)" = "$sig" ]; then
    rm -f "$listing"
else
    # Work out which thumbnails are missing or out of date. Thumbnails get their
    # source file's timestamp, so a replaced wallpaper (even with an older
    # timestamp) no longer matches and is regenerated.
    to_generate=$(mktemp)
    imgs=()
    names=()
    while IFS=$'\t' read -r img _; do
        [ -n "$img" ] || continue
        thumb_name "$img"
        imgs+=("$img")
        names+=("$REPLY")
        cache_file="$CACHE_DIR/$REPLY"
        if [ ! -f "$cache_file" ] || [ "$img" -nt "$cache_file" ] || [ "$cache_file" -nt "$img" ]; then
            printf '%s\0%s\0' "$img" "$cache_file" >> "$to_generate"
        fi
    done < "$listing"
    rm -f "$listing"

    # Generate thumbnails in parallel on all cores
    export PROGRESS
    PROGRESS=$(mktemp)
    max_jobs=$(nproc 2>/dev/null || echo 4)

    generate_thumbnail() {
        local img="$1" out="$2"
        local tmp="${out%.jpg}.tmp.jpg"
        local src="$img"
        [[ "$img" =~ \.(gif|GIF)$ ]] && src="${img}[0]"

        # -define jpeg:size= hints the decoder not to decode full resolution,
        # -filter Triangle is faster than the default Lanczos.
        if magick "$src" -define jpeg:size=1600x1200 -filter Triangle -strip \
            -thumbnail 800x600^ -gravity center -extent 800x600 \
            -quality 80 +repage "$tmp" 2>/dev/null; then
            mv -f "$tmp" "$out" && touch -r "$img" "$out" && echo 1 >> "$PROGRESS"
        else
            rm -f "$tmp"
        fi
    }
    export -f generate_thumbnail

    if [ -s "$to_generate" ]; then
        xargs -0 -n 2 -P "$max_jobs" bash -c 'generate_thumbnail "$1" "$2"' _ < "$to_generate"
    fi
    generated=$(wc -l < "$PROGRESS" 2>/dev/null || echo 0)
    [ "$generated" -gt 0 ] && echo "Generated $generated thumbnails" || echo "Cache up to date"
    rm -f "$to_generate" "$PROGRESS"

    # Picker list: <relative name> TAB <thumbnail> TAB <full path>
    list_tmp=$(mktemp)
    for i in "${!imgs[@]}"; do
        f="$CACHE_DIR/${names[i]}"
        [ -f "$f" ] && printf '%s\t%s\t%s\n' "${imgs[i]#$WALL_DIR/}" "$f" "${imgs[i]}"
    done > "$list_tmp"

    # Remove thumbnails whose wallpaper is gone (and any leftovers)
    comm -13 \
        <(printf '%s\n' "${names[@]}" | LC_ALL=C sort) \
        <(find "$CACHE_DIR" -maxdepth 1 -name '*.jpg' -printf '%f\n' | LC_ALL=C sort) \
        | while IFS= read -r stale; do rm -f "$CACHE_DIR/$stale"; done

    mv -f "$list_tmp" "$CACHE_LIST"
    printf '%s\n' "$sig" > "$CACHE_SIG"
fi

# Show the picker; selecting a wallpaper runs apply.sh
export QS_NO_RELOAD_POPUP=1

# readlink without -f: the exact path apply.sh stored, which matches the list
# even when the wallpaper folder is itself a symlink.
BGSEL_LIST="$CACHE_LIST" \
BGSEL_APPLY="$SCRIPT_DIR/apply.sh" \
BGSEL_CURRENT="$(readlink "$HOME/.cache/current-wallpaper" 2>/dev/null)" \
    quickshell -p "$SCRIPT_DIR" 9>&-
