{ ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git = {
      enable = true;
      signing = {
        format = "ssh";
      };
    };
    gpg = {
      enable = true;
      pinentryPackage = "gnome3";
    };
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      fcitx5.enable = true;
      kanata.enable = true;
      theme.enable = true;
      browser.vivaldi.enable = true;
    };

    apps.vicinae.enable = true;

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      jetbrains.enable = true;
      mise.enable = false;
      zellij.enable = true;
    };

    ai = {
      enable = true;
      claude.enable = true;
      codex.enable = true;
      chatgpt.enable = true;
      agy.enable = true;
      opencode.enable = true;
      dsh.enable = true;
      t3code = {
        enable = true;
        backgroundService = {
          enable = true;
        };
      };
    };

    # Apps
    apps.linux = {
      common.enable = true;
    };

    # Other
    bitwarden.enable = true;
    network.enable = true;
    obsidian.enable = true;
  };

  # snap 版 Bambu Studio は GTK の ibus IM モジュールを読み込むが、snap の
  # AppArmor ポリシーが fcitx5 の提供する org.freedesktop.IBus への
  # CreateInputContext を拒否するため、IM モジュールが壊れた状態になり
  # 文字キーの入力が捨てられる (Backspace や貼り付けは IM を通らないので動く)。
  # fcitx5 の fcitx4 互換 DBus は snap でも許可されているため、
  # GTK_IM_MODULE を fcitx にして入力できるようにする。
  home.file.".local/share/applications/bambu-studio_bambu-studio.desktop".text = ''
    [Desktop Entry]
    X-SnapInstanceName=bambu-studio
    Name=BambuStudio
    GenericName=3D Printing Software
    Icon=/snap/bambu-studio/current/meta/gui/icon.png
    X-SnapAppName=bambu-studio
    X-SnapCommonID=com.bambulab.BambuStudio
    Exec=env GTK_IM_MODULE=fcitx /snap/bin/bambu-studio %U
    Terminal=false
    Type=Application
    MimeType=model/stl;model/3mf;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;x-scheme-handler/bambustudio;model/step;
    Categories=Graphics;3DGraphics;Engineering;
    Keywords=3D;Printing;Slicer;slice;3D;printer;convert;gcode;stl;obj;amf;SLA
    StartupNotify=false
    StartupWMClass=bambu-studio
  '';

  targets.genericLinux = {
    enable = true;
    gpu = {
      enable = true;
    };
  };

  programs.zsh.initContent = ''
    [ -f /opt/ros/humble/setup.zsh ] && source /opt/ros/humble/setup.zsh
  '';

  home.stateVersion = "26.05";
}
