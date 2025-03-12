{
  services.jankyborders = {
    enable = true;
    active_color = "gradient(top_left=0x039393ff,bottom_right=0xf992b3ff)";
    inactive_color = "0x00000000";
  };

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_animation_duration = 0.2;
      window_gap = 8;
      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
    };
    extraConfig = "
      sudo yabai --load-sa

      # Default Apps
      yabai -m rule --add app='^Activity Monitor$' manage=off
      yabai -m rule --add app='^Calculator$' manage=off
      yabai -m rule --add app='^Weather$' manage=off
      yabai -m rule --add app='^Clock$' manage=off
      yabai -m rule --add app='^Finder$' title='^.* Info$' manage=off
      yabai -m rule --add app='^Finder$' title='^Connect to Server$' manage=off
      yabai -m rule --add app='^Finder$' title='^Connecting to Server$' manage=off
      yabai -m rule --add app='^System Settings$' manage=off

      # Common Apps
      yabai -m rule --add app='^Discord$' title='^Discord Updater$' manage=off
      yabai -m rule --add app='Karabiner-Elements Settings' manage=off

      yabai -m rule --add app='GDLauncher' manage=off # GDLauncher
    ";
  };
}
