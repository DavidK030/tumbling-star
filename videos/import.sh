#!/bin/bash
# Turn raw phone clips into app-ready exercise videos.
#
#   ./videos/import.sh ~/Desktop/rohclips
#
# Every file in the source folder is expected to be named after its exercise
# key (hampelmann.mov, bruecke.MP4, ...). Output: videos/<key>.mp4, 640px wide,
# silent, h264, web-optimised — roughly 150-400 KB for a 4 second clip.
set -euo pipefail

SRC="${1:-}"
DEST="$(cd "$(dirname "$0")" && pwd)"
INDEX="$(dirname "$DEST")/index.html"

if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "usage: $0 <folder-with-raw-clips>" >&2
  exit 1
fi

shopt -s nullglob nocaseglob
converted=()
for f in "$SRC"/*.{mp4,mov,m4v}; do
  key="$(basename "${f%.*}" | tr '[:upper:]' '[:lower:]')"
  if ! grep -q "^  $key:{title:" "$INDEX"; then
    echo "  ?  $key — kein passender Übungs-Key in index.html, übersprungen"
    continue
  fi
  ffmpeg -loglevel error -y -i "$f" \
    -vf "scale=640:-2,fps=25" \
    -c:v libx264 -profile:v baseline -level 3.1 -crf 30 -preset slow \
    -pix_fmt yuv420p -movflags +faststart -an \
    "$DEST/$key.mp4"
  size=$(du -h "$DEST/$key.mp4" | cut -f1)
  echo "  ok $key.mp4 ($size)"
  converted+=("$key")
done

if [ ${#converted[@]} -eq 0 ]; then
  echo "Keine passenden Clips gefunden."
  exit 0
fi

echo
echo "${#converted[@]} Clips konvertiert. Diese Keys in index.html eintragen (HAS_VIDEO):"
printf '"%s",' "${converted[@]}" | sed 's/,$//'
echo
