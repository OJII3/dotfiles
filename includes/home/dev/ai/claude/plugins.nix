{ pkgs, ... }:

let
  # プラグインの定義
  plugins = [
    # 例: プラグインを追加する場合
    # {
    #   name = "example-plugin";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "owner-name";
    #     repo = "repo-name";
    #     rev = "commit-hash-or-tag";
    #     sha256 = "sha256-hash";
    #   };
    # }
    {
      name = "kuu-marketplace";
      src = pkgs.fetchFromGitHub {
        owner = "fumiya-kume";
        repo = "claude-code";
        rev = "master";
        sha256 = "sha256-i144+G3n9SiwIJxEIoc58Jwn6Nbxk6qHTD4z87DnH2o=";
      };
    }
  ];

  # プラグインディレクトリの作成
  mkPluginLinks = builtins.listToAttrs (
    map (plugin: {
      name = ".claude/plugins/marketplaces/${plugin.name}";
      value = {
        source = plugin.src;
        recursive = true;
      };
    }) plugins
  );
in
{
  home.file = mkPluginLinks;
}
