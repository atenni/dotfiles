#!/usr/bin/env bash

# ------------------------------------ #
# Local overrides (not tracked in git) #
# ------------------------------------ #
# shellcheck disable=SC1091
[[ -e "${BASH_SOURCE%/*}/functions.local.sh" ]] && source "${BASH_SOURCE%/*}/functions.local.sh"
