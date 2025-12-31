# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Almost unlimited bash history
export HISTSIZE=1000000
export HISTFILESIZE=2000000
export HISTFILE=~/.bash_history
PROMPT_COMMAND="history -a; history -n"
shopt -s histappend

# Keep duplicates and timestamps
export HISTCONTROL=
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "

# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# use vim everywhere (instead of nano)
export EDITOR=vim
export VISUAL=vim

# Load Alias, Logon, and Functions
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "$DOTFILES_DIR/.bash/alias.sh" ]] && source "$DOTFILES_DIR/.bash/alias.sh"
[[ -f "$DOTFILES_DIR/.bash/logon.sh" ]] && source "$DOTFILES_DIR/.bash/logon.sh"
[[ -f "$DOTFILES_DIR/.bash/dice.sh" ]] && source "$DOTFILES_DIR/.bash/dice.sh"
[[ -f "$DOTFILES_DIR/.bash/file_ops.sh" ]] && source "$DOTFILES_DIR/.bash/file_ops.sh"
[[ -f "$DOTFILES_DIR/.bash/temp.sh" ]] && source "$DOTFILES_DIR/.bash/temp.sh"

# Load Starship
eval "$(starship init bash)"