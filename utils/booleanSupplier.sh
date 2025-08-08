function setIsAutoPlayEnabled() {
    > "$appPath/txt/isAutoPlayEnabled.txt"
    echo $1 >> "$appPath/txt/isAutoPlayEnabled.txt"
}

function setIsLoopEnabled() {
    > "$appPath/txt/isLoopEnabled.txt"
    echo $1 >> "$appPath/txt/isLoopEnabled.txt"
}

function getIsAutoPlayEnabled() {
    echo $(cat "$appPath/txt/isAutoPlayEnabled.txt")
}

function getIsLoopEnabled() {
    echo $(cat "$appPath/txt/isLoopEnabled.txt")
}
