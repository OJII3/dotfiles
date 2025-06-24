{
  services.jankyborders = {
    enable = true;
    active_color = "gradient(top_left=0xFFFFA500,bottom_right=0xFF1C6293)";
    inactive_color = "0x00000000";
  };

  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        outer.top = 8;
        outer.right = 8;
        outer.bottom = 8;
        outer.left = 8;
        inner.horizontal = 8;
        inner.vertical = 8;
      };
      enable-normalization-opposite-orientation-for-nested-containers = true;
      mode.main.binding = {
        # basic window management
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        # basic workspace management
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        # other window management
        alt-tab = "workspace-back-and-forth";
        alt-f = "fullscreen";
        alt-shift-f = "layout floating tiling";
        alt-r = "mode resize";
        alt-q = "close --quit-if-last-window";
        # launching applications
        # misc
        cmd-h = [ ]; # disable hide application
      };
      mode.resize.binding = {
        enter = "mode main";
        esc = "mode main";
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
      };
    };
  };
}

