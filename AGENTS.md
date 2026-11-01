# Repository Notes

## Home Manager

- `home-manager switch` の前に、新規ファイルを `git add` する。flake は git 管理下のファイルしか評価しないため、未追跡の module や skill はビルドに含まれない。
- `home-manager switch` は定義が変わった `t3code.service` を停止・再起動する。このサービス内で動いている agent セッションはそのままでは切断されるので、switch は独立した一時ユニットとして実行する:
  ```bash
  systemd-run --user --unit hm-switch --collect bash -lc \
    'cd ~/src/github.com/ojii3/dotfiles && home-manager switch --flake .#ojii3@$(hostname) > /tmp/hm-switch.log 2>&1; echo EXIT:$? >> /tmp/hm-switch.log'
  ```
  サービス復帰後に `/tmp/hm-switch.log` の `EXIT:0` を確認する。agent の前面シェルで直接 switch を実行しない。
