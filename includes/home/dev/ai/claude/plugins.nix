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
  ];

  # プラグインディレクトリの作成
  mkPluginLinks = builtins.listToAttrs (map (plugin: {
    name = ".claude/plugins/marketplace/${plugin.name}";
    value = {
      source = plugin.src;
      recursive = true;
    };
  }) plugins);
in
{
  home.file = mkPluginLinks;
}
