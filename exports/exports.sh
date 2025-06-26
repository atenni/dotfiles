#!/usr/bin/env bash


# -------------- #
# PERSONAL STUFF #
# -------------- #
# Parent directory for all software dev projects
# (Override in "./exports.local.sh" as needed)
export CODE_DIR=${CODE_DIR:-$HOME/code}

# ---------- #
# XDG CONFIG #
# ---------- #
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
# Not a standard XDG variable, but commonly used for user-installed binaries (eg. `uv`)
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
# XDG_RUNTIME_DIR – 2025-06-26: I'm gonna skip this one on macOS for now

# Ensure Zsh directories exist.
for zdir in \
  "$XDG_CONFIG_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_STATE_HOME"; do
  [ -d "$zdir" ] || mkdir -p -- "$zdir"
done

# --------------- #
# LOCALE SETTINGS #
# --------------- #
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8



# -------- #
# HOMEBREW #
# -------- #
export HOMEBREW_NO_ANALYTICS=1




