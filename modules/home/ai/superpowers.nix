# superpowers プラグインのツール横断グルー
#
# superpowers (https://github.com/obra/superpowers) は単体スキルではなく、
# 複数スキル + 各ハーネス向けの導入機構を持つプラグイン。
#
# - claude/codex 向けの skills/ への展開は ./skills.nix が担う(superpowersSkills)。
# - 本モジュールは skills/ では表現できないツール固有の glue のみを担当する:
#     - Claude: SessionStart hook が毎セッション using-superpowers を注入する
#               (hook 本体の登録は ./claude/settings.json)。
#     - OpenCode: ネイティブ plugin がスキル登録 + bootstrap 注入を行う。
#     - Antigravity: gemini extension として読み込む。
#
# バージョンは flake input `superpowers` (flake.lock) で pin される。
{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home.ai;
  src = inputs.superpowers;
in
{
  config = lib.mkMerge [
    # Claude: hook スクリプトが自身の親ディレクトリを PLUGIN_ROOT として
    # skills/using-superpowers/SKILL.md を解決するため、ツリー全体を symlink する。
    (lib.mkIf cfg.claude.enable {
      home.file.".claude/superpowers".source = src;
    })

    # OpenCode: 自動検出される plugin ディレクトリへエントリポイントを symlink する。
    # plugin 本体が skills を自動登録するため、設定ファイルへの追記は不要。
    (lib.mkIf cfg.opencode.enable {
      home.file.".config/opencode/plugins/superpowers.js".source =
        src + "/.opencode/plugins/superpowers.js";
    })

    # Antigravity: gemini extension 機構で読み込む(GEMINI.md が using-superpowers を import)。
    (lib.mkIf cfg.agy.enable {
      home.file.".gemini/extensions/superpowers".source = src;
    })
  ];
}
