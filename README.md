# John's dotfiles

Personal macOS dotfiles for a fish-first shell, Homebrew Bundle-managed tools,
Starship prompt, Ghostty, and a small set of modern command-line defaults.

This repository started as a fork of Mathias Bynens's dotfiles. The legacy
Bash/macOS files are still present for reference, but the maintained setup path
is `setup-modern.sh` plus the files under `config/`.

## Setup

Install Homebrew first, then run:

```bash
./setup-modern.sh
```

The setup script installs packages from `Brewfile`, links `config/fish` to
`~/.config/fish`, links `config/starship.toml`, links Ghostty config when
Ghostty is present, and installs Pi via npm when npm is available.

Useful setup options:

```bash
./setup-modern.sh --dry-run
./setup-modern.sh --skip-brew
./setup-modern.sh --skip-npm-global
```

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before symlinks
are created.

To make fish your login shell after setup:

```bash
echo "$(command -v fish)" | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
```

## Health Checks

Run the local repository checks with:

```bash
./scripts/doctor.sh
```

The doctor script checks Bash syntax, fish syntax, Homebrew Bundle state, and
Git whitespace errors.

## Obsidian + QMD

Obsidian is installed through Homebrew, and QMD is installed through npm as
`@tobilu/qmd` from `github.com/tobi/qmd`. That is the actively maintained QMD
line used by the current docs and Obsidian plugin. QMD provides local keyword,
vector, and hybrid search over Markdown notes.

The default local vault path for this setup is:

```text
~/Documents/Obsidian/Personal Knowledge
```

Use Obsidian Sync as the source of truth for vault contents across Macs. Create
or connect the remote vault from inside Obsidian, then sync it to the same local
path on each Mac. Do not put the same vault inside iCloud, Dropbox, OneDrive, or
a Git checkout while using Obsidian Sync.

After Obsidian Sync finishes on a Mac, register the vault with QMD:

```bash
./scripts/qmd-vault.sh
```

The script expects the vault folder to already exist. Create or connect it from
Obsidian first so Sync owns the vault lifecycle.

Generate vector embeddings when you are ready for the first model download:

```bash
./scripts/qmd-vault.sh --embed
```

Search the knowledge repository:

```bash
qmd search "agentic development" -c personal-knowledge
qmd vsearch "ideas for building better coding agents" -c personal-knowledge
qmd query "how should I build reusable agent skills?" -c personal-knowledge
```

Update QMD when new releases land:

```bash
./scripts/update-qmd.sh
```

Check the installed version and npm's latest version:

```bash
qmd --version
npm view @tobilu/qmd version dist-tags.latest repository.url
```

The QMD Semantic Search community plugin can be installed from Obsidian after
Sync is configured. Keep the QMD binary path as `qmd` unless your shell cannot
find npm global binaries.

## Repository Layout

- `Brewfile`: Homebrew formulae and casks for the maintained setup.
- `setup-modern.sh`: primary installer for a new Mac.
- `scripts/qmd-vault.sh`: registers the Obsidian vault as a QMD collection.
- `scripts/update-qmd.sh`: updates the QMD CLI from npm.
- `config/fish/`: fish shell config and functions.
- `config/starship.toml`: Starship prompt config.
- `config/ghostty/`: Ghostty terminal config.
- `bootstrap.sh`, `brew.sh`, `.macos`, and older Bash dotfiles: legacy upstream
  files kept for reference. Review them before running; they are not the main
  setup path.

## Upstream

The `upstream` remote points to `mathiasbynens/dotfiles` for reference. This
repo is maintained as a personal dotfiles repo, so upstream changes should be
cherry-picked or ported deliberately instead of merged wholesale.

Useful upstream ideas already ported include modern Git defaults such as
`push.default=simple`, `init.defaultBranch=main`, branch sorting by recent
activity, and recursive submodule pulls.

## License

This repository retains the original MIT license from the upstream fork. See
`LICENSE-MIT.txt`.
