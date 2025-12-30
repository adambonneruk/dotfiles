# Load Alias, Logon, and Functions
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "$DOTFILES_DIR/.bash/alias.sh" ]] && source "$DOTFILES_DIR/.bash/alias.sh"
[[ -f "$DOTFILES_DIR/.bash/logon.sh" ]] && source "$DOTFILES_DIR/.bash/logon.sh"
[[ -f "$DOTFILES_DIR/.bash/dice.sh" ]] && source "$DOTFILES_DIR/.bash/dice.sh"
[[ -f "$DOTFILES_DIR/.bash/temp.sh" ]] && source "$DOTFILES_DIR/.bash/temp.sh"

# Load Starship
eval "$(starship init bash)"