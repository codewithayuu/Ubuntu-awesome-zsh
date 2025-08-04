#!/bin/bash

<<<<<<< HEAD
# Ayush's Ultimate Zsh Environment Installer
# ------------------------------------------

set -e

BACKUP_DIR="$HOME/zsh-backup"
FONTS_DIR="$HOME/.local/share/fonts"
=======
# Ayush's Ubuntu Zsh Installer
# Location-independent script to install Zsh environment

echo -e "\n🔧 Installing required tools..."
>>>>>>> ba667cbe9e97b3f084725f8f191fc79cbf408fb1

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

<<<<<<< HEAD
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔁 Starting full Zsh environment install...${NC}"

# Backup and restore all components
for key in "${!RESTORE_TARGETS[@]}"; do
  src="$BACKUP_DIR/$key"
  dest="${RESTORE_TARGETS[$key]}"

  if [ -e "$src" ]; then
    if [ -e "$dest" ]; then
      echo -e "${RED}🛑 $dest already exists. Creating backup at $dest.restore.bak...${NC}"
      cp -r "$dest" "$dest.restore.bak"
    fi

    echo -e "${GREEN}✅ Restoring $key → $dest${NC}"
=======
for src in "${!FILES[@]}"; do
  dest="${FILES[$src]}"
  if [ -e "./$src" ]; then
    echo "📁 Restoring $src → $dest"
>>>>>>> ba667cbe9e97b3f084725f8f191fc79cbf408fb1
    mkdir -p "$(dirname "$dest")"
    cp -r "./$src" "$dest"
  else
    echo "⚠️  Missing: $src — skipping"
  fi
done

<<<<<<< HEAD
# Set Zsh as default shell
echo -e "${YELLOW}🔧 Setting Zsh as default shell...${NC}"
chsh -s "$(which zsh)"

# Install starship if not present
if ! command -v starship &>/dev/null; then
  echo -e "${YELLOW}🌟 Installing Starship prompt...${NC}"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Nerd Font (JetBrainsMono)
echo -e "${YELLOW}🔤 Installing JetBrainsMono Nerd Font...${NC}"
mkdir -p "$FONTS_DIR"
curl -L -o /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -qo /tmp/JetBrainsMono.zip -d "$FONTS_DIR"
fc-cache -fv > /dev/null
rm /tmp/JetBrainsMono.zip

# Install starship gruvbox-rainbow preset
echo -e "${YELLOW}🎨 Applying Starship gruvbox-rainbow preset...${NC}"
mkdir -p ~/.config
starship preset gruvbox-rainbow -o ~/.config/starship.toml

# Install zoxide if not present
if ! command -v zoxide &>/dev/null; then
  echo -e "${YELLOW}📂 Installing zoxide...${NC}"
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

echo -e "\n${GREEN}🎉 Full install complete!"
echo -e "${YELLOW}➡️  Run this to apply your config: ${NC}source ~/.zshrc"
=======
# --- Set Zsh as default ---
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
  echo -e "\n⚙️ Changing shell to zsh..."
  chsh -s /usr/bin/zsh
fi

echo -e "\n🎉 Done! Run this to apply your new config:\n\n  source ~/.zshrc\n"
>>>>>>> ba667cbe9e97b3f084725f8f191fc79cbf408fb1
