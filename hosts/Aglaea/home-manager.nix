{ ... }:
{
  imports = [
    ../../modules/home
  ];

  programs.ssh = {
    enable = true;
    settings."*" = {
      IdentitiesOnly = "yes";
      IdentityFile = "~/.ssh/gpg-agent.pub";
    };
  };

  home.file.".ssh/gpg-agent.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICirSl3nlg3z3VID3ondlBDy7teYu74pnRPFhvj2LfkH";

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git = {
      enable = true;
      signing = {
        format = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
    };
    gpg.enable = true;
    gpg.pinentryPackage = "gnome3";
    gnomeKeyring.enable = true;
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      power.serverLike = true;
      gnome = {
        enable = true;
      };
      fcitx5.enable = true;
      keyd.enable = true;
      theme.enable = true;
    };

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
    };

    ai = {
      enable = true;
      agy.enable = true;
      codex.enable = true;
      chatgpt.enable = true;
      dsh.enable = false;
      t3code = {
        enable = true;
        backgroundService = {
          enable = true;
          host = "0.0.0.0";
        };
      };
    };

    apps = {
      common.enable = true;
      linux = {
        common.enable = true;
        gnome.enable = true;
      };
    };

    gaming.minecraft.enable = true;

    # Other
    bitwarden.enable = true;
    blenderLauncher.enable = true;
    network.enable = true;
    obsidian.enable = true;
  };

  home.stateVersion = "26.05";
}
