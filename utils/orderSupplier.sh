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

function setOrder() {
    > "$appPath/txt/currentOrder.txt"
    order=($1)
    echo ${order[@]} > "$appPath/txt/currentOrder.txt"
}

function setSelectedIndex() {
    > "$appPath/txt/selectedIndex.txt"
    echo $1 > "$appPath/txt/selectedIndex.txt"
}