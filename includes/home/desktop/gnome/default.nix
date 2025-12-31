{ pkgs, inputs, ... }:
{
  imports = [
    ../../gpg/gnome.nix
  ];

  xdg.enable = true;
  programs.gnome-shell = {
    enable = true;
    extensions =
      let
        ext = pkgs.gnomeExtensions;
      in
      [
        { package = ext.appindicator; }
        { package = ext.blur-my-shell; }
        { package = ext.caffeine; }
        { package = ext.gsconnect; }
        { package = ext.kimpanel; }
        { package = ext.tailscale-status; }
        { package = ext.color-picker; }
        { package = ext.claude-code-usage-indicator; }
        { package = inputs.confetti.packages.${pkgs.system}.gnome-extension; }
      ];
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/ojii3/.assets/images/honkai3rd_efcs.png";
      picture-uri-dark = "file:///home/ojii3/.assets/images/honkai3rd_efcs.png";
      picture-options = "scaled";
      primary-color = "#000000";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      toggle-maximized = [ "<Super>m" ];
    };
  };
}
