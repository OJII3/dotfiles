{
  imports = [ ./. ];
  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    onActivation.autoUpdate = false;
    casks = [
      "chatgpt"
      "firefox"
      "ghostty"
      "logi-options+"
      "ltspice"
      "scroll-reverser"
      "visual-studio-code"
    ];
  };
}
