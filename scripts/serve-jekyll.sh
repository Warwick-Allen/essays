#!/usr/bin/env bash
# Serve the GitHub Pages site locally using the same gem stack as github.com.
# Preview: http://127.0.0.1:4000/essays/  (see docs/_config.yml baseurl)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/docs"

if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler is required. Install Ruby, then: gem install bundler" >&2
  exit 1
fi

if ! bundle check >/dev/null 2>&1; then
  bundle install
fi

exec bundle exec jekyll serve "$@"
