{ config, lib, ... }:
{
  config = lib.mkIf config.dot.home.apps.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };

    # GNOME's Mutter doesn't implement wlr-layer-shell, so on Wayland Vicinae is
    # a plain toplevel window that can't position itself and Mutter puts it at
    # the top left corner. Let Mutter center new windows instead.
    dconf.settings."org/gnome/mutter".center-new-windows = true;
  };
}
