{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    lshw
    usbutils
    nix-index
    comma
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    git = {
      enable = true;
    };
    vim.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
    };
    zsh = {
      enable = true;
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      openssl
      libuv
    ];
  };
}
