#!/bin/bash

# Ayush's Ultimate Zsh Environment Installer
# ------------------------------------------

set -e

BACKUP_DIR="$HOME/zsh-backup"
FONTS_DIR="$HOME/.local/share/fonts"

# Paths to restore (key = source in backup, value = destination)
declare -A RESTORE_TARGETS=(
  [".zshrc"]="$HOME/.zshrc"
  ["zinit"]="$HOME/.local/share/zinit"
  ["fzf"]="$HOME/.fzf"
  [".fzf.zsh"]="$HOME/.fzf.zsh"
  ["nvm"]="$HOME/.nvm"
  ["zoxide"]="$HOME/.local/share/zoxide"
)

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
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
  else
    echo -e "${YELLOW}⚠️  $src not found — skipping.${NC}"
  fi
done

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
