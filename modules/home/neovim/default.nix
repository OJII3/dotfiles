{ inputs, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    defaultEditor = true;

    extraLuaPackages = ps: [
      ps.magick
      ps.tiktoken_core
    ];
    extraPackages = with pkgs; [
      # utilities or installation tools -----------------
      imagemagick
      deno
      gnumake
      gcc
      rustc
      cargo
      tree-sitter
      inputs.mcp-hub.packages."${system}".default
      # MCP server dependencies -------------------------
      uv
      bun
      # docker
      # docker-compose
      # lsp, formatter, linter --------------------------
      astro-language-server
      bash-language-server
      biome
      (clang-tools.override {
        enableLibcxx = true;
      })
      cmake-language-server
      matlab-language-server
      dockerfile-language-server-nodejs
      efm-langserver
      haskell-language-server
      haskellPackages.lsp
      hyprls
      lua-language-server
      nil
      nixfmt
      # eslint
      nodePackages.prettier
      pyright
      ruff
      rust-analyzer
      shellcheck
      stylelint-lsp
      stylua
      tailwindcss-language-server
      taplo
      terraform-ls
      texlab
      tinymist
      typescript-language-server
      typstyle
      vim-language-server
      vscode-langservers-extracted
      yaml-language-server
      yamlfmt
      yamllint
      # debugger
    ];
  };

  home.file.".config/nvim" = {
    source = ./config/nvim;
    recursive = true;
  };

  home.file.".config/mcphub/servers.json".source = ./config/mcphub/servers.json;

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

