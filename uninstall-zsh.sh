#!/bin/bash

echo "🧼 Uninstalling custom Zsh environment..."

# --- Restore default shell ---
if [ "$SHELL" != "/bin/bash" ]; then
  echo "🔁 Changing default shell back to Bash..."
  chsh -s /bin/bash
fi

# --- Remove Zsh config files ---
echo "🗑️ Removing configs..."
rm -f ~/.zshrc
rm -f ~/.fzf.zsh
rm -rf ~/.config/starship.toml
rm -rf ~/.local/share/zinit
rm -rf ~/.local/share/zoxide
rm -rf ~/.nvm

# --- Remove fzf if installed manually ---
if [ -d "$HOME/.fzf" ]; then
  echo "🗑️ Removing fzf..."
  rm -rf ~/.fzf
fi

# --- Remove Starship binary ---
if command -v starship &> /dev/null; then
  echo "🗑️ Removing Starship..."
  rm -f ~/.cargo/bin/starship 2>/dev/null || true
  sudo rm -f /usr/local/bin/starship 2>/dev/null || true
fi

# --- Remove JetBrainsMono Nerd Font ---
FONT_DIR="$HOME/.local/share/fonts"
if compgen -G "$FONT_DIR/JetBrainsMonoNerdFont-*.ttf" > /dev/null; then
  echo "🗑️ Removing JetBrainsMono Nerd Font..."
  find "$FONT_DIR" -iname "JetBrainsMonoNerdFont-*" -delete
  fc-cache -f
fi

# --- Remove installed packages (optional) ---
echo "❌ Removing installed packages (optional)..."
sudo apt remove --purge -y \
  zsh  curl  fzf zoxide bat eza ugrep

sudo apt autoremove -y
sudo apt clean

echo "✅ Done. All related packages, configs, and fonts removed."

