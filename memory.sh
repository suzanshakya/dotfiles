#/bin/sh
if [ -z "$1" ]; then
	echo "Usage: $0 [process name]"
	process_name=""
else
	process_name="$@"
fi
script_file="$(basename $0)"
#ps aux | egrep -v "grep|$script_file" | grep "$process_name"
exec ps aux | egrep -v "grep|$script_file" | grep "$process_name" | awk '{proc+=1; cpu+=$3; mem+=$4; vsz+=$5; rss+=$6} END {printf("Process=%s CPU=%s%% MEM=%s%% VSZ=%sGB RSS=%sMB\n", proc, cpu, mem, vsz/1024/1024, rss/1024)}'
