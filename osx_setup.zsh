#!/bin/zsh
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - https://gist.github.com/bradp/bea76b16d3325f5c47d4
# - https://gist.github.com/codeinthehole/26b37efa67041e1307db

echo "Starting bootstrapping"

echo "Installing xcode related tools"
xcode-select --install

# Check for Homebrew, install if we don't have it
if ! [ -x "$(command -v brew)" ]; then
    echo "Installing homebrew..."
    yes '' | /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
brew update

echo "Installing git..."
if ! [ -x "$(command -v git)" ]; then
    brew install git
fi

echo "Creating .zshrc with git configs"
if [ ! -s ~/.zshrc ]; then
    curl -fsSL https://raw.githubusercontent.com/benjamindimant/osx-terminal-config/master/.zshrc >> ~/.zshrc
    echo "\n# git" >> ~/.zshrc
    echo "zstyle ':completion:*:*:git:*' script $(brew --prefix)/share/zsh/site-functions/git-completion.bash" >> ~/.zshrc
    echo "autoload -Uz compinit && compinit" >> ~/.zshrc
    echo "setopt noautomenu" >> ~/.zshrc
    echo "setopt nomenucomplete" >> ~/.zshrc
fi

echo "Installing cask apps..."
CASKS=(
    dropbox
    firefox
    google-chrome
    macvim
    mactex
    texmaker
    github
)
brew cask install ${CASKS[@]}

echo "Set up vim..."
if ! [ -s ~/.vimrc ]; then
    curl -fsSL https://raw.githubusercontent.com/benjamindimant/vim-config/master/vimrc-vanilla >> ~/.vimrc
fi

echo "Installing pyenv..."
if ! [ -x "$(command -v pyenv)" ]; then
    brew install pyenv
    echo "\n# pyenv" >> ~/.zshrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
fi

echo "Installing nvm..."
if [ ! -d ~/.nvm ]; then
    (
        git clone https://github.com/nvm-sh/nvm.git ~/.nvm
        git --git-dir ~/.nvm/.git checkout `git --git-dir ~/.nvm/.git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    )
    echo "\n# nvm" >> ~/.zshrc
    echo "export NVM_DIR=\"\$HOME/.nvm\"" >> ~/.zshrc
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm" >> ~/.zshrc
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc
fi

echo "Creating folder structure..."
[[ ! -d ~/Code ]] && mkdir ~/Code

echo "Cleaning up..."
brew cleanup
killall Finder

echo "Bootstrapping complete"
