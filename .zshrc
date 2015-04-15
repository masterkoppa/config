# Read the antigen loader
source /home/andres/.config_git/antigen/antigen.zsh

# Load up oh my zsh
antigen use oh-my-zsh

# Load plugins
# plugins=(git archlinux command-not-found git-extras nyan systemd virtualenv) 

# Oh-my-zsh plugins
antigen bundle git
antigen bundle git-extras
antigen bundle archlinux
antigen bundle command-not-found
antigen bundle systemd
antigen bundle nyan
antigen bundle virtualenv
#antigen bundle last-working-dir

# ZSH Users Plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-history-substring-search

# Theme Setup
#antigen-bundle arialdomartini/oh-my-git
#antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

#antigen theme blinks

antigen apply


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"


# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git archlinux command-not-found git-extras nyan systemd virtualenv) 


# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
export DEFAULT_USER='andres'
# # Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Set the ssh agent
export SSH_ASKPASS="/etc/profile.d/ksshaskpass.sh"

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++


# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#export PYTHONPATH=/usr/lib/python3.3/site-packages
LANG=en_US.utf8

alias 'open'='xdg-open'

alias lola='git log --graph --decorate --pretty=oneline --abbrev-commit --all'

