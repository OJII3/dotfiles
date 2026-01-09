# Obsidian Self-hosted LiveSync with Podman Quadlet
# CouchDB + Cloudflare Tunnel
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.obsidianSync;
  sopsTemplates = config.sops.templates;
in
{
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.dot.home.sops.enable;
        message = "obsidianSync requires sops to be enabled (dot.home.sops.enable = true)";
      }
    ];

    # Ensure data directory exists
    home.activation.createCouchdbDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${config.home.homeDirectory}/${cfg.couchdb.dataDir}"
    '';

    # Restart obsidian-sync services after home-manager switch (must be after sops-nix)
    home.activation.restartObsidianSync = lib.hm.dag.entryAfter [ "reloadSystemd" "sops-nix" ] ''
      if ${pkgs.systemd}/bin/systemctl --user is-system-running -q 2>/dev/null; then
        run ${pkgs.systemd}/bin/systemctl --user daemon-reload
        run ${pkgs.systemd}/bin/systemctl --user restart obsidian-sync-pod.service couchdb.service cloudflared.service || true
      fi
    '';

    # Quadlet files
    home.file = {
      ".config/containers/systemd/obsidian-sync.pod".text = ''
        [Pod]
        PodName=obsidian-sync
        ${lib.optionalString cfg.exposePort "PublishPort=127.0.0.1:5984:5984"}
      '';

      ".config/containers/systemd/couchdb.container".text = ''
        [Unit]
        Description=CouchDB for Obsidian LiveSync
        After=sops-nix.service
        Requires=sops-nix.service

        [Container]
        Image=docker.io/library/couchdb:3
        Pod=obsidian-sync.pod
        Volume=%h/${cfg.couchdb.dataDir}:/opt/couchdb/data:Z
        Environment=COUCHDB_USER=${cfg.couchdb.user}
        EnvironmentFile=${sopsTemplates."obsidian-sync-couchdb.env".path}
        ${lib.optionalString cfg.autoUpdate.enable "AutoUpdate=registry"}
        HealthCmd=curl -sf http://localhost:5984/_up || exit 1
        HealthInterval=30s
        HealthTimeout=10s
        HealthRetries=3
        HealthStartPeriod=60s
        DropCapability=ALL
        AddCapability=CHOWN DAC_OVERRIDE FOWNER SETGID SETUID KILL
        ${lib.optionalString (cfg.couchdb.memoryLimit != null) "Memory=${cfg.couchdb.memoryLimit}"}
        PidsLimit=100

        [Service]
        Restart=always
        RestartSec=10
        TimeoutStartSec=120

        [Install]
        WantedBy=default.target
      '';

      ".config/containers/systemd/cloudflared.container".text = ''
        [Unit]
        Description=Cloudflare Tunnel for Obsidian LiveSync
        After=couchdb.service
        BindsTo=couchdb.service

        [Container]
        Image=docker.io/cloudflare/cloudflared:latest
        Pod=obsidian-sync.pod
        Exec=tunnel --no-autoupdate run
        EnvironmentFile=${sopsTemplates."obsidian-sync-cloudflared.env".path}
        ${lib.optionalString cfg.autoUpdate.enable "AutoUpdate=registry"}
        HealthCmd=cloudflared tunnel info || exit 1
        HealthInterval=60s
        HealthTimeout=30s
        HealthRetries=3
        HealthStartPeriod=30s
        DropCapability=ALL
        AddCapability=NET_BIND_SERVICE KILL
        ReadOnly=true
        Memory=128m
        PidsLimit=50

        [Service]
        Restart=always
        RestartSec=10
        TimeoutStartSec=60

        [Install]
        WantedBy=default.target
      '';
    };

    # Podman auto-update timer (weekly)
    systemd.user.services.podman-auto-update = lib.mkIf cfg.autoUpdate.enable {
      Unit = {
        Description = "Podman auto-update service";
        After = [ "network-online.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.podman}/bin/podman auto-update";
      };
    };

    systemd.user.timers.podman-auto-update = lib.mkIf cfg.autoUpdate.enable {
      Unit = {
        Description = "Podman auto-update timer";
      };
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    # Required packages
    home.packages = with pkgs; [
      podman
      curl # for healthcheck
    ];
  };
}
