appPath=/home/$USER/Documents/GitHub/GenericMusicApp
almbumDir="/home/$USER/Music/GenericMusicAppSongs/Albums"

source "/home/$USER/Documents/GitHub/GenericMusicApp/runningSongs.sh"

function music() {
    clear
    echo You are now in a generic song selector:
    echo ---------------------------------------
    echo "Please select Albums (1) or Playlists (2)"
    read selection
    echo ---------------------------------------
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
        playlistSelection=${choices[$(($playlistSelection-1))]}
        clear
        runningSongs "$playlistSelection"
    else
        echo "Please enter a viable response!"
        music
    fi
}