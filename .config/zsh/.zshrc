# zsh configuration

# improved history settings
setopt EXTENDED_HISTORY       # record timestamp and duration
setopt SHARE_HISTORY          # share history across sessions
setopt APPEND_HISTORY         # append to history file
setopt INC_APPEND_HISTORY     # immediately append to history
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS       # ignore consecutive duplicates
setopt HIST_FIND_NO_DUPS      # don't show duplicates in search
setopt HIST_REDUCE_BLANKS     # remove superfluous blanks
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt CORRECT                # correct typos
setopt HIST_VERIFY            # show before executing history
setopt PROMPT_SUBST           # enable prompt substitution
setopt AUTO_CD                # change directory without cd
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shell

# disable control-s/control-q flow control
stty stop undef
stty start undef

# granted AWS role assumption (load before compinit for tab completion)
test -f $HOME/.config/zsh/.zshenv && source $HOME/.config/zsh/.zshenv

# improved completion
autoload -Uz compinit; compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' matcher-list \
  'm:{[:lower:]}={[:upper:]}' \
  '+r:|[._-]=* r:|=*' \
  '+l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true  # auto-update PATH completions
zmodload zsh/complist
_comp_options+=(globdots)  # include hidden files

# homebrew + zsh plugins
if [ -d "/opt/homebrew" ]; then  # arm
  export BREW_PREFIX="/opt/homebrew"
  test -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$PATH:$BREW_PREFIX/bin"
elif [ -d "/usr/local/Homebrew" ]; then  # intel
  export BREW_PREFIX="/usr/local/Homebrew"
  test -f $BREW_PREFIX/../share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/../share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$PATH:$BREW_PREFIX/bin"
fi

test -d $HOME/.local/bin && PATH="$HOME/.local/bin:$PATH"  # local binaries to PATH
test -d $HOME/.atuin/bin && PATH="$HOME/.atuin/bin:$PATH"  # atuin to PATH

# prompt
export PROMPT='%n%F{245}@%f%B%M%b%F{245}:%20<..<%3~%<<%f%B%#%b '
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # Check if oh-my-posh is available
  if command -v oh-my-posh >/dev/null 2>&1; then
    # Use Oh My Posh with Catppuccin theme (Nerd Font version)
    eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/chippuccin.toml")" 2>/dev/null || true
  else
    # Fallback to a nice ZSH prompt if oh-my-posh is not available
    export PROMPT='%F{cyan}%n%f%F{245}@%f%F{green}%M%f%F{245}:%f%F{blue}%~%f %F{yellow}❯%f '
  fi
fi


# extra functions for zsh
test -f $HOME/.config/zsh/functions.sh && source $HOME/.config/zsh/functions.sh

# private settings, like API keys and sensitive functions
test -f $HOME/.config/zsh/private.sh && source $HOME/.config/zsh/private.sh

# key bindings
# run `cat` and type your keys to get the sequences
bindkey -e  # no vi mode

bindkey '^r'   history-incremental-search-backward  # control-r
bindkey '^[[A' history-search-backward              # up
bindkey '^[[B' history-search-forward               # down

bindkey '^[^[[D' backward-word  # alt-left
bindkey '^[^[[C' forward-word   # alt-right

bindkey '^[[H'  beginning-of-line  # home
bindkey '^[[F'  end-of-line        # end
bindkey '^[[3~' delete-char        # del

bindkey '^[[1;9C' end-of-line        # cmd-right
bindkey '^[[1;9D' beginning-of-line  # cmd-left

bindkey '^U' backward-kill-line  # control+U
bindkey '^K' kill-line           # control+K

# os-specific aliases
case "$OSTYPE" in
  linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
  *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
  msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac

# Modern CLI tools integration
# mise (runtime version manager)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Note: We use Oh My Posh instead of Starship (configured above in prompt section)

# fzf (fuzzy finder)
if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
  fi
  if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  fi
fi

# atuin (shell history)
if command -v atuin &> /dev/null; then
  export ATUIN_NOBIND=true
  eval "$(atuin init zsh)"
  bindkey "^R" atuin-search
fi

# zsh plugins (system packages)
if [ -d /usr/share/zsh/plugins/zsh-autosuggestions ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ]; then
  # oh-my-posh must init before syntax-highlighting
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Force English language for PostgreSQL and other tools
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

alias c='claude'
alias ch='claude --chrome'
alias gb='github'
alias co='code'
alias q='cd ~/Documents/projects'