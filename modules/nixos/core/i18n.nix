{ pkgs, ... }:
{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console = {
    font = "ter-124b";
    packages = with pkgs; [
      terminus_font
    ];
  };
}
