{ pkgs, ... }: {
  home.packages = with pkgs; [
    android-studio
  ];

  home.file.".local/share/JetBrains/Toolbox/apps/android-studio" = {
    source = "${pkgs.android-studio}/android-studio";
    recursive = true;
  };
}
