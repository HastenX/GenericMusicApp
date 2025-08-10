
source $appPath/utils/booleanSupplier.sh
function getOrder() {
    readarray -t order < "$appPath"/txt/currentOrder.txt
    echo ${order[@]}
}

function getMaxIndex() {
    order=($(getOrder))
    echo ${#order[*]}
}

function getSelectedIndex() {
    echo $(cat "$appPath/txt/selectedIndex.txt")
}

function getEnd() {
    echo $(cat "$appPath/txt/endStamp.txt")
}

function getCurrent() {
    echo $(cat "$appPath/txt/currentStamp.txt")
}

function getAutoPlayRunning() {
    echo $(cat "$appPath/txt/autoPlayRunning.txt")
}

function isTimeFinished() {
    # $(echo "scale=3; $(getCurrent)>$(getEnd)" | bc) -eq 1
    if [[ $(echo "scale=3; $(getCurrent)>$(getEnd)" | bc) -eq 1 ]]; then 
        echo "true"
    else 
        echo "false"
    fi
}

function updateWhilePlay() {
    while [ $(isTimeFinished) != "true" ]; do
        if [[ $(getIsPaused) != "true" ]]; then
            echo "$(getCurrent)"
            sleep 0.23
            setCurrent "$(echo "scale=3; $(getCurrent)+.25" | bc)"
        fi
    done
}

function setOrder() {
    > "$appPath/txt/currentOrder.txt"
    order=($1)
    echo ${order[@]} > "$appPath/txt/currentOrder.txt"
}

function setSelectedIndex() {
    > "$appPath/txt/selectedIndex.txt"
    echo $1 > "$appPath/txt/selectedIndex.txt"
}

function setEnd() {
    > "$appPath/txt/endStamp.txt"
    echo $1 > "$appPath/txt/endStamp.txt"
}

function setAutoPlayRunning() {
    > "$appPath/txt/autoPlayRunning.txt"
    echo $1 > "$appPath/txt/autoPlayRunning.txt"
}

function setCurrent() {
    > "$appPath/txt/currentStamp.txt"
    echo $1 > "$appPath/txt/currentStamp.txt"
}

function startClock() {
    echo "$(date +%s%N | awk '{printf "%.2f\n", $1/1000000000}')" 
    setCurrent "$(date +%s%N | awk '{printf "%.2f\n", $1/1000000000}')" 
    setEnd "$(echo "scale=3; $(getCurrent)+$1" | bc)" 
    updateWhilePlay
}