# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
let
  wirelessConf = builtins.fromTOML (builtins.readFile /etc/nixos/wireless.conf);
in
{
  imports =
    [
      ../../modules/nixos/core
      ../../modules/nixos/core/boot/systemd-boot.nix
      ../../modules/nixos/core/cloudflare-warp.nix
      ../../modules/nixos/core/fan.nix
      # ../../modules/nixos/core/networking/networkmanager.nix
      ../../modules/nixos/core/power/laptop.nix
      ../../modules/nixos/core/suspend

      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/sunshine.nix
      ../../modules/nixos/desktop/greetd/tuigreet.nix
      ../../modules/nixos/desktop/waydroid.nix

      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      # lenovo-thinkpad-e14-amd
      common-pc-laptop
    ]);

  # Karnel.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid


  # Hardware Specific Options
  boot.kernelParams = [
    "amd_iommmu=on"
    "mem_sleep_default=deep"
    "acpi_backlight=native"
    "thinkpad_acpi.fan_control=1"
  ];
  boot.extraModprobeConfig = ''
    options rtw89pci disable_aspm_l1=y
    options rtw89pci disable_aspm_l1ss=y
  '';
  services.tlp.settings = {
    RADEON_DPM_PERF_LEVEL_ON_AC = "high"; # dynamic power management, default: auto
    RADEON_DPM_PERF_LEVEL_ON_BAT = "auto"; # dynamic power management, default: auto
    RADEON_DPM_STATE_ON_AC = "performance";
    RADEON_DPM_STATE_ON_BAT = "battery";
    AMDGPU_ABM_LEVEL_ON_BAT = 3; # adaptive backlight, default: 1
    USB_DENYLIST = "32c2:0066 ";
    RUNTIME_PM_DISABLE = "02:00.0"; # permanently disable wwan device power management
  };
  hardware.amdgpu.amdvlk.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.tlp.settings = {
    WIFI_PWR_ON_BAT = "off";
  };
  services.fprintd = {
    enable = true;
  };

  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;

  systemd.services.hibernate-recovery = {
    description = "Hibernate Recovery";
    wantedBy = [ "hibernate.target" ];
    script = ''
      !/bin/sh
      modprobe -r rtw89_8852ce
      modprobe rtw89_8852ce
    '';
  };

  networking.useNetworkd = true;
  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    secretsFile = "/etc/nixos/wireless.conf";
    networks."aterm-44cbf4-a" = { pskRaw = "ext:psk_home"; };
    networks."aterm-44cbf4-g" = { pskRaw = "ext:psk_home"; };
    networks."Kafka" = { pskRaw = "ext:psk_kafka"; };
    networks."tuatnet" = {
      hidden = true;
      auth = ''
        key_mgmt=WPA-EAP
        eap=PEAP
        phase2="auth=MSCHAPV2"
        identity="s245158v"
        password=ext:psk_tuat
      '';
    };
    networks."eduroam" = {
      hidden = true;
      auth = ''
        key_mgmt=WPA-EAP
        eap=PEAP
        phase2="auth=MSCHAPV2"
        identity="s245158v@eduroam.tuat.ac.jp"
        password=ext:psk_tuat
      '';
    };
  };

  systemd.network.networks."10-wlp2s0" = {
    matchConfig.Name = "wlp2s0";
    networkConfig = {
      DHCP = "ipv4";
    };
  };

  systemd.network.netdevs."br0".netdevConfig = {
    Name = "br0";
    Kind = "bridge";
  };

  systemd.network.networks."00-br0" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = "192.168.111.1/24";
      DHCPServer = "yes";
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
    };
  };

  systemd.network.networks."20-enp1s0" = {
    matchConfig.Name = "enp1s0";
    networkConfig = { Bridge = "br0"; };
  };

  # nat via wlp1s0
  networking.nat = {
    enable = true;
    externalInterface = "wlp2s0";
    internalInterfaces = [ "br0" ];
  };

  # open firewall for dhcp and dns
  networking.firewall.allowedUDPPorts = [ 53 67 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}


