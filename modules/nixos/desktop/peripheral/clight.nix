{ config, pkgs, ... }:
let user = "ojii3"; in
{
  location.latitude = 35.6895; # 東京
  location.longitude = 139.6917; # 東京
  users.users.${user}.extraGroups = [ "video" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", KERNEL=="*", \
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  services.clight = {
    enable = true;
    settings = {
      # === キャプチャ（WebカメラALS） ===
      device = "/dev/video0"; # 内蔵カメラならだいたい /dev/video0
      captures = 20; # 平均化用に何フレーム見るか
      ac_capture_timeouts = [ 120 300 60 ]; # 昼/夜/屋外 的に間隔を伸縮（例）
      batt_capture_timeouts = [ 180 420 90 ];

      keyboard = { disabled = true; };

      min_brightness = 0.05; # 5%
      max_brightness = 1.00; # 100%

      gamma = {
        diabled = true;
      };
    };
  };
}
