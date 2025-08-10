runSongsVisible="true"
source $appPath/utils/booleanSupplier.sh
source $appPath/utils/orderSupplier.sh
source $appPath/music.sh

function runningSongs() {
    setAutoPlayRunning "true"
    setStop "false"
    setIsAutoPlayEnabled true
    setIsLoopEnabled false
    media="$1"
    currentSong=""
    cd "$media"
    cat "order.txt" > "$appPath/txt/currentOrder.txt"
    cd "$appPath"
    echo "The following is the ordered album:"
    selectSong "-10"
    echo "Would you like to play it (Y/n)?"
    read response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        clear
        selectSong "0"
        (autoPlay &)
        getResponse 
        
        song_selector
    else
        song_selector
    fi
}

# KEYWORDS:
# 1: shuffle- Shuffles song order
# 2: loop- loops current song
# 3: start- starts song if stopped
# 4: stop- stops song if started
# 5: skip- skips song
# 6: back- goes to previous song
# 7: exit- exits program
# 8: remove- removes indexed song

function autoPlay() {
    while [[ $(getStop) != "true" || $(getAutoPlayRunning) != "false" ]]; do 
        sleep 2.0
        if [[ $(getSelectedIndex) -lt 0  && $(getSelectedIndex) != -10 ]]; then 
            clear
            selectSong "$(getMaxIndex)"
        fi
        if [[ "$(getIsAutoPlayEnabled)" == *"true"*  ]]; then
            terminalProcess=$(ps -A | grep $musicTerminal | grep -o -E '[0-9]+' | head -n 1)
            vlcProcess=$(ps -A | grep -v "defunct" | grep vlc | grep -o -E '[0-9]+' | head -n 1)
            if [[ $(isTimeFinished) == "true" ]]; then
                if [[ "$(getIsLoopEnabled)" == *"false"* ]]; then
                    killAllVlc
                    clear
                    if [[ "$(getSelectedIndex)" -lt "$(getMaxIndex)" ]]; then
                        selectSong "$(($(getSelectedIndex) + 1))" 
                    else 
                        selectSong "0"
                    fi 
                else 
                    killAllVlc
                    clear
                    selectSong "$(getSelectedIndex)" 
                fi
            fi
        fi
    done
}

function getResponse() {
    while [ $(getStop) != "true" ]; do 
        local order=($(getOrder))
        read input
        setIsAutoPlayEnabled false
        vlcProcess=$(ps -A | grep -v "defunct" | grep vlc | grep -o -E '[0-9]+' | head -n 1) >/dev/null 2>&1 
        case $input in 
            "shuffle") killAllVlc; clear; setOrder "$(shuf -e ${order[@]})"; selectSong "0"; setIsAutoPlayEnabled true;;
            "loop") if [[ "$(getIsLoopEnabled)" == *"true"* ]]; then setIsLoopEnabled false; echo "loop is now disabled"; else setIsLoopEnabled true; echo "loop is now enabled"; fi ; setIsAutoPlayEnabled true;;
            "play") kill -CONT $vlcProcess; setIsPaused "false"; setIsAutoPlayEnabled true;;
            "stop") kill -SIGSTOP $vlcProcess; setIsPaused "true"; setIsAutoPlayEnabled true;;
            "next") killAllVlc; clear; if [ "$(getSelectedIndex)" -lt $(getMaxIndex) ]; then selectSong "$(($(getSelectedIndex) + 1))"; else selectSong "0"; fi ; setIsAutoPlayEnabled true;;
            "back") killAllVlc; clear; if [[ $(getSelectedIndex) != 1 ]]; then selectSong "$(($(getSelectedIndex) - 1))"; else selectSong "$(echo "$(getMaxIndex)" | grep -o -E '[0-9]+')"; fi ; setIsAutoPlayEnabled true;;
            "exit") killAllVlc; killAllVlc; setAutoPlayRunning "false"; kill -SIGTERM $(jobs -p); kill -SIGTERM $$; exit; exit;;
            "select") manualSong; setIsAutoPlayEnabled true;;
            "remove") removeSong; setIsAutoPlayEnabled true;;
            # "time") displayTime; setIsAutoPlayEnabled true;;
            "return")killAllVlc; setStop "true";;
            "help") echo "shuffle: mixes all songs"; echo "loop: repeats current song"; echo "stop: pauses a song"; echo "play: unpauses a song"; echo "select: allows user to select song via indexes"; echo "back: skips to previous song"; echo "next: skips to next song"; echo "remove: removes the given song at an index"; echo "return: returns to the song selector"; echo "exit: closes application"; setIsAutoPlayEnabled true;;
            *) echo "Please enter a valid command, type 'help' to see commands"; setIsAutoPlayEnabled true;;
        esac
    done
}

