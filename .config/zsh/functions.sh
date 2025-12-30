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
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Use Python 3's http.server module
	python3 -m http.server "$port"
}