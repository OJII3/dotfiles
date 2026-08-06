# VR development configuration
# Applied when dot.darwin.desktop.vr.enable is true
{
  config,
  lib,
  username,
  inputs,
  ...
}:
let
  cfg = config.dot.darwin.desktop;
  simulatorRoot = "/Users/${username}/Library/MetaXR/MetaXRSimulator";
  simulatorRuntime = "${simulatorRoot}/current/meta_openxr_simulator.json";
  simulatorSource = "${config.homebrew.prefix}/opt/meta-xr-simulator";
in
{
  config = lib.mkIf (cfg.enable && cfg.vr.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.desktop.vr requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];

    nix-homebrew = {
      taps."oculus-vr/tap" = inputs.oculus-vr-tap;
      trust = {
        taps = [ "oculus-vr/tap" ];
      };
    };

    homebrew = {
      brews = [
        "meta-xr-simulator"
      ];
    };
    #
    environment.variables = {
      XR_RUNTIME_JSON = simulatorRuntime;
    };

    system.activationScripts.postActivation.text = lib.mkAfter ''
      simulator_source=${lib.escapeShellArg simulatorSource}
      simulator_root=${lib.escapeShellArg simulatorRoot}
      simulator_user=${lib.escapeShellArg username}

      if [ ! -d "$simulator_source" ]; then
        printf '%s\n' "Meta XR Simulator is not installed: $simulator_source" >&2
        exit 1
      fi

      if ! simulator_real_path="$(readlink -f -- "$simulator_source")"; then
        printf '%s\n' "Unable to resolve Meta XR Simulator: $simulator_source" >&2
        exit 1
      fi

      if [ ! -d "$simulator_real_path" ] || [ ! -f "$simulator_real_path/meta_openxr_simulator.json" ]; then
        printf '%s\n' "Meta XR Simulator runtime manifest is missing: $simulator_real_path" >&2
        exit 1
      fi

      simulator_version="$(basename -- "$simulator_real_path")"
      case "$simulator_version" in
        ""|"."|"/")
          printf '%s\n' "Unable to determine Meta XR Simulator version" >&2
          exit 1
          ;;
      esac

      simulator_parent="$(dirname -- "$simulator_root")"
      mkdir -p -- "$simulator_parent"

      current_version=""
      if [ -L "$simulator_root/current" ]; then
        current_version="$(readlink "$simulator_root/current")"
      fi

      needs_copy=true
      if [ "$current_version" = "$simulator_version" ] ''\\
        && [ -f "$simulator_root/$simulator_version/meta_openxr_simulator.json" ]; then
        needs_copy=false
      fi

      if [ "$needs_copy" = true ]; then
        simulator_staging="$(mktemp -d "$simulator_parent/.MetaXRSimulator.XXXXXX")"
        simulator_backup=""
        meta_xr_simulator_restore() {
          simulator_exit_status=$?
          trap - EXIT

          if [ "$simulator_exit_status" -ne 0 ] && [ -n "$simulator_backup" ]; then
            rm -rf -- "$simulator_root" || printf '%s\n' "Unable to remove failed Meta XR Simulator" >&2
            if ! mv "$simulator_backup" "$simulator_root"; then
              printf '%s\n' "Unable to restore the previous Meta XR Simulator" >&2
            fi
          elif [ "$simulator_exit_status" -eq 0 ] && [ -n "$simulator_backup" ]; then
            rm -rf -- "$simulator_backup" || printf '%s\n' "Unable to remove Meta XR Simulator backup" >&2
          fi

          if [ -n "$simulator_staging" ] && [ -e "$simulator_staging" ]; then
            rm -rf -- "$simulator_staging" || printf '%s\n' "Unable to remove Meta XR Simulator staging directory" >&2
          fi
          exit "$simulator_exit_status"
        }
        trap 'meta_xr_simulator_restore' EXIT

        /usr/bin/ditto "$simulator_real_path" "$simulator_staging/$simulator_version"
        if [ ! -f "$simulator_staging/$simulator_version/meta_openxr_simulator.json" ]; then
          printf '%s\n' "Copied Meta XR Simulator is missing its runtime manifest" >&2
          exit 1
        fi
        ln -s "$simulator_version" "$simulator_staging/current"

        simulator_group="$(id -gn "$simulator_user")"
        chown -R "$simulator_user:$simulator_group" "$simulator_staging"

        if [ -e "$simulator_root" ] || [ -L "$simulator_root" ]; then
          simulator_backup="$(mktemp -d "$simulator_parent/.MetaXRSimulator.previous.XXXXXX")"
          rmdir "$simulator_backup"
          if ! mv "$simulator_root" "$simulator_backup"; then
            rm -rf -- "$simulator_backup" || printf '%s\n' "Unable to remove Meta XR Simulator backup" >&2
            simulator_backup=""
            printf '%s\n' "Unable to prepare the previous Meta XR Simulator for rollback" >&2
            exit 1
          fi
        fi

        if ! mv "$simulator_staging" "$simulator_root"; then
          printf '%s\n' "Unable to activate staged Meta XR Simulator" >&2
          exit 1
        fi
        simulator_staging=""
      else
        simulator_group="$(id -gn "$simulator_user")"
        chown -R "$simulator_user:$simulator_group" "$simulator_root"
      fi

      for entry in "$simulator_root"/*; do
        if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
          continue
        fi
        entry_name="$(basename -- "$entry")"
        if [ "$entry_name" != "$simulator_version" ] && [ "$entry_name" != "current" ]; then
          rm -rf -- "$entry"
        fi
      done
    '';
  };
}
