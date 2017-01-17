# Determine what platform we are in, OS X or Linux
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='darwin'
else 
    echo "Unknown platform, can't run config"
    return 1
fi

# Source the zgen plugin manager
source "${HOME}/.config_git/zgen/zgen.zsh"

# Helper function
is_installed() {
    if hash $1 2> /dev/null; then
        return 0
    else
        return 1
    fi
}

# NOTE: Everything inside this block will only be called after an update or
#       on init. Any heavy plugins should got here, light things that should
#       change on the enviorment can be placed outside.
if ! zgen saved; then
    echo "Initializing zsh plugins"

    # Load oh-my-zsh in
    zgen oh-my-zsh

    if is_installed git; then
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
    
    if is_installed rbenv; then
        zgen oh-my-zsh plugins/rbenv
    fi
    
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
    zgen load tarruda/zsh-autosuggestions

    zgen save
fi

# OH-MY-ZSH Settings
CASE_SENSITIVE="false"

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
fi
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


# Enable zsh-history-substring-search
# See: https://github.com/zsh-users/zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# ENV Variables
export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
export DEFAULT_USER='andres'
export BULLETTRAIN_CONTEXT_DEFAULT_USER='andres'

if [[ $platform == 'linux' ]]; then
    # Compilation flags
    export ARCHFLAGS="-arch x86_64"

    # Set the ssh agent
    export SSH_ASKPASS="/etc/profile.d/ksshaskpass.sh"

    export LANG=en_US.UTF-8

    # Emulate the open command in linux
    alias 'open'='xdg-open'
fi

if is_installed clang; then
    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++
fi

# Pretty printing of the git graph
alias lola='git log --graph --decorate --pretty=oneline --abbrev-commit --all'

# Version Managers
# Should probably live in .zshenv instead of here

# RbEnv

if is_installed rbenv; then
    eval "$(rbenv init --no-rehash - zsh)"
fi

# PyEnv

# Check if it's installed locally
if ! is_installed pyenv && [[ -d ~/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if is_installed pyenv; then
    eval "$(pyenv init -)"
    
    if [[ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]]; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

if is_installed ibus-daemon; then
    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus
fi

# Key Bindings
# Setup a series of keybindings to make it easier to work in the terminal
# SEE: http://zshwiki.org/home/zle/bindkeys

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
zle-line-init () {
    if (( ${+terminfo[smkx]} )); then
        echoti smkx
    fi
}
zle-line-finish () {
    if (( ${+terminfo[smkx]} )); then
        echoti rmkx
    fi
}
zle -N zle-line-init
zle -N zle-line-finish 


# Auto load any custom system configs form .custom_zshrc
if [[ -e "${HOME}/.config_git/.custom_zshrc" ]]; then
    source "${HOME}/.config_git/.custom_zshrc"
fi
