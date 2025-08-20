# Get the directory containing this file, following symlinks:
script_path="${(%):-%x}"       # Get path to current script (Zsh version of ${BASH_SOURCE[0]})
real_path="${script_path:A}"   # Resolve any symlinks (Zsh modifier)
DOTFILES_DIR="${real_path:h}"  # Get directory portion (Zsh "head" modifier)


# Define export/alias/function "global variables"
for module in exports aliases functions; do  # "exports" need to be first
  # Source common config modules
  source "$DOTFILES_DIR/$module/$module.sh"
  # Source ".local" overrides if they exist
  [[ -f "$DOTFILES_DIR/$module/$module.local.sh" ]] && source "$DOTFILES_DIR/$module/$module.local.sh"
done


# Ensure XDG directories exist
for xdg_dir in \
  "$XDG_CONFIG_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_STATE_HOME" \
  "$XDG_BIN_HOME"; do
  [ -d "$xdg_dir" ] || mkdir -p -- "$xdg_dir"
done


# HOMEBREW #
# -------- #
# Portable version of `eval "$(/opt/homebrew/bin/brew shellenv)"`
# See: https://docs.brew.sh/Tips-and-Tricks#load-homebrew-from-the-same-dotfiles-on-different-operating-systems
for brew_path in \
  /opt/homebrew/bin/brew \
  /home/linuxbrew/.linuxbrew/bin/brew \
  /usr/local/bin/brew; do
  if [[ -x "$brew_path" ]]; then
    eval "$($brew_path shellenv)"
    break
  fi
done


# SSH AGENT #
# --------- #
# Initiate for every interactive shell. Silence stdout only.
eval "$(ssh-agent -s)" > /dev/null


# ZSH: PURE PROMPT #
# ---------------- #
# Manually installed as per: https://github.com/sindresorhus/pure
fpath+=($CODE_DIR/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure


# ZSH: ENABLE AUTOCOMPLETE #
# ----------------------- #
autoload -Uz compinit
compinit


# ------------------------ #
# FINISH WITH PATH UPDATES #
# ------------------------ #
# We want these to come after things like `brew shellenv` above

# Source common config modules
source "$DOTFILES_DIR/paths/paths.sh"
# Source ".local" overrides if they exist
[[ -f "$DOTFILES_DIR/paths/paths.local.sh" ]] && source "$DOTFILES_DIR/paths/paths.local.sh"
