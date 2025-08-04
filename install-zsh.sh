#!/bin/bash

# Ayush's Zsh Config install Script
# ----------------------------------

BACKUP_DIR="$HOME/zsh-backup"

# Paths to restore (key = source in backup, value = destination)
declare -A RESTORE_TARGETS=(
  [".zshrc"]="$HOME/.zshrc"
  ["zinit"]="$HOME/.local/share/zinit"
  ["fzf"]="$HOME/.fzf"
  [".fzf.zsh"]="$HOME/.fzf.zsh"
  ["nvm"]="$HOME/.nvm"
  ["zoxide"]="$HOME/.local/share/zoxide"
)

# Terminal colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

echo -e "${YELLOW}🔁 Starting Zsh environment restore...${NC}"

for key in "${!RESTORE_TARGETS[@]}"; do
  src="$BACKUP_DIR/$key"
  dest="${RESTORE_TARGETS[$key]}"

  if [ -e "$src" ]; then
    # Backup current destination if exists
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

echo -e "\n${GREEN}🎉 Restore completed!"
echo -e "${YELLOW}➡️  Run this to apply your config: ${NC}source ~/.zshrc"

