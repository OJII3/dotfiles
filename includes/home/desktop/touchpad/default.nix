{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Use enhanced-touchpad from the flake input
  # This provides Mac-like cursor acceleration and strict 2-finger scroll
  programs.enhanced-touchpad = {
    enable = false;
    verbose = true; # Enable debug logging
    # device = null;  # Auto-detect touchpad device
  };
}
