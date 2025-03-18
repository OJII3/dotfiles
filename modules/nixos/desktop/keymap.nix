{ inputs, ... }:
{
  imports = [
    inputs.xremap.nixosModules.default
  ];
  services.xremap = {
    mouse = true;
    serviceMode = "system";
    userName = "ojii3";
    watch = true;
    # withHypr = true;
    config.modmap = [
      {
        name = "Simple Replace";
        remap."Muhenkan" = "Super_L";
      }
      # { remap."Space" = [ "Shift_L" "Space" ]; }
      { remap."CapsLock" = [ "Ctrl_L" "Esc" ]; }
    ];
    config.keymap = [
      # {
      #   name = "Mac Like";
      #   remap = {
      #     "SUPER-c" = "Ctrl-c";
      #     "SUPER-v" = "Ctrl-v";
      #     "SUPER-x" = "Ctrl-x";
      #     "SUPER-z" = "Ctrl-z";
      #     "SUPER-a" = "Ctrl-a";
      #     "SUPER-s" = "Ctrl-s";
      #     "SUPER-f" = "Ctrl-f";
      #     "SUPER-SHIFT-z" = "Ctrl-SHIFT-z";
      #   };
      #   application = {
      #     not = [ "com.mitchellh.ghostty" "kitty" ];
      #   };
      # }
      # {
      #   name = "Emacs";
      #   remap = {
      #     "C-b" = "left";
      #     "C-f" = "right";
      #     "C-p" = "up";
      #     "C-n" = "down";
      #     "C-a" = "home";
      #     "C-e" = "end";
      #     "C-h" = "backspace";
      #   };
      #   application = {
      #     not = [ "com.mitchellh.ghostty" "kitty" ];
      #   };
      # }
      # {
      #   name = "Mac Like in Terminal";
      #   remap = {
      #     "SUPER-c" = "Ctrl-Shift-c";
      #     "SUPER-v" = "Ctrl-Shift-v";
      #     "SUPER-a" = "Ctrl-Shift-a";
      #     "C-p" = "up";
      #     "C-n" = "down";
      #   };
      #   application = {
      #     only = [ "com.mitchellh.ghostty" "kitty" ];
      #   };
      # }
    ];
  };
}
