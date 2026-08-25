#!/bin/bash
# Start the sync server. Nothing to install - plain Node, no dependencies.
#
#   ./server/start.sh              → http://localhost:8770
#   PORT=9000 ./server/start.sh    → different port
#
# Children reach it from other devices in the same network via the address
# printed below. Progress lands in server/data.json, which is gitignored:
# it holds children's data and must never end up in the repository.
cd "$(dirname "$0")/.."
PORT="${PORT:-8770}"
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
echo "Im Netzwerk erreichbar unter:"
echo "  App:     http://$IP:$PORT/"
echo "  Trainer: http://$IP:$PORT/coach.html"
echo
exec node server/server.js
