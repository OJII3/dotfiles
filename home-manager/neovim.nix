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
      efm-langserver
      typst-lsp
      tinymist
      lua-language-server
      stylua
      typescript-language-server
      eslint_d
      vscode-langservers-extracted
      prettierd
      stylelint
      pyright
      ruff
      shellcheck
      nil
      nixpkgs-fmt
      nixpkgs-lint
      clang-tools
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

  home.file.".clang-tidy".source = ./dotfiles/.clang-tidy;
  home.file.".clang-format".source = ./dotfiles/.clang-format;
}

