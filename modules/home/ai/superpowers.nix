# superpowers の OpenCode plugin をリンクする。
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
  config = lib.mkIf cfg.opencode.enable {
    # OpenCode が自動検出する plugin ディレクトリへリンクする。
    home.file.".config/opencode/plugins/superpowers.js".source =
      src + "/.opencode/plugins/superpowers.js";
  };
}
