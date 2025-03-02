#!/bin/bash
#
# type cmd `xinput`, it shows my device X input information as follow
#
# ➜  ~ xinput
# ⎡ Virtual core pointer                      id=2    [master pointer  (3)]
# ⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
# ⎜   ↳ ETPS/2 Elantech Touchpad                  id=14   [slave  pointer  (2)]
# ⎣ Virtual core keyboard                     id=3    [master keyboard (2)]
#     ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
#     ↳ Power Button                              id=6    [slave  keyboard (3)]
#     ↳ Asus Wireless Radio Control               id=7    [slave  keyboard (3)]
#     ↳ Video Bus                                 id=8    [slave  keyboard (3)]
#     ↳ Video Bus                                 id=9    [slave  keyboard (3)]
#     ↳ Sleep Button                              id=10   [slave  keyboard (3)]
#     ↳ ASUS USB2.0 Webcam                        id=11   [slave  keyboard (3)]
#     ↳ Asus WMI hotkeys                          id=12   [slave  keyboard (3)]
#     ↳ AT Translated Set 2 keyboard              id=13   [slave  keyboard (3)]
#
# or 
#
# ⎡ Virtual core pointer                          id=2    [master pointer  (3)]
# ⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
# ⎜   ↳ SYNA32AF:00 06CB:CE17 Mouse               id=10   [slave  pointer  (2)]
# ⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
#     ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
#     ↳ Power Button                              id=6    [slave  keyboard (3)]
#     ↳ Video Bus                                 id=7    [slave  keyboard (3)]
#     ↳ Power Button                              id=8    [slave  keyboard (3)]
#     ↳ ELAN2514:00 04F3:2B11 Stylus              id=13   [slave  keyboard (3)]
#     ↳ Intel HID events                          id=14   [slave  keyboard (3)]
#     ↳ Intel HID 5 button array                  id=15   [slave  keyboard (3)]
#     ↳ AT Translated Set 2 keyboard              id=16   [slave  keyboard (3)]
#     ↳ HP WMI hotkeys                            id=17   [slave  keyboard (3)]
# ∼ SYNA32AF:00 06CB:CE17 Touchpad                id=14   [floating slave]
# ∼ ELAN2514:00 04F3:2B11                         id=12   [floating slave]
#
# So my touchpad's ID is 14, then use `xinput disable 14` and `xinput enable 14` for toggling~
#
# Following bash script is referred to this askubuntu question:
# http://askubuntu.com/questions/751413/how-to-disable-enable-toggle-touchpad-in-a-dell-laptop

# get the id of the device. using awk and sed
id=$(xinput list | grep -i touchpad | awk -F'id=' '{print $2}' | awk '{print $1}')

if xinput list-props "$id" | grep "Device Enabled (18[0-9]):.*1" >/dev/null
then
    xinput disable "$id"
    notify-send -u low -i mouse "Trackpad disabled"
else
    xinput enable "$id"
    notify-send -u low -i mouse "Trackpad enabled"
fi
