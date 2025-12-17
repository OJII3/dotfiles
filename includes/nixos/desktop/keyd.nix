{
  services.keyd = {
    enable = true;
    keyboards = {
      "*" = {
        settings = {
          main = {
            capslock = "overload(control, esc)";
            space = "overload(meta, space)";
            muhenkan = "overload(meta, space)";
            henkan = "overload(meta, space)";
            rightalt = "overload(rightalt, hiragana_katakana)";
          };
        };
      };
    };
  };
}
