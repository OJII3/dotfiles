# Agent Skills のリンク管理
#
# 「skills/<name>/SKILL.md」形式で発見されるスキルを、有効化されたツールの
# スキルディレクトリへ symlink する汎用エンジン。
#
# - enable 連動: cfg.<tool>.enable が true のツールにのみリンクする。
# - 出し分け: 各スキルは tools = [ ... ] で対象ツールを限定できる(既定は全ツール)。
# - superpowers のような複数スキルを内包するパックは自動展開する。
#
# 注: opencode / agy は skills/ 機構ではなく独自のプラグイン/拡張機構を持つため、
#     skillDirs には含めず ./superpowers.nix 側で個別に対応する。
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dot.home.ai;
  inherit (lib) filterAttrs attrNames listToAttrs filter elem mkMerge optionals;

  # ツール → スキル配置ディレクトリ
  skillDirs = {
    claude = ".claude/skills";
    codex = ".codex/skills";
    pi = ".pi/agent/skills";
  };

  # ディレクトリ直下のサブディレクトリ名一覧
  subdirsOf = dir: attrNames (filterAttrs (_: type: type == "directory") (builtins.readDir dir));

  # 内蔵スキル(./skills/<name>/)
  localSkillsDir = ./skills;
  localSkills = optionals (builtins.pathExists localSkillsDir) (
    map (name: {
      inherit name;
      src = localSkillsDir + "/${name}";
    }) (subdirsOf localSkillsDir)
  );

  # 単体リモートスキル
  remoteSkills = [
    {
      name = "notebooklm";
      src = pkgs.fetchFromGitHub {
        owner = "PleasePrompto";
        repo = "notebooklm-skill";
        rev = "v1.3.0";
        sha256 = "sha256-oOkKuDvKuU8UylYZehT2lyERXla5H81oVddTg3ej2pQ=";
      };
    }
    {
      name = "playwright";
      src =
        let
          upstream = pkgs.fetchFromGitHub {
            owner = "lackeyjb";
            repo = "playwright-skill";
            rev = "v4.1.0";
            sha256 = "sha256-77VxY7ik7UtLVHcLeDS2dfnoaf+zkYB6FMScP63rF9w=";
          };
        in
        pkgs.runCommand "playwright-skill-pi-compatible" { } ''
          cp -R ${upstream}/skills/playwright-skill $out
          chmod -R u+w $out
          substituteInPlace $out/SKILL.md \
            --replace-fail "name: Playwright Browser Automation" "name: playwright"
        '';
    }
    {
      name = "pdf";
      src = inputs.anthropics-skills;
      baseDir = "skills/pdf";
    }
    {
      name = "webapp-testing";
      src = inputs.anthropics-skills;
      baseDir = "skills/webapp-testing";
    }
    {
      name = "frontend-design";
      src = inputs.anthropics-skills;
      baseDir = "skills/frontend-design";
    }
    {
      name = "mcp-builder";
      src = inputs.anthropics-skills;
      baseDir = "skills/mcp-builder";
    }
    {
      name = "pptx";
      src = inputs.anthropics-skills;
      baseDir = "skills/pptx";
    }
    {
      name = "docx";
      src = inputs.anthropics-skills;
      baseDir = "skills/docx";
    }
    {
      name = "doc-coauthoring";
      src = inputs.anthropics-skills;
      baseDir = "skills/doc-coauthoring";
    }
    {
      name = "xlsx";
      src = inputs.anthropics-skills;
      baseDir = "skills/xlsx";
    }
  ];

  # superpowers パック(skills/ 配下の複数スキルを自動展開)。
  # hook / opencode plugin / gemini extension は ./superpowers.nix で対応する。
  superpowersSkills = map (name: {
    inherit name;
    src = inputs.superpowers;
    baseDir = "skills/${name}";
  }) (subdirsOf (inputs.superpowers + "/skills"));

  allSkills = localSkills ++ remoteSkills ++ superpowersSkills;

  # スキル → 実ソースパス / 対象ツール
  skillSource = skill: if skill ? baseDir then "${skill.src}/${skill.baseDir}" else "${skill.src}";
  skillTools = skill: skill.tools or (attrNames skillDirs);

  # 指定ツールのスキルディレクトリへのリンク群
  linksFor =
    tool:
    listToAttrs (
      map (skill: {
        name = "${skillDirs.${tool}}/${skill.name}";
        value = {
          source = skillSource skill;
          recursive = true;
        };
      }) (filter (skill: elem tool (skillTools skill)) allSkills)
    );

  enabledTools = filter (tool: cfg.${tool}.enable) (attrNames skillDirs);
in
{
  home.file = mkMerge (map linksFor enabledTools);
}
