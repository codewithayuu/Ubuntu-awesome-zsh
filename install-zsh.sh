#!/bin/bash

# Ayush's Ultimate Zsh Environment Installer
# ------------------------------------------

set -e

BACKUP_DIR="$HOME/zsh-backup"
FONTS_DIR="$HOME/.local/share/fonts"

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

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔁 Starting full Zsh environment install...${NC}"

for src in "${!FILES[@]}"; do
  dest="${FILES[$src]}"
  if [ -e "./$src" ]; then
    echo -e "${GREEN}✅ Restoring $src → $dest${NC}"
    mkdir -p "$(dirname "$dest")"
    cp -r "./$src" "$dest"
  else
    echo -e "${YELLOW}⚠️  Missing: $src — skipping.${NC}"
  fi
done

# --- Set Zsh as default ---
echo -e "${YELLOW}🔧 Setting Zsh as default shell...${NC}"
chsh -s "$(which zsh)"

# --- Install Starship prompt ---
if ! command -v starship &>/dev/null; then
  echo -e "${YELLOW}🌟 Installing Starship prompt...${NC}"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo -e "${GREEN}✅ Starship already installed.${NC}"
fi

# --- Install Nerd Font (JetBrainsMono) ---
echo -e "${YELLOW}🔤 Installing JetBrainsMono Nerd Font...${NC}"
mkdir -p "$FONTS_DIR"
curl -L -o /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -qo /tmp/JetBrainsMono.zip -d "$FONTS_DIR"
fc-cache -fv > /dev/null
rm /tmp/JetBrainsMono.zip

# --- Starship preset ---
echo -e "${YELLOW}🎨 Applying Starship gruvbox-rainbow preset...${NC}"
mkdir -p ~/.config
starship preset gruvbox-rainbow -o ~/.config/starship.toml

# --- Install zoxide if needed ---
if ! command -v zoxide &>/dev/null; then
  echo -e "${YELLOW}📂 Installing zoxide...${NC}"
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  echo -e "${GREEN}✅ Zoxide already installed.${NC}"
fi

echo -e "\n${GREEN}🎉 Full install complete!"
echo -e "${YELLOW}➡️  Run this to apply your config: ${NC}source ~/.zshrc"

