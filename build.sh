#!/bin/bash
# Collect the files that belong in the shipped app into www/.
# Everything else in the repo (server, review pages, shot list) stays out.
set -e
cd "$(dirname "$0")"
rm -rf www && mkdir -p www
cp index.html manifest.json sw.js icon-192.png icon-512.png apple-touch-icon.png www/
cp -r fonts www/
if compgen -G "videos/*.mp4" > /dev/null; then
  mkdir -p www/videos && cp videos/*.mp4 www/videos/
fi
echo "www/ gebaut: $(du -sh www | cut -f1), $(find www -type f | wc -l | tr -d ' ') Dateien"
