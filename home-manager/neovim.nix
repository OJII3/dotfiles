{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;

    extraLuaPackages = ps: [ ps.magick ps.tiktoken_core ];
    extraPackages = with pkgs; [
      # tree-sitter
      imagemagick
      deno
      nodejs
      tree-sitter
      # lsp, formatter, linter
      efm-langserver
      tinymist
      typstyle
      lua-language-server
      stylua
      biome
      typescript-language-server
      vscode-langservers-extracted
      nodePackages.eslint
      nodePackages.prettier
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
      haskell-language-server
      # dap
    ];
  };

  home.file.".config/nvim" = {
    source = ../home/.config/nvim;
    recursive = true;
  };

  # home.packages = with pkgs; [
  #   skk-dicts
  # ];
  #
  home.file.".skk" = {
    source = "${pkgs.skkDictionaries.l}/share/skk";
    recursive = true;
  };

  home.file.".clang-tidy".source = ../home/.clang-tidy;
  home.file.".clang-format".source = ../home/.clang-format;

  home.file.".ideavimrc".source = ../home/.ideavimrc;
}

