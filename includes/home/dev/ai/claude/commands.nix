{ pkgs, ... }:
let
  fumiya-kume-claude-code-src = pkgs.fetchFromGitHub {
    owner = "fumiya-kume";
    repo = "claude-code";
    rev = "62f602791fc6f9218263bcea088a104e1fc59cce";
    sha256 = "sha256-zp4RfEwFbUGDOSZpFki1qDgfYcmtY2fujKbarTnjoaM=";
  };
  commands = [
    # 例: GitHubからコマンドを追加する場合
    # {
    #   name = "example-command.md";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "owner-name";
    #     repo = "repo-name";
    #     rev = "commit-hash-or-tag";
    #     sha256 = "sha256-hash";
    #   };
    #   # オプショナル: リポジトリのルートにコマンドがない場合、ファイルパスを指定
    #   # filePath = "path/to/command.md";
    # }
    {
      name = "dig";
      src = fumiya-kume-claude-code-src;
      filePath = "dig/commands/dig.md";
    }
    {
      name = "fix-ci";
      src = fumiya-kume-claude-code-src;
      filePath = "fix-ci/commands/fix-ci.md";
    }
    {
      name = "deslop";
      src = fumiya-kume-claude-code-src;
      filePath = "deslop/commands/deslop.md";
    }
  ];

  # コマンドファイルの作成
  mkCommandLinks = builtins.listToAttrs (
    map (command: {
      name = ".claude/commands/${command.name}.md";
      value = {
        source = "${command.src}/${command.filePath}";
      };
    }) commands
  );
in
{
  home.file = mkCommandLinks;
}
