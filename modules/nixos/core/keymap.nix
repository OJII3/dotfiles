{ ... }: {
  services.xremap = {
    userName = "ojii3";
    serviceMode = "system";
    config = {
      modmap = [
        {
          name = "Smart CapsLock";
          remap = {
            CapsLock = [ "Ctrl_L" "Esc" ];
          };
        }
        {
          name = "Super Muhenkan";
          remap = {
            Muhenkan = "Super_L";
          };
        }
        {
          name = "Mouse Back to Numpad .";
          remap = {
            BTN_8 = "KEY_KPDOT";
          };
        }
        {
          name = "Space Shift";
          remap = {
            Space = [ "Shift_L" "Space" ];
          };
        }
      ];
      keymap = [
      ];
    };
  };
}
