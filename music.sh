if [[ $runSongsVisible == "" ]]; then
    source "$appPath/runningSongs.sh"
fi

function song_selector() {
    clear
    echo "Current audio device: $(pactl get-default-sink)"
    echo ---------------------------------------
    echo You are now in a generic song selector:
    echo ---------------------------------------
    echo "Please select Albums (1) or Playlists (2)"
    read selection
    echo ---------------------------------------
    if [ "$selction" = "exit" ]; then
        exit
    fi
    if [ "$selection" = "1" ]; then
        i=0
        choices=()
        for album in "$almbumDir"/*; do 
            if [ -d "$album" ]; then
                choices[$i]="$album"
                i=$(($i+1))
                echo "($i):" ${choices[$(($i-1))]#/home/$USER/Music/GenericMusicAppSongs/Albums/} 
            fi
        done
        echo ---------------------------------------
        echo Please select an Album
        read albumSelection
        echo ---------------------------------------
        if [ "$albumSelction" = "exit" ]; then
            exit
        fi
        albumSelection=${choices[$(($albumSelection-1))]}
        clear
        runningSongs "$albumSelection" 

    elif [ "$selection" = "2" ]; then
        i=0
        choices=()
        playlistDir="/home/$USER/Music/GenericMusicAppSongs/Playlists"
        for playlist in "$playlistDir"/*; do 
            if [ -d "$playlist" ]; then
                choices[$i]="$playlist"
                i=$(($i+1))
                echo "($i):" ${choices[$(($i-1))]#/home/$USER/Music/GenericMusicAppSongs/Playlists/} 
            fi
        done
        echo ---------------------------------------
        echo Please select a Playlist
        read playlistSelection
        echo ---------------------------------------
        if [ "$playlistSelction" = "exit" ]; then
            exit
        fi
        playlistSelection=${choices[$(($playlistSelection-1))]}
        clear
        runningSongs "$playlistSelection"
    else
        echo "Please enter a viable response!"
         music
    fi
}
