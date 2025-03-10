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
      {
        name = "Emacs";
        window.only = "/.*Google-Chrome/";
        remap = {
          "C-b" = "left";
          "C-f" = "right";
          "C-p" = "up";
          "C-n" = "down";
          "C-a" = "home";
          "C-e" = "end";
          "C-h" = "backspace";
        };
      }
    ];
  };
}
