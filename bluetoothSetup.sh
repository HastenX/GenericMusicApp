function bluetooth_setup() {
    echo ---- NOTE: BLUEMAN IS REQUIRED FOR THIS ----
    echo "Would you like to try to enable bluetooth?(Y/n)"
    read enabledBlue
    if [[ $enabledBlue == "y" || $enabledBlue == "Y" ]]; then
        (bluetoothctl connect $bluetoothDevice >/dev/null 2>&1 &)
        echo --------------------------------------------
        echo When you are ready to enter the music app, simply press enter!
        read return
        pactl set-default-sink "$bluetoothManufacturer$(echo $bluetoothDevice | sed "s/:/_/g")$abritraryEndValue" bluetoothctl connect $bluetoothDevice >/dev/null 2>&1 
    fi
}