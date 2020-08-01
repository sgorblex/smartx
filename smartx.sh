#!/bin/sh

# TODO
# make prettier wm names
# find out which sessions are installed (see below). Note: if the command has arguments, ignore them
# ...

# add your WM's starting command in the list if it doesn't appear. If there's more then one, separate them with ; or &&. The last command must be the one which actually starts the session and should start with exec.
declare -A sessions
sessions[i3]="exec i3"
sessions[openbox]="exec openbox-session"
sessions[bspwm]="exec bspwm"
sessions[awesome]="exec awesome"
sessions['kde plasma']="export DESKTOP_SESSION=plasma; exec startplasma-x11"
sessions[gnome]="export XDG_SESSION_TYPE=x11; export GDK_BACKEND=x11; exec gnome-session"
sessions[xfce]="exec startxfce4"


# identify what tui command to use
function tui_choose {
	for tui in whiptail dialog
	do
		if command -v $tui &> /dev/null
		then
			return
		fi
	done
	return 1
}


function is_display_taken {
	for disp in $(ls /tmp/.X11-unix)
	do
		if [[ display -eq ${disp#X} ]]
		then
			return 0
		fi
	done
	return 1
}






# exit if no tui command is available
if ! tui_choose
then
	echo "Your system doesn't have any recognized tui command"
	exit 1
fi


# set DISPLAY as the first non-used number
display=0
while $(is_display_taken)
do
	(( display++ ))
done

export DISPLAY=:$display


# find out which sessions are installed
#	${sessions[@]#*exec }
# ...


script_path=$(realpath $0)
echo path: $script_path
select session in ${!sessions[@]}
do
	startx ${script_path%/*}/smartxrc ${sessions[$session]}
	break
done
