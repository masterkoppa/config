# Determine what platform we are in, OS X or Linux
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='darwin'
else 
	echo "Unknown platform, can't run config"
	return
fi

# Read the antigen loader
source /home/andres/.config_git/antigen/antigen.zsh

# Load up oh my zsh
antigen use oh-my-zsh

# Load plugins

# Oh-my-zsh plugins
antigen bundle git
antigen bundle git-extras
antigen bundle command-not-found
antigen bundle nyan
antigen bundle virtualenv
antigen bundle rvm
#antigen bundle last-working-dir

# Platform specific plugins
if [[ $platform == 'linux' ]]; then
	antigen bundle systemd
	antigen bundle archlinux
elif [[ $platform == 'darwin' ]]; then
	antigen bundle brew
	antigen bundle osx
fi

# ZSH-Users Plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-history-substring-search

# Theme Setup

# Git Theme - Looks really nice, too little info outside of git. 
# Requires Powerline
#antigen-bundle arialdomartini/oh-my-git
#antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

# Powerline powered theme - Looks really nice, provides a good deal of info
antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Simple theme - No external requirements
#antigen theme blinks


# Solarized Tweaks
# Adds coloring to directory listings in ls, makes using solarized actually nice
antigen bundle joel-porquet/zsh-dircolors-solarized.git
setupsolarized dircolors.256dark

# Apply antigen settings!
antigen apply

# General config settings, here from the old oh-my-zsh days

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


# ENV Variables
export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
export DEFAULT_USER='andres'
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

if [[ $platform == 'linux' ]]; then
	# Compilation flags
	export ARCHFLAGS="-arch x86_64"

	# Set the ssh agent
	export SSH_ASKPASS="/etc/profile.d/ksshaskpass.sh"

	LANG=en_US.utf8

	# Emulate the open command in linux
	alias 'open'='xdg-open'
fi

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# export PYTHONPATH=/usr/lib/python3.3/site-packages

# Pretty printing of the git graph
alias lola='git log --graph --decorate --pretty=oneline --abbrev-commit --all'

source ~/.rvm/scripts/rvm
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
