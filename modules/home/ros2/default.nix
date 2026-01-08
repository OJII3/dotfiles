{ config, lib, ... }:
let
  cfg = config.dot.home;
in
{
  imports = [
    ./ros2hubmle-unityhub.nix
  ];

  # ros2 module is enabled via dot.home.ros2.enable
  # The actual packages are in ros2hubmle-unityhub.nix
}
