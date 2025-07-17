{ pkgs, ... }: {
  home.packages = with pkgs; [
    blender
    discord
    # ghostty # broken on darwin
    jetbrains-toolbox
    slack
  ];

  programs = {
    vscode.enable = true;
  };
}

