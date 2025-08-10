# Configure to your own path
appPath=/home/$USER/Documents/GitHub/GenericMusicApp
almbumDir="/home/$USER/Music/GenericMusicAppSongs/Albums"
playlistDir="/home/$USER/Music/GenericMusicAppSongs/Playlist"

# Find your devices manufacturer and ID then enter it in here (also a random value...):
bluetoothManufacturer=bluez_output.
bluetoothDevice=BC:87:FA:97:C6:40
abritraryEndValue=.1
# If none of this applies to your device, ignore this and connect outside the app

# Put your terminal here
musicTerminal="kitty"

# Please note that vlc is a needed depedency, while blueman (Bluetooth), pauvcontrol, awk and bc (time) lose some input functionality without

# If you want this to automatically launch (assuming you've already configured your terminal to launch on startup),
# put this in your ~/.bashrc file

# # ADDS MUSIC COMMAND TO BASH (LOCAL MUSIC HOSTING >:3c)
# source /home/Hazel/Documents/GitHub/GenericMusicApp/launch.sh
#
# 
# if [[ $(getHasLaunched) != "true" ]]; then
#     setHasLaunched "true"
#     music
# fi


source "/$appPath/music.sh"
source "/$appPath/bluetoothSetup.sh"
source "/$appPath/utils/booleanSupplier.sh"

function music() {
    bluetooth_setup
    song_selector
}
