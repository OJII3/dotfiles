{
  services.jankyborders = {
    enable = true;
    active_color = "gradient(top_left=0x039393ff,bottom_right=0xf992b3ff)";
    inactive_color = "0x00000000";
  };

  services.yabai = {
    enable = true;
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
      yabai -m rule --add app='System Settings' manage=off
      yabai -m rule --add app='Calculator' manage=off
      yabai -m rule --add app='Karabiner-Elements Settings' manage=off
    ";
  };
}
