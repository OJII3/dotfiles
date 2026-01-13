# NixOS Zabbix Server module
# Zabbix monitoring server with PostgreSQL backend and nginx frontend.
#
# Options:
#   dot.server.zabbix.enable         - Enable Zabbix server
#   dot.server.zabbix.hostname       - Hostname for web interface
#   dot.server.zabbix.port           - Port for web interface (default: 8080)
#   dot.server.zabbix.openFirewall   - Open firewall ports
#   dot.server.zabbix.agent.enable   - Enable Zabbix agent on this host
#
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.server.zabbix;
in
{
  options.dot.server.zabbix = {
    enable = lib.mkEnableOption "Zabbix monitoring server";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "zabbix.local";
      description = "Hostname for the Zabbix web interface";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for the Zabbix web interface";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open firewall ports for Zabbix";
    };

    agent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Zabbix agent on this host for local monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Zabbix Server (with PostgreSQL backend)
    services.zabbixServer = {
      enable = true;
      package = pkgs.zabbix70.server-pgsql;
      database = {
        type = "pgsql";
        createLocally = true;
      };
      openFirewall = cfg.openFirewall;
    };

    # Zabbix Web Frontend (with nginx)
    services.zabbixWeb = {
      enable = true;
      package = pkgs.zabbix70.web;
      hostname = cfg.hostname;
      frontend = "nginx";
      database = {
        type = "pgsql";
        host = "";  # Use local socket
      };
      server = {
        address = "localhost";
        port = 10051;
      };
      nginx.virtualHost = {
        listen = [
          { addr = "0.0.0.0"; port = cfg.port; }
          { addr = "[::]"; port = cfg.port; }
        ];
      };
    };

    # Zabbix Agent (for local host monitoring)
    services.zabbixAgent = lib.mkIf cfg.agent.enable {
      enable = true;
      package = pkgs.zabbix70.agent;
      server = "127.0.0.1";
      openFirewall = cfg.openFirewall;
      settings = {
        Hostname = config.networking.hostName;
      };
    };

    # PostgreSQL is automatically enabled by zabbixServer
    # but we ensure some settings for performance
    services.postgresql = {
      settings = {
        shared_buffers = "256MB";
        effective_cache_size = "512MB";
      };
    };

    # nginx configuration is handled by zabbixWeb
    # Add recommended settings
    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };

    # Open web interface port
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];
  };
}
