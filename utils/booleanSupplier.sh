function setIsAutoPlayEnabled() {
    > "$appPath/txt/isAutoPlayEnabled.txt"
    echo $1 >> "$appPath/txt/isAutoPlayEnabled.txt"
}

function setIsLoopEnabled() {
    > "$appPath/txt/isLoopEnabled.txt"
    echo $1 >> "$appPath/txt/isLoopEnabled.txt"
}

function setTimeCalled() {
    > "$appPath/txt/timeCalled.txt"
    echo $1 >> "$appPath/txt/timeCalled.txt"
}

function setStop() {
    > "$appPath/txt/stop.txt"
    echo $1 >> "$appPath/txt/stop.txt"
}

function setHasLaunched() {
    > "$appPath/txt/hasLaunched.txt"
    echo $1 >> "$appPath/txt/hasLaunched.txt"
}

function setIsPaused() {
    > "$appPath/txt/isPaused.txt"
    echo $1 >> "$appPath/txt/isPaused.txt"
}

function getIsAutoPlayEnabled() {
    echo $(cat "$appPath/txt/isAutoPlayEnabled.txt")
}

function getIsLoopEnabled() {
    echo $(cat "$appPath/txt/isLoopEnabled.txt")
}

function getTimeCalled() {
    echo $(cat "$appPath/txt/timeCalled.txt")
}

function getStop() {
    echo $(cat "$appPath/txt/stop.txt")
}

function getHasLaunched() {
    echo $(cat "$appPath/txt/hasLaunched.txt")
}

function getIsPaused() {
    echo $(cat "$appPath/txt/isPaused.txt")
}