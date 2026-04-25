#!/usr/bin/env bash
set -euo pipefail

DEFAULT_VAULT="${HOME}/Documents/Obsidian/Personal Knowledge"
COLLECTION_NAME="personal-knowledge"
COLLECTION_CONTEXT="Personal knowledge repository for links, notes, agentic development ideas, skills, and research."
RUN_EMBED=0
VAULT_PATH=""

usage() {
	cat <<EOF
Usage: ./scripts/qmd-vault.sh [--embed] [vault-path]

Registers an Obsidian vault as the QMD collection '${COLLECTION_NAME}'.

Arguments:
  vault-path   Vault folder to index. Defaults to:
               ${DEFAULT_VAULT}

Options:
  --embed      Generate vector embeddings after registering the collection.
  -h, --help   Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
	case "$1" in
	--embed)
		RUN_EMBED=1
		;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		echo "Unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	*)
		if [ -n "$VAULT_PATH" ]; then
			echo "Only one vault path may be provided." >&2
			usage >&2
			exit 2
		fi
		VAULT_PATH="$1"
		;;
	esac
	shift
done

VAULT_PATH="${VAULT_PATH:-$DEFAULT_VAULT}"

if ! command -v qmd >/dev/null 2>&1; then
	echo "qmd is required. Run ./scripts/update-qmd.sh or ./setup-modern.sh first." >&2
	exit 1
fi

mkdir -p "${XDG_CACHE_HOME:-${HOME}/.cache}/qmd"

if [ ! -d "$VAULT_PATH" ]; then
	echo "Vault path does not exist: ${VAULT_PATH}" >&2
	echo "Create or connect the vault in Obsidian Sync first, then rerun this script." >&2
	exit 1
fi

if qmd collection list | awk '{print $1}' | grep -Fxq "$COLLECTION_NAME"; then
	qmd collection remove "$COLLECTION_NAME"
fi

qmd collection add "$VAULT_PATH" --name "$COLLECTION_NAME" --mask "**/*.md"
qmd context add "qmd://${COLLECTION_NAME}" "$COLLECTION_CONTEXT"

if [ "$RUN_EMBED" -eq 1 ]; then
	qmd embed
else
	echo "Registered ${VAULT_PATH} as QMD collection '${COLLECTION_NAME}'."
	echo "Run ./scripts/qmd-vault.sh --embed when you are ready to download models and generate embeddings."
fi
