# NixOS Server modules
# Server-specific configuration with customizable options.
#
# Options:
#   dot.server.enable          - Enable server configuration
#   dot.server.autologin.enable - Enable auto-login via greetd
#   dot.server.autologin.user  - User for auto-login
#   dot.server.adguardHome.enable - Enable AdGuard Home DNS
#   dot.server.zabbix.enable   - Enable Zabbix monitoring server
#   dot.server.librenms.enable - Enable LibreNMS network monitoring
#
{ config, lib, pkgs, username ? "ojii3", ... }:
let
  cfg = config.dot.server;
in
{
  imports = [
    ./zabbix.nix
    ./librenms.nix
  ];

  options.dot.server = {
    enable = lib.mkEnableOption "server configuration";

    autologin = {
      enable = lib.mkEnableOption "auto-login via greetd";

      user = lib.mkOption {
        type = lib.types.str;
        default = username;
        description = "User for auto-login";
      };

      shell = lib.mkOption {
        type = lib.types.str;
        default = "zsh";
        description = "Shell to start on login";
      };
    };

    adguardHome = {
      enable = lib.mkEnableOption "AdGuard Home DNS server";
    };

    gnomeKeyring = {
      enable = lib.mkEnableOption "GNOME Keyring for headless/non-GUI servers";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Auto-login
    (lib.mkIf cfg.autologin.enable {
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = cfg.autologin.shell;
            user = cfg.autologin.user;
          };
          default_session = initial_session;
        };
      };
    })

    # AdGuard Home
    (lib.mkIf cfg.adguardHome.enable {
      services.adguardhome = {
        enable = true;
        openFirewall = true;
      };
      services.resolved.enable = false;
    })

    # GNOME Keyring (for headless/non-GUI servers)
    (lib.mkIf cfg.gnomeKeyring.enable {
      environment.systemPackages = with pkgs; [
        gnome-keyring
        libsecret
      ];

      # Auto-unlock gnome-keyring via PAM (non-GUI compatible)
      security.pam.services.login.enableGnomeKeyring = true;

      # Enable keyring access for SSH and sudo
      security.pam.services.sshd.enableGnomeKeyring = true;

      # D-Bus secret service support
      services.dbus.packages = [ pkgs.gnome-keyring ];
    })
  ]);
}
