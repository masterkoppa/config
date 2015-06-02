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
#source /home/andres/.config_git/antigen/antigen.zsh

# Source the zgen plugin manager
source "${HOME}/.config_git/zgen/zgen.zsh"

# NOTE: Everything inside this block will only be called after an update or
#       on init. Any heavy plugins should got here, light things that should
#       change on the enviorment can be placed outside.
if ! zgen saved; then
   echo "Initializing zsh plugins"
   
   # Load oh-my-zsh in
   zgen oh-my-zsh
   
   if hash git &>/dev/null; then
      # Git related plugins
      zgen oh-my-zsh plugins/git
      zgen oh-my-zsh plugins/git-extras
   fi

   
   zgen oh-my-zsh plugins/nyan
   zgen oh-my-zsh plugins/virtualenv

   # Disable if virtualenv wrapper is not installed and initialized
   # Any suggestions on how to better detect are welcome
   if [ -d "$HOME/.virtualenvs" ]; then
      zgen oh-my-zsh plugins/virtualenvwrapper
   fi
   
   #zgen oh-my-zsh plugins/rbenv
   #zgen oh-my-zsh plugins/rvm
   #zgen oh-my-zsh plugins/last-working-dir

   # Platform specific plugins
   if [[ $platform == 'linux' ]]; then
      zgen oh-my-zsh plugins/command-not-found
	  zgen oh-my-zsh plugins/systemd
	  zgen oh-my-zsh plugins/archlinux
   elif [[ $platform == 'darwin' ]]; then
	  zgen oh-my-zsh plugins/brew
	  zgen oh-my-zsh plugins/osx
   fi


   # ZSH Users Plugins
   zgen load zsh-users/zsh-syntax-highlighting
   zgen load zsh-users/zsh-completions src
   zgen load zsh-users/zsh-history-substring-search
   
   # ZSH Autosuggestions
   zgen load tarruda/zsh-autosuggestions autosuggestions.zsh

   zgen save
fi

# Settings for local and remote sessions
# We will configure the theme to not require any
# fancy fonts when coming through ssh
if [[ (-n $SSH_CONNECTION || -o login) ]]; then
   # Setup the editor of choice
   export EDITOR='vim'

   zgen oh-my-zsh themes/blinks

else
   # Setup the editor of choice
   export EDITOR='vim'
   
   # Powerline powered theme - Looks really nice, provides a good deal of info
   zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train
   
   # Alias for when using OSX
   if [[ $platform == 'darwin' ]] && which gdircolors &> /dev/null ; then
      alias 'dircolors'='gdircolors'
   fi

   if which dircolors &> /dev/null; then
      # Solarized Tweaks
      # Adds coloring to directory listings in ls, makes using solarized actually nice
      zgen load "joel-porquet/zsh-dircolors-solarized"
      setupsolarized dircolors.256dark
   fi

fi

# Enable zsh-history-substring-search
# See: https://github.com/zsh-users/zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


# Theme Setup

# Git Theme - Looks really nice, too little info outside of git. 
# Requires Powerline
#antigen-bundle arialdomartini/oh-my-git
#antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

# Powerline powered theme - Looks really nice, provides a good deal of info
# antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Simple theme - No external requirements
# antigen theme blinks


# Solarized Tweaks
# Adds coloring to directory listings in ls, makes using solarized actually nice
#antigen bundle joel-porquet/zsh-dircolors-solarized.git
#setupsolarized dircolors.256dark

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
if [[ $platform == 'linux' ]]; then
	# Compilation flags
	export ARCHFLAGS="-arch x86_64"

	# Set the ssh agent
	export SSH_ASKPASS="/etc/profile.d/ksshaskpass.sh"

	LANG=en_US.UTF-8

	# Emulate the open command in linux
	alias 'open'='xdg-open'
fi

if hash clang &> /dev/null; then
   export CC=/usr/bin/clang
   export CXX=/usr/bin/clang++
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# export PYTHONPATH=/usr/lib/python3.3/site-packages

# Pretty printing of the git graph
alias lola='git log --graph --decorate --pretty=oneline --abbrev-commit --all'

if hash rbenv -h &> /dev/null; then
   eval "$(rbenv init --no-rehash - zsh)"
fi

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}

zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle


# Auto load any custom system configs form .custom_zshrc
if [[ -e "${HOME}/.config_git/.custom_zshrc" ]]; then
   source "${HOME}/.config_git/.custom_zshrc"
fi
