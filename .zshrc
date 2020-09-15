source ~/projects/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle vagrant

antigen bundle python
antigen bundle pip
# it's auto loading workon preventing cd to inner dirs
#antigen bundle virtualenvwrapper
source $(which virtualenvwrapper.sh)

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

alias ll='ls -lF'

bindkey "^P" up-line-or-search

# some brews are installed in /usr/local/sbin/
export PATH="/usr/local/sbin:$PATH"

# my personal bin
export PATH="$HOME/bin:$PATH"

# npm packages
export PATH="/usr/local/Cellar/node/8.1.4/bin:$PATH"
export PATH="/usr/local/Cellar/yarn/0.27.5/bin:$PATH"

export ANDROID_HOME=/Users/suzan/projects/android/android-sdk-macosx

alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# show file in vim: gsv origin/master:./abc.py
alias gsv="PAGER='vi - \"+set filetype=python\"' git show"

# alias to show current branch
alias gbo="git branch | grep -e '^*' | cut -d' ' -f2"
# alias to show remote branch
alias gro="echo origin/$(git branch | grep -e '^*' | cut -d' ' -f2)"
alias gdc="git diff --cached"

setopt APPEND_HISTORY

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/suzan/projects/cocos2d-x/cocos2d-x-3.14.1/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Users/suzan/projects/cocos2d-x/cocos2d-x-3.14.1
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Users/suzan/projects/cocos2d-x/cocos2d-x-3.14.1/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Add environment variable NDK_ROOT for cocos2d-x
export NDK_ROOT=/Users/suzan/projects/android/android-ndk-r13b
export PATH=$NDK_ROOT:$PATH

# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
export ANDROID_SDK_ROOT=/Users/suzan/projects/android/android-sdk-macosx
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Add environment variable ANT_ROOT for cocos2d-x
export ANT_ROOT=/usr/local/Cellar/ant/1.9.7/bin
export PATH=$ANT_ROOT:$PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Add environment variable SDKBOX_HOME for sdkbox installer
export SDKBOX_HOME=/Users/suzan/.sdkbox
export PATH=${SDKBOX_HOME}/bin:$PATH

export PATH=/usr/local/Cellar/mongodb@3.2/3.2.11/bin:$PATH

# adb device ids
export nexus=02db6b59094e1732
export moto=ZX1D64GSTC
export karbon=A21
export redmi=370e8fa
export oneplus5=2640a1dc

export USE_CCACHE=1
export NDK_CCACHE=/usr/local/bin/ccache

export PATH=~/Downloads/flutter/bin:$PATH
