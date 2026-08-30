# Gaming module options
# All option definitions for dot.home.gaming.*
{ lib, ... }:
{
  options.dot.home.gaming.minecraft.enable = lib.mkEnableOption "Minecraft via Prism Launcher";
}
