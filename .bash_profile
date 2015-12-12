grand_start=`gdate +"%s.%2N"`

export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=10000
export HISTIGNORE="history:&:ls:ll:[bf]g:history:ps:clear"
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CELLAR=/usr/local/Cellar
export BREW=$CELLAR

export PYTHONSTARTUP=~/.pystartup

export PATH="~/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH="~/projects/node_modules/.bin:${PATH}"
export PIP_DOWNLOAD_CACHE=$HOME/Library/Caches/pip-downloads

export entranceprep="/Users/sujanshakya/projects/entranceprep"

# exit code for vi is being 1 in git merge
export EDITOR=vim

getPythonPaths() {
    echo "${PYTHONPATH//:/ } $(dirname `python -Sc 'from distutils.sysconfig import get_python_lib; print get_python_lib()'`)"
}

ctags-pythonpath() {
    pythonPaths=`getPythonPaths`;
    export PYTHONPATH_TAGS=${pythonPaths// /\/tags,}/tags
    for path in $pythonPaths; do
        echo "creating $path/tags"
        (cd $path && ctags -R --python-kinds=-i --languages=+python .)
    done
}

ctags-pwd() {
    ctags -R --python-kinds=-i --languages=+python .
}

pycscope-pythonpath() {
    pythonPaths=`getPythonPaths`;
    for path in $pythonPaths; do
        echo "creating $path/cscope.out"
        echo "cs add $path/cscope.out" >>~/.vim/plugin/cscope-pythonpath.vim
        (cd $path && pycscope -R -f $path/cscope.out $path)
    done
}

alias ll='ls -lAF'
alias lh='ls -lAh'
alias lS='ls -lAhS'
alias la='ls -AF'
alias l='ls -CF'
alias h='head'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias opera='/Applications/Opera.app/Contents/MacOS/Opera -nomail'
alias octave='/Applications/Octave.app/Contents/Resources/bin/octave'
alias c='clear'
alias pi='pip install'
alias pu='pip install --upgrade'
alias bi='brew install'
alias p='pwd'

# git aliases
alias g='git'
alias gb='git branch'
alias gc='git checkout'
alias gcp='git checkout -p'
alias ga='git add'
alias gap='git add -p'
alias gr='git reset'
alias grp='git reset -p'
alias gcm='git commit -m'
alias gcma='git commit -a -m'
alias gl='git log --name-only'
alias glp='git log -p'
alias glpc='git log -p -C'
alias gd='git diff'
alias gdc='git diff --cached'
alias gs='git status'
alias gss='git status -s'
alias gsu='git status -uno'
alias gssu='git status -suno'
alias gps='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gcl='git clone'
alias gls='git ls-files'
alias gitx='open ~/Applications/gitX.app'

alias vi=vim

# for using git command from outside the git repo dir.
agit() {
    if test -n "$2"; then
        command="$1"
        path="$2"
        shift
        shift
        if test "`file -b "$path" 2>/dev/null`" = "directory"; then
            (cd "$path" && git "$command" "$@")
        else
            dir=`dirname "$path"`
            base=`basename "$path"`
            (cd "$dir" && git "$command" "$base" "$@")
        fi
    else
        git "$@"
    fi
}

# cd with automatic pushd
# from Ivo Danihelka's blog
cd() {
  if  [ "x$1" == "x-" ]; then
    popd > /dev/null
  else
    pushd . > /dev/null
    builtin cd "$@"
  fi
}

alias u='cd ..'
alias b='pushd +1'
alias f='pushd -0'
alias tx='exit'
alias clc='fc -l -n -1 -1 | pbcopy'


# loop the command every 1 second
loop() {
   while true; do
       clear
       eval "$@"
       sleep 1
       echo
   done
}

psa() {
    clear
    ps aux | grep -i "$1" | grep -v grep
}

psf() {
    clear
    ps -ef | grep -i "$1" | grep -v grep
}

# open python module in editor
# eg: edit vi threading
# eg: edit vim threading
# eg: vimpy gevent
edit() {
    editor=$1
    shift
    if test ! -n "$1" ; then
        echo "Usage: vi(m)py <python-module>"
        return
    fi
    pycfile=`python -c"import $1; print $1.__file__"`
    if test "$pycfile" = "" ; then
        return
    fi
    pyfile="${pycfile/%.pyc/.py}"
    if test -f "$pyfile" ; then
        echo $editor "$pyfile"
        (cd `dirname "$pyfile"` && $editor "$pyfile")
    fi
}
vimpy() {
    edit vim "$@"
    return $?
}
mvimpy() {
    edit mvim "$@"
    return $?
}

killjob() {
    sudo kill -9 `jobs -p $1`
}
killapp() {
    ps aux | grep -i $1 | grep -v grep | awk '{print $2}' | xargs sudo kill -9
}
killsock() {
    lsof -n -P -i:$1 | awk '{print $2}' | tail -1 | xargs kill
}

topp() {
    top -pid `ps aux | grep "$1" | grep -v grep | awk '{print $2}'` | head -1
}

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

source ~/projects/dotfiles/bmark.sh

cache_opera() {
    (( count = 0 ))
    for each in `find ~/Library/Caches/com.operasoftware.Opera/Cache -type f | xargs ls -t` ; do
        file_output=`file -b $each`
        # check if filetype contains 'edia' (Media vs media)
        if [[ "$file_output" != *edia* ]] ; then
            continue
        fi
        # ignore size less than 1mb
        if test `stat -f %z "$each"` -lt 1000000 ; then
            continue
        fi
        (( count += 1 ))
        if test $# -eq 0 ; then
            ls -lh $each
            if test $count -eq 10 ; then
                break
            fi
        elif test $1 -eq $count ; then
            if test $# -eq 1 ; then
                vlc "$each" 2>/dev/null
            elif test $# -eq 2 ; then
                shift
                cp "$each" "$@"
                echo "Saved as $@"
            fi
            break
        fi
    done
}
alias co=cache_opera

gman() {
    page=~/manpages/"$1"
    man "$1" | col -b > "$page" && open -a /Applications/Opera.app "$page"
}

calculate() {
    #python -c"from __future__ import division; print $@"
    echo "$@" | bc -l
}
alias e=calculate

module_check() {
    python -c"import $1; print $1.__file__"
}
alias m=module_check

module_version() {
    python -c"import $1; print $1.__version__"
}
alias v=module_version

rm() {
  trash=~/.mytrash
  for path in "$@"; do
    # ignore any arguments
    if [[ "$path" = -* ]]; then :
    else
      dst=`basename "$path"`
      # append the time if necessary
      while [ -e $trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      if test ! -d $trash; then
          mkdir $trash
      fi
      mv "$path" $trash/"$dst"
    fi
  done
}

load_virtualenvwrapper() {
    start=`gdate +"%s.%2N"`
    export WORKON_HOME=~/.virtualenvs
    export PROJECT_HOME=~/projects
    source /usr/local/bin/virtualenvwrapper_lazy.sh
    end=`gdate +"%s.%2N"`
    echo "virtualenvwrapper" `echo $end-$start|bc`
}
load_virtualenvwrapper

load_bash_completion() {
    start=`gdate +"%s.%2N"`
    if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
      source /usr/local/etc/profile.d/bash_completion.sh
    fi
    end=`gdate +"%s.%2N"`
    echo "bash_completion" `echo $end-$start|bc`
}
# too slow
# load_bash_completion

parse_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    branch=${ref#refs/heads/}
    echo "($branch)"
}

ram_usage() {
    for app in $*; do
        kb=$(ps aux | grep -i "$app" | awk '{sum+=$6} END {print sum}')
        mb=$(echo $kb / 1024 | bc)
        echo $app: $mb MB RAM
    done
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"

PS1="$RED\$(date +%H:%M) $YELLOW\W $GREEN\$(parse_git_branch)\$ "

#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

source ~/projects/dotfiles/android-env.rc

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/suzanshakya/projects/android/cocos2d/cocos2d-x-3.8.1/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Users/suzanshakya/projects/android/cocos2d/cocos2d-x-3.8.1/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

export USE_CCACHE=1
export NDK_CCACHE=/usr/local/bin/ccache

# ml study project
alias workonml="workon clinicast; cd ~/projects/bmlswp"

grand_end=`gdate +"%s.%2N"`
echo $grand_end-$grand_start|bc

# The next line updates PATH for the Google Cloud SDK.
source '/Users/suzanshakya/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/suzanshakya/google-cloud-sdk/completion.bash.inc'
