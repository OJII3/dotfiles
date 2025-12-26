{ pkgs, ... }:

let
  # Agent Skills の定義
  skills = [
    # 例: スキルを追加する場合
    # {
    #   name = "example-skill";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "owner-name";
    #     repo = "repo-name";
    #     rev = "commit-hash-or-tag";
    #     sha256 = "sha256-hash";
    #   };
    # }
    {
      name = "notebooklm";
      src = pkgs.fetchFromGitHub {
        owner = "PleasePrompto";
        repo = "notebooklm-skill";
        rev = "v1.3.0";
        sha256 = "sha256-oOkKuDvKuU8UylYZehT2lyERXla5H81oVddTg3ej2pQ=";
      };
    }
  ];

  # スキルディレクトリの作成
  mkSkillLinks = builtins.listToAttrs (
    map (skill: {
      name = ".claude/skills/${skill.name}";
      value = {
        source = skill.src;
        recursive = true;
      };
    }) skills
  );
in
{
  home.file = mkSkillLinks;
}
