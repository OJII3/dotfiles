{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home;
  clangdir = if pkgs.stdenv.isDarwin then "Library/Preferences/clangd" else ".config/clangd";
in
{
  config = lib.mkIf cfg.neovim.enable {
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
        cmake
        python3
        gcc
        rustc
        cargo
        tree-sitter
        inputs.mcp-hub.packages."${pkgs.stdenv.hostPlatform.system}".default
        # ACP
        gemini-cli-bin
        codex-acp
        claude-code-acp
        # MCP server dependencies -------------------------
        uv
        bun
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
        nixd
        nixfmt
        nodePackages.prettier
        ty
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
      ];
    };

    home.file.".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    home.file.".config/mcphub/servers.json".source = ./mcphub/servers.json;

    # for skkeleton
    home.file.".skk/SKK-JISYO.L".source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
    home.file.".skk/SKK-JISYO.propernoun".source =
      "${pkgs.skkDictionaries.propernoun}/share/skk/SKK-JISYO.propernoun";

    home.file.".clang-tidy".source = ./.clang-tidy;
    home.file.".clang-format".source = ./.clang-format;
    home.file."${clangdir}/config.yaml".source = ./clangd/config.yaml;
  };
}
