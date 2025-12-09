{
  inputs,
  pkgs,
  ...
}:
let
  clangdir = if pkgs.stdenv.isDarwin then "Library/Preferences/clangd" else ".config/clangd";
in
{
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
      # ACP
      gemini-cli-bin
      codex-acp
      # codex-acp
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
      dockerfile-language-server
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
    source = ./nvim;
    recursive = true;
  };
  home.file.".config/mcphub/servers.json".source = ./mcphub/servers.json;

  # for skkeleton
  home.file.".skk" = {
    source = "${pkgs.skkDictionaries.l}/share/skk";
    recursive = true;
  };

  home.file.".clang-tidy".source = ./.clang-tidy;
  home.file.".clang-format".source = ./.clang-format;
  home.file."${clangdir}/config.yaml".source = ./clangd/config.yaml;
}
