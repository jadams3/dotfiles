#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
SKIP_BREW=0
SKIP_NPM_GLOBAL=0

usage() {
	cat <<EOF
Usage: ./setup-modern.sh [options]

Options:
  --dry-run          Print actions without changing files or installing packages.
  --skip-brew       Skip Homebrew Bundle installation.
  --skip-npm-global Skip global npm package installation.
  -h, --help        Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
	case "$1" in
	--dry-run)
		DRY_RUN=1
		;;
	--skip-brew)
		SKIP_BREW=1
		;;
	--skip-npm-global)
		SKIP_NPM_GLOBAL=1
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

run() {
	if [ "$DRY_RUN" -eq 1 ]; then
		printf 'Would run:'
		printf ' %q' "$@"
		printf '\n'
	else
		"$@"
	fi
}

backup_path() {
	local path="$1"

	if [ -e "$path" ] || [ -L "$path" ]; then
		run mkdir -p "$BACKUP_DIR"
		run mv "$path" "$BACKUP_DIR/"
		echo "Backed up ${path} to ${BACKUP_DIR}/"
	fi
}

link_path() {
	local source="$1"
	local target="$2"

	run mkdir -p "$(dirname "$target")"

	if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
		echo "Already linked ${target}"
		return
	fi

	backup_path "$target"
	run ln -s "$source" "$target"
	echo "Linked ${target} -> ${source}"
}

if [ "$SKIP_BREW" -eq 0 ]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew is required. Install it from https://brew.sh/ and run this script again." >&2
		exit 1
	fi

	run brew bundle --file "${DOTFILES_DIR}/Brewfile"
fi

link_path "${DOTFILES_DIR}/config/fish" "${HOME}/.config/fish"
link_path "${DOTFILES_DIR}/config/starship.toml" "${HOME}/.config/starship.toml"

if [ -d "${HOME}/Library/Application Support/com.mitchellh.ghostty" ]; then
	link_path "${DOTFILES_DIR}/config/ghostty/config.ghostty" "${HOME}/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
fi

if [ "$SKIP_NPM_GLOBAL" -eq 0 ]; then
	if command -v npm >/dev/null 2>&1; then
		run npm install -g @mariozechner/pi-coding-agent
	else
		echo "npm was not found. Install Node and rerun this script to install Pi." >&2
	fi
fi

fish_path="$(command -v fish || true)"
if [ -n "$fish_path" ]; then
	echo
	echo "Fish is installed at ${fish_path}."
	echo "To make it your login shell, run:"
	echo "  echo '${fish_path}' | sudo tee -a /etc/shells"
	echo "  chsh -s '${fish_path}'"
fi
