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
      # lsp
      typst-lsp
      tinymist
      lua-language-server
      stylua
      typescript-language-server
      eslint_d
      pyright
      ruff
      shellcheck
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
