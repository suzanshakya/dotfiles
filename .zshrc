source ~/projects/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle vagrant

antigen bundle python
antigen bundle pip
antigen bundle virtualenvwrapper

antigen bundle brew
antigen bundle osx

antigen bundle npm
antigen bundle gulp

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell antigen that you're done.
antigen apply

# cd with automatic pushd
# from Ivo Danihelka's blog
cd() {
  if  [[ "$1" == "-" ]]; then
    popd > /dev/null
  else
    pushd . > /dev/null
    builtin cd "$@"
  fi
  echo $(pwd)
}

alias u="cd .."
alias b="pushd +1"
alias f="pushd -0"
alias c="clear"

bindkey "^P" up-line-or-search

# some brews are installed in /usr/local/sbin/
export PATH="/usr/local/sbin:$PATH"

# my personal bin
export PATH="$HOME/bin:$PATH"

alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
