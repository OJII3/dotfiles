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
      # lsp, formatter, linter
      efm-langserver
      # typst-lsp
      tinymist
      typstyle
      lua-language-server
      stylua
      biome
      typescript-language-server
      vscode-langservers-extracted
      eslint_d
      prettierd
      stylelint
      pyright
      ruff
      shellcheck
      nil
      nixpkgs-fmt
      nixpkgs-lint
      clang-tools
      python311Packages.debugpy
      dockerfile-language-server-nodejs
      yaml-language-server
      yamlfmt
      yamllint
      vim-language-server
      rust-analyzer
      # dap
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

