#!/bin/bash

# Ayush's Ubuntu Zsh Installer
# Location-independent script to install Zsh environment

echo -e "\n🔧 Installing required tools..."

# --- Install packages ---
sudo apt update
sudo apt install -y git curl unzip zoxide fzf bat eza ugrep zsh

# --- Install Zinit ---
ZINIT_DIR="$HOME/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_DIR" ]; then
  echo "📦 Installing Zinit..."
  mkdir -p "$(dirname "$ZINIT_DIR")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_DIR"
else
  echo "✅ Zinit already installed."
fi

# --- Install NVM ---
NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  echo "📦 Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "✅ NVM already installed."
fi

# --- Restore fzf ---
if [ ! -d "$HOME/.fzf" ]; then
  echo "📦 Installing fzf from repo..."
  cp -r ./fzf "$HOME/.fzf"
  "$HOME/.fzf/install" --all
else
  echo "✅ fzf already installed."
fi

# --- Copy Dotfiles ---
echo -e "\n📂 Restoring config files..."

declare -A FILES=(
  ["zshrc.bak"]="$HOME/.zshrc"
  [".fzf.zsh"]="$HOME/.fzf.zsh"
  ["nvm"]="$HOME/.nvm"
  ["zinit"]="$HOME/.local/share/zinit"
  ["zoxide"]="$HOME/.local/share/zoxide"
)

for src in "${!FILES[@]}"; do
  dest="${FILES[$src]}"
  if [ -e "./$src" ]; then
    echo "📁 Restoring $src → $dest"
    mkdir -p "$(dirname "$dest")"
    cp -r "./$src" "$dest"
  else
    echo "⚠️  Missing: $src — skipping"
  fi
done

# --- Set Zsh as default ---
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
  echo -e "\n⚙️ Changing shell to zsh..."
  chsh -s /usr/bin/zsh
fi

echo -e "\n🎉 Done! Run this to apply your new config:\n\n  source ~/.zshrc\n"
