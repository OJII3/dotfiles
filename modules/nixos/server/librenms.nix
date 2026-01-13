# NixOS LibreNMS module
# LibreNMS network monitoring system with MariaDB backend and nginx frontend.
#
# Options:
#   dot.server.librenms.enable         - Enable LibreNMS server
#   dot.server.librenms.hostname       - Hostname for web interface
#   dot.server.librenms.port           - Port for web interface (default: 8080)
#   dot.server.librenms.openFirewall   - Open firewall ports
#
{ config, lib, ... }:
let
  cfg = config.dot.server.librenms;
in
{
  options.dot.server.librenms = {
    enable = lib.mkEnableOption "LibreNMS network monitoring system";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "librenms.local";
      description = "Hostname for the LibreNMS web interface";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for the LibreNMS web interface";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open firewall ports for LibreNMS";
    };
  };

  config = lib.mkIf cfg.enable {
    # LibreNMS service
    services.librenms = {
      enable = true;
      hostname = cfg.hostname;

      # Database configuration (MariaDB, created locally via unix socket)
      database = {
        createLocally = true;
        socket = "/run/mysqld/mysqld.sock";
      };

      # nginx virtual host configuration
      nginx = {
        listen = [
          {
            addr = "0.0.0.0";
            port = cfg.port;
          }
          {
            addr = "[::]";
            port = cfg.port;
          }
        ];
      };

      # LibreNMS settings
      settings = {
        base_url = "http://${cfg.hostname}:${toString cfg.port}";
      };
    };

    # nginx recommended settings
    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };

    # SNMP daemon for local monitoring (optional - user can configure separately)
    # services.snmpd = {
    #   enable = true;
    #   configFile = pkgs.writeText "snmpd.conf" ''
    #     rocommunity public localhost
    #     syslocation Server Room
    #     syscontact Admin <admin@example.com>
    #   '';
    #   openFirewall = cfg.openFirewall;
    # };

    # Open web interface port
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];
  };
}
