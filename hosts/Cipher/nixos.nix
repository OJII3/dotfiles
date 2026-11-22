# Cipher - Home Server
# 監視スタック (Grafana/Prometheus/Loki/Tempo/Alloy), static IP, headless autologin
#
{ inputs, pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ]);

  # ===== Options-based configuration =====
  dot = {
    core = {
      enable = true;
      boot.loader = "systemd-boot";
      audio.enable = false; # Headless server
      bluetooth.enable = false; # No Bluetooth needed
      ssh.enable = true;
      virtualisation.podman.enable = true;
    };

    networking = {
      # Server uses systemd-networkd, not NetworkManager
      networkManager.enable = false;
      snmpd.enable = true;
      tailscale.enable = false;
      warp.enable = true;
      cloudflared.enable = true;
      dns.resolved.enable = false;
    };

    server = {
      enable = true;
      autologin.enable = true;
      adguardHome.enable = false;
      gnomeKeyring.enable = true;
      observability.enable = true;
      # minecraft.enable = true;
    };

    hardware = {
      gpu = "intel";
    };
  };

  # ===== Host-specific configuration =====

  # greetd の自動ログインで boot 時から zsh のユーザーセッションは存在するが、
  # ログアウト・セッション異常終了・greetd の停止/再起動で最後のセッションが
  # 終わると user manager ごと停止し kopia も落ちるため linger を有効にする。
  # linger で user manager がセッションから独立し、t3code 等の
  # default.target サービスも継続する。
  users.users.ojii3.linger = true;

  networking.firewall.allowedTCPPorts = [
    5173
    4173
    4310 # klein
    4311 # yachigravity
    3080 # dsh
    49374 # opencode2
  ];
  networking.firewall.interfaces.CloudflareWARP.allowedTCPPorts = [
    3773 # t3code
    51515 # kopia
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Static IP networking
  networking = {
    useNetworkd = true;
    nameservers = [ "192.168.8.1" ];
  };
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp3s0";
    networkConfig = {
      IPv6AcceptRA = true;
    };
    addresses = [ { Address = "192.168.8.2/24"; } ];
    gateway = [ "192.168.8.1" ];
    linkConfig.RequiredForOnline = "routable";
  };

  system.stateVersion = "24.05";
}
