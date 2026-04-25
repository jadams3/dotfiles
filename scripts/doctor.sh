#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

bash -n setup-modern.sh bootstrap.sh brew.sh

if command -v fish >/dev/null 2>&1; then
	fish --no-config -n config/fish/config.fish config/fish/functions/*.fish
else
	echo "Skipping fish syntax checks: fish is not installed." >&2
fi

if command -v brew >/dev/null 2>&1; then
	brew bundle check --file Brewfile
else
	echo "Skipping Brewfile check: Homebrew is not installed." >&2
fi

git diff --check
