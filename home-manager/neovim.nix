{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;

    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = with pkgs; [
      # tree-sitter
      deno
      nodejs
      tree-sitter
      # lsp, formatter, linter, etc
      biome
      tinymist
      typst-lsp
      stylua
      lua-language-server
      nil
      typescript-language-server
    ];

    # extraLuaConfig = builtins.readFile ./dotfiles/.config/nvim/init.lua;
  };

  home.file.".config/nvim" = {
    source = ./dotfiles/.config/nvim;
    recursive = true;
  };
}
