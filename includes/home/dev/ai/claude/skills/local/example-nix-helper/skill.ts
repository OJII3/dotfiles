/**
 * Nix Helper Skill
 *
 * Nixの設定ファイルの管理をサポートするサンプルスキル
 */

export const skill = {
  name: "nix-helper",
  description: "Nix設定ファイルの管理をサポート（サンプル実装）",

  /**
   * スキルのメイン処理
   */
  async run({ prompt }: { prompt: string }) {
    // プロンプトに基づいて処理を実行
    const lowercasePrompt = prompt.toLowerCase();

    if (lowercasePrompt.includes("rebuild") || lowercasePrompt.includes("switch")) {
      return {
        result: `
# Nix設定の再ビルド

Home Manager を使用している場合:
\`\`\`bash
home-manager switch
\`\`\`

NixOS を使用している場合:
\`\`\`bash
sudo nixos-rebuild switch
\`\`\`

設定を確認してからビルドする場合:
\`\`\`bash
home-manager build
# または
sudo nixos-rebuild build
\`\`\`
`.trim()
      };
    }

    if (lowercasePrompt.includes("update") || lowercasePrompt.includes("upgrade")) {
      return {
        result: `
# Nix パッケージのアップデート

flake を使用している場合:
\`\`\`bash
nix flake update
home-manager switch
\`\`\`

channels を使用している場合:
\`\`\`bash
nix-channel --update
home-manager switch
\`\`\`
`.trim()
      };
    }

    if (lowercasePrompt.includes("search") || lowercasePrompt.includes("パッケージ")) {
      return {
        result: `
# パッケージの検索

公式パッケージ検索:
https://search.nixos.org/packages

コマンドラインで検索:
\`\`\`bash
nix search nixpkgs パッケージ名
\`\`\`
`.trim()
      };
    }

    // デフォルトのヘルプメッセージ
    return {
      result: `
# Nix Helper Skill

このスキルは Nix 環境の管理をサポートします。

## 使用可能なコマンド:
- rebuild/switch - 設定の再ビルド方法を表示
- update/upgrade - パッケージのアップデート方法を表示
- search - パッケージの検索方法を表示

## 例:
- "Nixの設定をrebuildしたい"
- "パッケージをupdateする方法は?"
- "パッケージを検索したい"
`.trim()
    };
  }
};

export default skill;
