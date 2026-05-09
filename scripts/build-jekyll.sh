#!/usr/bin/env bash
# Emit static HTML under docs/_site using the same GitHub Pages gem stack.
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

bundle exec jekyll build "$@"
echo "Built site -> ${ROOT}/docs/_site/"
