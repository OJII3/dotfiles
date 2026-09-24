---
name: ghpm
description: 現在のPRをsquash mergeしてブランチを削除する。
---

現在のブランチの PR を squash merge し、マージ後にリモートとローカルのブランチを削除する。

1. `gh pr view --json number,state,headRefName` で現在のブランチの PR を確認する。PR がない、OPEN 状態でない、または head branch が現在のブランチと異なる場合は中止する。
2. `gh pr merge --squash --delete-branch` を実行する。
3. マージとブランチ削除の結果を報告する。
