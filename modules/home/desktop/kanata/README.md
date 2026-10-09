# Kanata on Linux

Enable `dot.home.desktop.kanata.enable` in the Home Manager host configuration. Home Manager installs Kanata, places `linux.kbd` at `~/.config/kanata/linux.kbd`, and starts it as a user systemd service.

Kanata also needs access to the input devices and `/dev/uinput`. On Ubuntu, configure this once with an administrator account:

```sh
sudo groupadd --system uinput # Skip if the group already exists
sudo usermod -aG input,uinput "$USER"
sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/kanata.conf
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
  | sudo tee /etc/udev/rules.d/99-kanata.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Log out and back in after changing group membership, then apply Home Manager. Do not run another keyboard remapper on the same keyboard at the same time.
