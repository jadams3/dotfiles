if status is-login
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv fish | source
    else if test -x /usr/local/bin/brew
        /usr/local/bin/brew shellenv fish | source
    end
end

fish_add_path --path $HOME/bin $HOME/.local/bin $HOME/.bun/bin

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx GPG_TTY (tty)
set -gx STARSHIP_CONFIG $HOME/.config/starship.toml

set -gx NODE_REPL_HISTORY $HOME/.node_history
set -gx NODE_REPL_HISTORY_SIZE 32768

if status is-interactive
    abbr --add g git
    abbr --add gs "git status --short"
    abbr --add gl "git log --oneline --graph --decorate -20"
    abbr --add gd "git diff"
    abbr --add dc "docker compose"
    abbr --add k kubectl

    if type -q eza
        alias ls "eza --color=auto --group-directories-first"
        alias l "eza --long --git --color=auto --group-directories-first"
        alias la "eza --long --all --git --color=auto --group-directories-first"
        alias tree "eza --tree --git-ignore --color=auto --group-directories-first"
    else
        alias l "ls -l"
        alias la "ls -la"
    end

    if type -q bat
        alias batp "bat --plain --paging=never"
    end

    if type -q nvim
        alias vim nvim
        alias vi nvim
    end

    if type -q starship
        starship init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q fzf
        fzf --fish | source
    end

    if type -q direnv
        direnv hook fish | source
    end
end
