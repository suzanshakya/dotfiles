PS1='\u@\h:\w\$ '

export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=100000
export HISTIGNORE="history:&:ls:ll:[bf]g:history:ps:clear"
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export LOGINSPECT_HOME=/opt/immune
export LI=$LOGINSPECT_HOME

export BREW=/usr/local/Cellar
export CELLAR=$BREW

export PYTHONSTARTUP=~/.pystartup
export PYHOME=/usr/local/Cellar/python2.6/2.6.5
export PYSITE=$PYHOME/lib/python2.6/site-packages

. $LI/etc/env.rc
export PYTHONPATH="$PYTHONPATH":~/python
export PATH="~/bin:$PYHOME/bin:${PATH}"
export PATH="${PATH}:~/projects/android-sdk-macosx/tools:~/projects/android-sdk-macosx/platform-tools"

alias ll='ls -lAF'
alias lh='ls -lAh'
alias lS='ls -lAhS'
alias la='ls -AF'
alias l='ls -CF'
alias g='grep -i'
alias vlc=/Applications/VLC.app/Contents/MacOS/VLC
alias opera='/Applications/Opera.app/Contents/MacOS/Opera -nomail'
alias u='cd ..'
alias b='cd -'
alias c='clear'
alias pi='pip install'
alias pu='pip install --upgrade'
alias bi='brew install'
alias gs='git status -s'
alias gd='git diff'

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

edit() {
    editor=$1
    shift
    isPackage=$1
    if test "$isPackage" = "-m" ; then
        isPackage=true
        shift
    else
        isPackage=false
    fi
    if test ! -n "$1" ; then
        echo "Usage: vi(m)py <python-module>"
        return
    fi
    pycfile=`python -c "import $1; print $1.__file__"`
    if test "$pycfile" = "" ; then
        return
    fi
    pyfile="${pycfile/%.pyc/.py}"
    if test -f "$pyfile" ; then
        if $isPackage ; then
            pyfile=`dirname "$pyfile"`
        fi
        echo $editor "$pyfile"
        $editor "$pyfile"
    fi
}
vipy() {
    edit vi "$@"
    return $?
}
vimpy() {
    edit vim "$@"
    return $?
}

alias killjobs='kill -9 `jobs -p`'
killjob() {
    kill -9 `jobs -p $1`
}
killapp() {
    ps aux | grep -i $1 | grep -v grep | awk '{print $2}' | xargs kill
}
killsock() {
    lsof -n -P -i:$1 | awk '{print $2}' | tail -1 | xargs kill
}

topp() {
    top -pid `ps aux | grep "$1" | grep -v grep | awk '{print $2}'` | head -1
}

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

. ~/bmark.sh
#source /usr/local/etc/profile.d/bash_completion.sh

cache_opera() {
    (( count = 0 ))
    for each in `find ~/Library/Caches/Opera/cache -type f | grep .tmp | xargs ls -t` ; do
        file_output=`file -b $each`
        if test ! "$file_output" = "Macromedia Flash Video" ; then
            continue
        fi
        (( count += 1 ))
        if test $# -eq 0 ; then
            ls -lh $each
            if test $count -eq 5 ; then
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
    python -c"print $*"
}
alias e=calculate

module_check() {
    python -c "import $1; print $1.__file__"
}
alias m=module_check

module_version() {
    python -c "import $1; print $1.__version__"
}
alias v=module_version

function rm() {
  for path in "$@"; do
    # ignore any arguments
    if [[ "$path" = -* ]]; then :
    else
      dst=`basename "$path"`
      # append the time if necessary
      while [ -e ~/.Trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      if test ! -d ~/.Trash; then
          mkdir ~/.Trash
      fi
      mv "$path" ~/.Trash/"$dst"
    fi
  done
}

function vim() {
    if test ! -z "$1"; then
        if test "`file -b "$1" 2>/dev/null`" = "directory"; then
            (cd "$1" && mvim)
            return
        fi
    fi
    mvim "$*"
}
