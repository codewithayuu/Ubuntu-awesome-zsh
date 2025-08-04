# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ayu/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ayu/.fzf/bin"
fi

source <(fzf --zsh)
