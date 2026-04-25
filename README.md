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

## Repository Layout

- `Brewfile`: Homebrew formulae and casks for the maintained setup.
- `setup-modern.sh`: primary installer for a new Mac.
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
