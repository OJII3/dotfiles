{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;

    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = with pkgs; [
      # tree-sitter
      deno
      nodejs
      tree-sitter
    ];
  };

  home.file.".config/nvim" = {
    source = ./dotfiles/.config/nvim;
    recursive = true;
  };

  home.packages = with pkgs; [
    skk-dicts
  ];

  home.file.".skk" = {
    source = "${pkgs.skk-dicts}/share";
    recursive = true;
  };
}
