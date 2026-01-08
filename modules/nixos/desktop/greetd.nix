# greetd login manager configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.greetd.enable) (lib.mkMerge [
    # Autologin greeter
    (lib.mkIf (cfg.greetd.greeter == "autologin") {
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = cfg.greetd.sessionCommand;
            user = cfg.greetd.user;
          };
          default_session = initial_session;
        };
      };
    })

    # TUI greeter
    (lib.mkIf (cfg.greetd.greeter == "tuigreet") {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --remember --remember-session --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red --cmd ${cfg.greetd.sessionCommand}";
            user = cfg.greetd.user;
          };
        };
      };
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    })
  ]);
}
