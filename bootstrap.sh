#!/usr/bin/env bash

# This script is idempotent and can be run multiple times without issues:
#
# - If a dot file doesn't exist it will be symlinked to the home directory
# - If a dot file already exists it will skip that step
#
# - If an application doesn't exist it will be installed
# - If an application is already installed it will skip that step
#
# Alternatively pass in the `--upgrade` flag to upgrade all existing applications:
#
#   `./bootstrap.sh --upgrade`

set -euo pipefail

####################
# DEFINE FUNCTIONS #  (see the bottom of this file for execution order)
####################

# Symlink all files/folders starting with `.` to the home directory.
# Skip files that already exist.
link_dotfiles() {
  echo
  echo "----------------------------------"
  echo "Linking dotfiles to home directory"
  echo "----------------------------------"
  for file in .??*; do
    # Skip the special directories
    if [[ "$file" == ".git" || "$file" == ".DS_Store" || "$file" == ".gitignore" ]]; then
      continue
    fi
    if [[ -e "$HOME/$file" ]]; then
      echo "› Skipping $file, already exists in home directory"
      continue
    fi
    ln -s "$(pwd)/$file" "$HOME/$file"
    echo "› Linked $file to home directory"
  done

  # Special case for .config/git/ignore
  mkdir -p "$HOME/.config/git"
  if [[ ! -e "$HOME/.config/git/ignore" ]]; then
    ln -s "$(pwd)/.config/git/ignore" "$HOME/.config/git/ignore"
    echo "› Linked .config/git/ignore to $HOME/.config/git/ignore"
  else
    echo "› Skipping .config/git/ignore, already exists in home directory"
  fi
}

install_homebrew() {
  echo
  echo "----------------------------------"
  echo "Checking for Homebrew installation"
  echo "----------------------------------"
  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    read -rp "› Homebrew not found. Would you like to install it now? [y/N]: " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo "› Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo "› Homebrew installation complete."
    else
      echo "› Homebrew is required. Exiting." >&2
      exit 1
    fi

  # If --upgrade flag is passed, update Homebrew itself
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› running: brew update"
    brew update
  else
    echo "› Homebrew is already installed, skipping."
  fi
}

install_homebrew_apps() {
  echo
  echo "--------------------------------------"
  echo "Installing Homebrew apps from Brewfile"
  echo "--------------------------------------"
  if [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading all applications in Brewfile..."
    echo "› running: brew bundle --file=\"$HOME/.Brewfile\""
    brew bundle --file="$HOME/.Brewfile"

    if [[ -f "$HOME/.Brewfile.local" ]]; then
      echo "› Upgrading local applications in Brewfile.local..."
      echo "› running: brew bundle --file=\"$HOME/.Brewfile.local\""
      brew bundle --file="$HOME/.Brewfile.local"
    fi

  else
    echo "› Installing missing applications from Brewfile (no upgrade)..."
    echo "› running: brew bundle --no-upgrade --file=\"$HOME/.Brewfile\""
    brew bundle --no-upgrade --file="$HOME/.Brewfile"

    if [[ -f "$HOME/.Brewfile.local" ]]; then
      echo "› Installing missing local applications from Brewfile.local (no upgrade)..."
      echo "› running: brew bundle --no-upgrade --file=\"$HOME/.Brewfile.local\""
      brew bundle --no-upgrade --file="$HOME/.Brewfile.local"
    fi

  fi
}

install_asdf() {
  echo
  echo "------------"
  echo "Install asdf"
  echo "------------"

  # Install or upgrade asdf via Homebrew
  if ! command -v asdf &>/dev/null; then
    echo "› Installing asdf via Homebrew..."
    echo "› running: brew install asdf"
    brew install asdf
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading asdf via Homebrew..."
    echo "› running: brew upgrade asdf"
    brew upgrade asdf
  else
    echo "› asdf already installed, skipping."
  fi  
}

install_asdf_plugins() {
  echo
  echo "--------------------"
  echo "Install asdf plugins"
  echo "--------------------"

  # Install or upgrade the nodejs plugin
  if ! asdf plugin list | grep -q '^nodejs$'; then
    echo "› Installing asdf nodejs plugin..."
    echo "› running: asdf plugin add nodejs <github-url>"
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading asdf nodejs plugin..."
    echo "› running: asdf plugin update nodejs"
    asdf plugin update nodejs
  else
    echo "› asdf nodejs plugin already installed, skipping."
  fi
}

install_asdf_tools() {
  echo
  echo "------------------"
  echo "Install asdf tools"
  echo "------------------"

  # Install or upgrade nodejs
  if ! asdf list nodejs | grep -q .; then
    echo "› Installing latest nodejs with asdf..."
    echo "› running: asdf install nodejs latest"
    asdf install nodejs latest
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading to latest nodejs with asdf..."
    echo "› running: asdf install nodejs latest"
    asdf install nodejs latest
  else
    echo "› Node.js already installed, skipping."
  fi
}

install_uv() {
  echo
  echo "----------"
  echo "Install uv"
  echo "----------"

  # Install or upgrade uv
  if ! command -v uv &>/dev/null; then
    echo "› Installing uv..."
    echo "› running: curl -LsSf https://astral.sh/uv/install.sh | sh"
    curl -LsSf https://astral.sh/uv/install.sh | sh
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading uv..."
    echo "› running: uv self update"
    uv self update
  else
    echo "› uv already installed, skipping."
  fi
}

install_python() {
  echo
  echo "--------------"
  echo "Install Python"
  echo "--------------"

  # Install or upgrade Python
  if ! uv python list --only-installed --managed-python | grep -q .; then
    echo "› Installing latest Python with uv..."
    echo "› running: uv python install"
    uv python install
  elif [[ "${*:-}" =~ --upgrade ]]; then
    echo "› Upgrading to latest Python patch release with uv..."
    echo "› running: uv python upgrade"
    uv python upgrade
  else
    echo "› Python already installed via uv, skipping."
  fi
}


################
# MAKE CHANGES #
################
link_dotfiles

# Install latest Python before Homebrew apps to reduce the number of other Pythons Homebrew installs
install_uv "$@"
install_python "$@"

# Install Homebrew (we need to do this now because we use it to install `asdf`)
install_homebrew "$@"

# Install latest Node before Homebrew apps to reduce the number of other Nodes Homebrew installs
install_asdf "$@"
install_asdf_plugins "$@"
install_asdf_tools "$@"

 # Install all the Homebrew applications
install_homebrew_apps "$@"
