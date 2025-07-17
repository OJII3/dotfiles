{ pkgs, ... }: {
  home.packages = with pkgs; [
    blender
    discord
    # ghostty # broken on darwin
    jetbrains-toolbox
    slack
    vscode
    wezterm
  ];
}
