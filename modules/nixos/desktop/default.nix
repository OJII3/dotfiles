# NixOS Desktop modules
# Desktop environment configuration with customizable options.
#
# Options:
#   my.desktop.enable           - Enable desktop environment
#   my.desktop.hyprland.enable  - Enable Hyprland compositor
#   my.desktop.fonts.enable     - Enable custom fonts
#   my.desktop.flatpak.enable   - Enable Flatpak
#   my.desktop.sunshine.enable  - Enable Sunshine remote desktop
#   my.desktop.waydroid.enable  - Enable Waydroid Android container
#   my.desktop.keyd.enable      - Enable keyd key remapping
#   my.desktop.gaming.enable    - Enable gaming support
#   my.desktop.gaming.steam.enable - Enable Steam
#   my.desktop.gaming.vr.enable - Enable VR support
#
{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop;
in
{
  options.my.desktop = {
    enable = lib.mkEnableOption "desktop environment";

    hyprland = {
      enable = lib.mkEnableOption "Hyprland compositor";
    };

    fonts = {
      enable = lib.mkEnableOption "custom fonts configuration";
    };

    flatpak = {
      enable = lib.mkEnableOption "Flatpak support";
    };

    sunshine = {
      enable = lib.mkEnableOption "Sunshine remote desktop";
    };

    waydroid = {
      enable = lib.mkEnableOption "Waydroid Android container";
    };

    keyd = {
      enable = lib.mkEnableOption "keyd key remapping";
    };

    gaming = {
      enable = lib.mkEnableOption "gaming support";

      steam = {
        enable = lib.mkEnableOption "Steam" // {
          default = true;  # Enable by default when gaming is enabled
        };
      };

      vr = {
        enable = lib.mkEnableOption "VR support (Monado, etc.)";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Base desktop configuration
    {
      services.xserver.enable = true;
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    }

    # Hyprland
    (lib.mkIf cfg.hyprland.enable {
      environment.systemPackages = [ pkgs.canta-theme ];

      services.xserver.xkb = {
        variant = "";
        layout = "us";
      };

      programs.uwsm.enable = true;
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      qt.style = "kvantum";
    })

    # Fonts
    (lib.mkIf cfg.fonts.enable {
      fonts = {
        packages = with pkgs; [
          noto-fonts-cjk-serif
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          twitter-color-emoji
          source-han-sans
          source-han-serif
          jetbrains-mono
          hackgen-nf-font
          udev-gothic-nf
          nerd-fonts._0xproto
          orbitron
        ];
        fontDir.enable = true;
        fontconfig = {
          defaultFonts = {
            serif = [ "Noto Serif CJK JP" "Noto Color Emoji" ];
            sansSerif = [ "Noto Sans CJK JP" "Noto Color Emoji" ];
            monospace = [ "UDEV Gothic 35NF" "Noto Color Emoji" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
    })

    # Flatpak
    (lib.mkIf cfg.flatpak.enable {
      services.flatpak.enable = true;
      systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };
    })

    # Sunshine
    (lib.mkIf cfg.sunshine.enable {
      services.sunshine = {
        enable = true;
        openFirewall = true;
        autoStart = true;
        capSysAdmin = true;
      };
      systemd.user.services.sunshine = {
        wantedBy = [ "graphical.target" ];
      };
    })

    # Waydroid
    (lib.mkIf cfg.waydroid.enable {
      environment.systemPackages = [ pkgs.waydroid-helper ];
      virtualisation.waydroid.enable = true;
    })

    # keyd
    (lib.mkIf cfg.keyd.enable {
      services.keyd = {
        enable = true;
        keyboards = {
          "*" = {
            settings = {
              main = {
                capslock = "overload(control, esc)";
                space = "overload(meta, space)";
                muhenkan = "overload(meta, space)";
                rightalt = "overload(rightalt, hiragana_katakana)";
              };
            };
          };
        };
      };
    })

    # Gaming - Steam
    (lib.mkIf (cfg.gaming.enable && cfg.gaming.steam.enable) {
      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        fontPackages = [ pkgs.migu ];
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    })

    # Gaming - VR
    (lib.mkIf (cfg.gaming.enable && cfg.gaming.vr.enable) {
      environment.systemPackages = [ pkgs.wlx-overlay-s ];
      programs.immersed.enable = true;

      services.monado = {
        enable = true;
        defaultRuntime = true;
      };
      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.libva ];
      };
    })
  ]);
}
