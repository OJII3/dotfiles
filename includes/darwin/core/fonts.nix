{ ... }:
{
  # nix-darwin's font management does not work well
  homebrew.casks = [
    "font-udev-gothic"
    "font-noto-sans-cjk-jp"
    "font-noto-serif-cjk-jp"
  ];
}
