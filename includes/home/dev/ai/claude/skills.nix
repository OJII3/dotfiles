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
    #   # オプショナル: リポジトリのルートにスキルがない場合、サブディレクトリを指定
    #   # baseDir = "path/to/skill";
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
    {
      name = "playwright";
      src = pkgs.fetchFromGitHub {
        owner = "lackeyjb";
        repo = "playwright-skill";
        rev = "v4.1.0";
        sha256 = "sha256-77VxY7ik7UtLVHcLeDS2dfnoaf+zkYB6FMScP63rF9w=";
      };
      baseDir = "skills/playwright-skill";
    }
    {
      name = "pdf";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/pdf";
    }
    {
      name = "webapp-testing";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/webapp-testing";
    }
    {
      name = "frontend-design";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/frontend-design";
    }
    {
      name = "mcp-builder";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/mcp-builder";
    }
    {
      name = "pptx";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/pptx";
    }
    {
      name = "docx";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/docx";
    }
    {
      name = "doc-coauthoring";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/doc-coauthoring";
    }
    {
      name = "xlsx";
      src = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "skills";
        rev = "69c0b1a0674149f27b61b2635f935524b6add202";
        sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
      };
      baseDir = "skills/xlsx";
    }
  ];

  # スキルディレクトリの作成
  mkSkillLinks = builtins.listToAttrs (
    map (skill: {
      name = ".claude/skills/${skill.name}";
      value = {
        source = if skill ? baseDir then "${skill.src}/${skill.baseDir}" else skill.src;
        recursive = true;
      };
    }) skills
  );
in
{
  home.file = mkSkillLinks;
}
