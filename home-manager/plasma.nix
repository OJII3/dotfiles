{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.krdp
  ];
  programs.plasma = {
    enable = true;

    workspace = {
      cursor = {
        theme = "miku-cursor-linux";
        size = 32;
      };
    };

    shortcuts = {
      "ghostty"."Launch" = "Meta+Enter,none";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Switch Window Down" = "Meta+J";
      "kwin"."Switch Window Left" = "Meta+H";
      "kwin"."Switch Window Right" = "Meta+L";
      "kwin"."Switch Window Up" = "Meta+K";
      "kwin"."Window Quick Tile Top" = "Meta+Shift+K";
      "kwin"."Window Quick Tile Bottom" = "Meta+Shift+J,";
      "kwin"."Window Quick Tile Right" = "Meta+Shift+L,";
      "kwin"."Window Quick Tile Left" = "Meta+Shift+H,";
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "plasmashell"."activate task manager entry 1" = "none";
      "plasmashell"."activate task manager entry 2" = "none";
      "plasmashell"."activate task manager entry 3" = "none";
      "plasmashell"."activate task manager entry 4" = "none";
      "plasmashell"."activate task manager entry 5" = "none";
      "plasmashell"."activate task manager entry 6" = "none";
      "plasmashell"."activate task manager entry 7" = "none";
      "plasmashell"."activate task manager entry 8" = "none";
      "plasmashell"."activate task manager entry 9" = "none";
      "plasmashell"."activate task manager entry 10" = "none";
    };

    configFile = {
      "kwinrc"."Desktops"."Id_1" = "5bce3f57-0f95-41b1-893e-84c17a7a33c0";
      "kwinrc"."Desktops"."Id_2" = "f7129c95-6b60-48ec-8e7f-d1ce42364cc7";
      "kwinrc"."Desktops"."Id_3" = "f25b5f71-622c-4734-bd1a-cad0842e058b";
      "kwinrc"."Desktops"."Id_4" = "3ac64404-9d47-4df6-9d7e-2ea4dfdee58d";
      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Windows"."Placement" = "Maximizing";
    };
  };
}
