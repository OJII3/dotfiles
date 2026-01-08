{ ... }:
{
  # Load uinput kernel module for virtual input devices
  boot.kernelModules = [ "uinput" ];

  # Allow users in 'input' group to access /dev/uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
}