function manualSong() {
    echo "Please enter the song number you would like to skip to:"
    read songSelect
    if [[ $songSelect =~ ^[0-9]+$ && $songSelect -ge 1 && $songSelect -le $(($(getMaxIndex)+1)) ]]; then
        killAllVlc
        clear
        selectSong $((songSelect -1))
    else
        echo "Your input was outside the list of songs. type 'select' to try again"
    fi
}

function removeSong() {
    local order=($(getOrder))
    newOrder=()
    echo "Please enter the song number you would like to remove:"
    read songRemove
    if [[ $songRemove =~ ^[0-9]+$ && $songRemove -ge 1 && $songRemove -le $(($(getMaxIndex)+1)) && $(($(getSelectedIndex)+1)) != $(($songRemove)) ]]; then
        for songIndex in ${!order[@]}; do
            if [[ $songIndex != $(($songRemove-1)) ]]; then
                newOrder+=(${order[$songIndex]})
            fi
        done
        setOrder "$(echo ${newOrder[@]})"
        killAllVlc
        clear
        if [[ $songRemove -lt $(($(getSelectedIndex)+1)) ]]; then
            selectSong $(($(getSelectedIndex)-1))
        else
            selectSong $(getSelectedIndex)
        fi
    else
        echo "Your input was outside the list of songs or was on the song your on. type 'remove' to try again"
    fi
}

function selectSong() {
    local order=($(getOrder))
    setCurrent 5
    setEnd 4
    sleep .25
    setSelectedIndex "$1"
    echo ---------------------------------------
    for songIndex in ${!order[@]}; do 
        song=${order[$songIndex]}
        outputString=$(echo $song | sed "s/_/ /g")
        if [[ $1 != "-10" ]]; then
            if [[ "$song" == ${order[$1]} ]]; then
                echo "  -->"$(($songIndex + 1)):$outputString
                selectedString=$outputString
                (playSong &)
            else 
                echo "     "$(($songIndex + 1)):$outputString
            fi
        else 
            echo "     "$(($songIndex + 1)):$outputString
        fi
    done
    echo ---------------------------------------
    if [[ $1 != "-10" ]]; then
        echo "'$selectedString' is now playing"
    fi
    if [[ $(getIsLoopEnabled) == "true" ]]; then 
        echo "Loop is enabled"
    fi
}

function playSong() {
    setIsPaused "false"
    songPath="$media/$song.mp3"
    # if [[ $1 -eq "" ]]; then
        # currentSong=$(echo $song | sed "s/_/ /g")
        killAllVlc
        sleep .01
        (cvlc --play-and-exit "$songPath" >/dev/null 2>&1 &)
        startClock "$(ffprobe -v quiet -of csv=p=0 -show_entries format=duration "$songPath")" >/dev/null

    # else
    #     (cvlc --play-and-exit --start-time=$1 "$songPath" >/dev/null 2>&1 &)
    #     songStart="$(echo "scale=0; $(date +%s%N | awk '{printf "%.2f\n", $1/1000000000})')+$1" | bc)"

    # fi
}

function killAllVlc() {
    for i in $(ps -A | grep -v "defunct" | grep vlc | grep -o -E '[0-9]+'); do
        kill -SIGTERM $i >/dev/null 2>&1 
    done
}

function killIfExit() {
    if [[ $terminalProcess = "" ]]; then
        exit
    fi
}

# requires bc and awk, used by 'time' selector
# function displayTime() {
#     local order=($(getOrder))
#     local selectedIndex=$(getSelectedIndex)
#     local currentSong=${order[$selectedIndex]}
#     local currentSongFormatted=$(echo $currentSong | sed "s/_/ /g")
#     local currentTime=$(getTimeOrdered "$(getCurrent)")
#     local songLength=$(getTimeOrdered "$(getEnd)")
#     echo ---------------------------------------
#     echo "'$currentSongFormatted' Timestamps:" 
#     echo "Current time: $currentTime"
#     echo "Total Song Length: $songLength"
#     echo ---------------------------------------
#     echo "Use 'timestamp' to move to a point in the selected song"
# }

# requires bc, used by 'time' selector
# function getTimeOrdered() {
#     local sec=$(printf "%.2f" $1)
#     local minute=0
#     while [[ $(echo "scale=3; $sec>60" | bc) -eq 1 ]]; do
#         local minute=$(($minute+1))
#         sec=$(echo "scale=3; $sec-60" | bc)
#     done
#     if [[ $minute -eq 0 ]]; then 
#         echo "$sec"
#     else
#         echo "$minute":"$sec"
#     fi
# }