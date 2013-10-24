# Bookmark directories in Bash.
# by Jakukyo Friel <weakish@gmail.com> under GPL v2
# repo: https://gist.github.com/925202




# bookmark storage
bmarkdb=$HOME/.config/bmark/rc
mkdir -p $HOME/.config/bmark
touch $bmarkdb
source $bmarkdb 


bmark () {
  # check if already bookmarked
  if grep -m1 $PWD\" $bmarkdb;  then
    echo 'Already bookmarked!'
  else # use basename as the default bookmark name
    if [ -z $1 ]; then
      bmarkname=`basename $PWD`
    else
      bmarkname=$1
    fi
    # check if bookmark name is already used
    if grep -m1 -E "^$bmarkname=" $bmarkdb; then
      echo 'Bookmark name already used! Choose a different one.'
    else # add bookmark 
      echo "$bmarkname=\"$PWD\"" >> $bmarkdb
      source $bmarkdb
    fi
  fi
}

bmarks () {
  cat $bmarkdb
}
