#!/usr/bin/bash

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

echo '# See: /usr/share/doc/mpd/mpdconf.example
pid_file			"~/.config/mpd/pid"
db_file				"~/.config/mpd/mpd.db"
state_file			"~/.config/mpd/state"
playlist_directory	"~/.config/mpd/playlists"
music_directory		"~/Music"
auto_update			"yes"

audio_output {
	type	"pulse"
	name	"pulse audio"
}

audio_output {
	type	"fifo"
	name	"my_fifo"
	path	"/tmp/mpd.fifo"
	format	"44100:16:2"
}

bind_to_address	"127.0.0.1"
port	"6600"
' > $1/.config/mpd/mpd.conf
