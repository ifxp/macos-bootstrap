#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/
# set -euo pipefail

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities
brew install coreutils
brew install gnu-sed 
brew install gnu-tar 
brew install gnu-indent 
brew install gnu-which 
brew install grep 

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

PACKAGES=(
    ack
    age
    autoconf
    automake
    awscli
    azure-cli
    broot
    docker-compose
    fluxcd/tap/flux
    gh
    git
    hub
    jq
    kind
    kubernetes-cli
    markdown
    minikube
    node
    npm
    opentofu
    podman
    pyenv
    python
    python3
    pypy
    rename
    sops
    ssh-copy-id
    the_silver_searcher
    tree
    vim
    wget
    xq
    zsh
    zsh-completions
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Setting zsh as default shell"
chsh -s $(which zsh)

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Cleaning up..."
brew cleanup

#echo "Tapping cask..."
#brew tap homebrew/cask

# do we need to install microsoft-teams via cask?
CASKS=(
    alfred
    flutter
    google-chrome
    iterm2
    macdown
    mqttx
    postman
    rancher
    sourcetree
    sublime-text
    visual-studio-code
    zoom
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}


echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Bootstrapping complete"
