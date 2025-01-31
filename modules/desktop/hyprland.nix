{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sddm-chili-theme
    canta-theme
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # services.xserver.enable = true;
  services.xserver = {
    xkb = {
      variant = "";
      layout = "us";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    wayland.enable = true;
  };

  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-qt;
  };
}
