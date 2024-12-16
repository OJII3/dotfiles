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
      bash-language-server
      biome
      clang-tools
      cmake-language-server
      matlab-language-server
      csharp-ls
      dockerfile-language-server-nodejs
      efm-langserver
      haskell-language-server
      lua-language-server
      nil
      nixpkgs-fmt
      nixpkgs-lint
      nodePackages.eslint
      nodePackages.prettier
      pyright
      python311Packages.debugpy
      ruff
      rust-analyzer
      shellcheck
      stylelint
      stylua
      tailwindcss-language-server
      taplo
      tinymist
      typescript-language-server
      typstyle
      vim-language-server
      vscode-langservers-extracted
      yaml-language-server
      yamlfmt
      yamllint
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

