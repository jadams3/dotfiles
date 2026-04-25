#!/usr/bin/env bash
set -euo pipefail

if ! command -v npm >/dev/null 2>&1; then
	echo "npm is required to install QMD. Install Node with Homebrew first." >&2
	exit 1
fi

npm install -g @tobilu/qmd

if command -v qmd >/dev/null 2>&1; then
	mkdir -p "${XDG_CACHE_HOME:-${HOME}/.cache}/qmd"
	qmd --version
else
	echo "QMD installed, but qmd is not on PATH. Check your npm global bin path." >&2
	exit 1
fi
