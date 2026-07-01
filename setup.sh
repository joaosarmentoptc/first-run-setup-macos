#!/bin/bash

set -e

echo "🔧 Starting first run setup..."

# Install Oh My Zsh
echo "📦 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

# Install Homebrew
echo "📦 Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed."
fi

echo "🔄 Updating and upgrading Homebrew..."
brew update
brew upgrade

# Install ZSH plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "🔌 Installing ZSH plugins..."

declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
  ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete"
)

for plugin in "${!plugins[@]}"; do
  target_dir="${ZSH_CUSTOM}/plugins/${plugin}"
  if [ ! -d "$target_dir" ]; then
    echo "🔗 Installing $plugin..."
    git clone "${plugins[$plugin]}" "$target_dir"
  else
    echo "✅ Plugin $plugin already exists."
  fi
done

# Update .zshrc
echo "⚙️ Configuring .zshrc..."

ZSHRC="$HOME/.zshrc"
# Replace plugins line
if grep -q "^plugins=" "$ZSHRC"; then
  sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC"
else
  echo "plugins=(git zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete)" >>"$ZSHRC"
fi

# Add unsetopt CASE_GLOB if not already present
if ! grep -q "unsetopt CASE_GLOB" "$ZSHRC"; then
  echo "unsetopt CASE_GLOB" >>"$ZSHRC"
fi

# Install brew casks
echo "🍺 Installing brew casks..."

brew install --cask \
  bitwarden \
  brave-browser \
  dbeaver-community \
  docker-desktop \
  finicky \
  font-hack-nerd-font \
  freelens \
  ghostty \
  keka \
  maccy \
  macs-fan-control \
  mactex \
  microsoft-auto-update \
  microsoft-teams \
  mongodb-compass \
  ngrok \
  nordvpn \
  notion \
  onlyoffice \
  postman \
  sublime-text \
  transmission \
  tuxera-ntfs \
  vlc \
  whatsapp

echo "🎉 Setup complete! Restart your terminal to apply all changes."
