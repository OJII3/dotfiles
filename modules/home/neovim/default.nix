{ inputs, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    defaultEditor = true;

    extraLuaPackages = ps: [ ps.magick ps.tiktoken_core ];
    extraPackages = with pkgs; [
      imagemagick
      deno
      gnumake
      gcc
      tree-sitter
      inputs.mcp-hub.packages."${system}".default
      # lsp, formatter, linter
      astro-language-server
      bash-language-server
      biome
      clang-tools
      cmake-language-server
      matlab-language-server
      dockerfile-language-server-nodejs
      efm-langserver
      haskell-language-server
      haskellPackages.lsp
      hyprls
      lua-language-server
      nil
      nixpkgs-fmt
      nixpkgs-lint
      # eslint
      nodePackages.prettier
      pyright
      python311Packages.debugpy
      ruff
      rust-analyzer
      shellcheck
      stylelint-lsp
      stylua
      tailwindcss-language-server
      taplo
      texlab
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
    source = ./config/nvim;
    recursive = true;
  };

  home.file.".skk" = {
    source = "${pkgs.skkDictionaries.l}/share/skk";
    recursive = true;
  };

  home.file.".clang-tidy".source = ./config/.clang-tidy;
  home.file.".clang-format".source = ./config/.clang-format;
  home.file.".config/clangd/config.yaml".source = ./config/clangd/config.yaml;
  home.file."Library/Preferences/clangd/config.yaml".source = ./config/clangd/config.yaml;

  home.file.".ideavimrc".source = ./config/.ideavimrc;
}

