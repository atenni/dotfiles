#!/usr/bin/env bash

# -------------- #
# PERSONAL STUFF #
# -------------- #
# `-g` open Raycast in background, keeping Terminal in focus
alias cf="open -g raycast://confetti"

# ------------------------------------ #
# Local overrides (not tracked in git) #
# ------------------------------------ #
# shellcheck disable=SC1091
[[ -e "${BASH_SOURCE%/*}/aliases.local.sh" ]] && source "${BASH_SOURCE%/*}/aliases.local.sh"
