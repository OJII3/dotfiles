{ pkgs, ... }: {
  home.packages = with pkgs; [
    helix
  ];
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixpkgs}/bin/nixfmt";
    }];
    extraPackages = with pkgs; [
      helix-gpt
    ];
  };
}

