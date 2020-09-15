install:
	#ln -sf `pwd`/.bash_profile ~/
	ln -sf `pwd`/.zshrc ~/
	#ln -sf `pwd`/.gitk ~/
	#ln -sf `pwd`/.inputrc ~/
	#ln -sf `pwd`/.pystartup ~/
	ln -sf `pwd`/.vimrc ~/
	ln -sf `pwd`/vlcrc ~/Library/Preferences/org.videolan.vlc/vlcrc
	ln -sf `pwd`/.gitignore_global ~/
	ln -sf `pwd`/.gitconfig ~/
	mkdir -p ~/bin
	ln -sf `pwd`/memory.sh ~/bin
