#!/bin/bash

# Ayush's Zsh Uninstaller Script
# -------------------------------

set -e

echo "⚠️  This will completely remove your custom Zsh setup, config, fonts, Starship, and more."

read -p "Are you sure you want to continue? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Uninstall aborted."
  exit 1
fi

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Restore shell to bash
echo -e "${YELLOW}🔁 Switching default shell back to bash...${NC}"
chsh -s /bin/bash

# Remove custom config files and directories
echo -e "${YELLOW}🧹 Removing configs and plugins...${NC}"
rm -rf ~/.zshrc
rm -rf ~/.local/share/zinit
rm -rf ~/.fzf
rm -rf ~/.fzf.zsh
rm -rf ~/.nvm
rm -rf ~/.local/share/zoxide
rm -rf ~/.config/starship.toml

# Remove Starship if installed
if command -v starship &>/dev/null; then
  echo -e "${YELLOW}🗑️  Removing Starship binary...${NC}"
  rm -f ~/.cargo/bin/starship
fi

# Remove Nerd Fonts
FONTS_DIR="$HOME/.local/share/fonts"
echo -e "${YELLOW}🧽 Cleaning JetBrainsMono Nerd Font...${NC}"
find "$FONTS_DIR" -type f -name '*JetBrainsMono*.ttf' -delete || true
fc-cache -fv > /dev/null

# Remove zoxide binary if installed via script
if command -v zoxide &>/dev/null; then
  echo -e "${YELLOW}🗑️  Removing zoxide binary...${NC}"
  rm -f ~/.local/bin/zoxide
  rm -rf ~/.local/share/zoxide
fi

echo -e "${GREEN}✅ Uninstall complete. You may want to restart your terminal or log out & back in."
