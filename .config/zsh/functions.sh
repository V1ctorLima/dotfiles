#!/usr/bin/env bash
# shell functions

function pingts() {
  # timestamped ping
  ping "$1" | xargs -L 1 -I '{}' date '+%H:%M:%S - {}'
}

function cheat() {
  # cheat.sh wrapper
  curl -s cheat.sh/"$1" | less -R
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}