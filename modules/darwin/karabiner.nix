{ config, lib, ... }:
let
  cfg = config.services.karabiner-elements;

  parentAppDir = "/Applications/.Nix-Karabiner";
in
{
  config = {
    environment.systemPackages = [ cfg.package ];

    system.activationScripts.preActivation.text = ''
      rm -rf ${parentAppDir}
      mkdir -p ${parentAppDir}
      # Kernel extensions must reside inside of /Applications, they cannot be symlinks
      cp -r ${cfg.package.driver}/Applications/.Karabiner-VirtualHIDDevice-Manager.app ${parentAppDir}
    '';

    system.activationScripts.postActivation.text = ''
      echo "attempt to activate karabiner system extension and start daemons" >&2
      launchctl unload /Library/LaunchDaemons/org.nixos.start_karabiner_daemons.plist
      launchctl load -w /Library/LaunchDaemons/org.nixos.start_karabiner_daemons.plist
    '';

    # # LaunchAgents for Karabiner-Elements
    launchd.daemons.start_karabiner_daemons = {
      script = ''
        ${parentAppDir}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
        launchctl kickstart system/org.pqrs.karabiner.karabiner_grabber
        launchctl kickstart system/org.pqrs.karabiner.karabiner_observer
      '';
      serviceConfig.Label = "org.nixos.start_karabiner_daemons";
      serviceConfig.RunAtLoad = true;
    };

    launchd.daemons.karabiner_grabber = {
      serviceConfig.ProgramArguments = [
        "${cfg.package}/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_grabber"
      ];
      serviceConfig.ProcessType = "Interactive";
      serviceConfig.Label = "org.pqrs.service.daemon.karabiner_grabber";
      serviceConfig.KeepAlive.SuccessfulExit = true;
      serviceConfig.KeepAlive.Crashed = true;
      serviceConfig.KeepAlive.AfterInitialDemand = true;
    };

    launchd.daemons.karabiner_observer = {
      serviceConfig.ProgramArguments = [
        "${cfg.package}/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_observer"
      ];

      serviceConfig.Label = "org.pqrs.karabiner.karabiner_observer";
      serviceConfig.KeepAlive.SuccessfulExit = true;
      serviceConfig.KeepAlive.Crashed = true;
      serviceConfig.KeepAlive.AfterInitialDemand = true;
    };

    launchd.daemons.Karabiner-DriverKit-VirtualHIDDeviceClient = {
      command = "\"${cfg.package.driver}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-DriverKit-VirtualHIDDeviceClient.app/Contents/MacOS/Karabiner-DriverKit-VirtualHIDDeviceClient\"";
      serviceConfig.ProcessType = "Interactive";
      serviceConfig.Label = "org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon";
      serviceConfig.KeepAlive = true;
    };

    # Normally karabiner_console_user_server calls activate on the manager but
    # because we use a custom location we need to call activate manually.
    launchd.user.agents.activate_karabiner_system_ext = {
      serviceConfig.ProgramArguments = [
        "${parentAppDir}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
        "activate"
      ];
      serviceConfig.RunAtLoad = true;
      managedBy = "services.karabiner-elements.enable";
    };

    # We need this to run every reboot as /run gets nuked so we can't put this
    # inside the preActivation script as it only gets run on darwin-rebuild switch.
    launchd.daemons.setsuid_karabiner_session_monitor = {
      script = ''
        rm -rf /run/wrappers
        mkdir -p /run/wrappers/bin
        install -m4555 "${cfg.package}/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_session_monitor" /run/wrappers/bin
      '';
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive.SuccessfulExit = false;
    };

    launchd.user.agents.karabiner_session_monitor = {
      serviceConfig.ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path /run/wrappers/bin &amp;&amp; /run/wrappers/bin/karabiner_session_monitor"
      ];
      serviceConfig.Label = "org.pqrs.service.agent.karabiner_session_monitor";
      serviceConfig.KeepAlive = true;
      managedBy = "services.karabiner-elements.enable";
    };

    environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner_grabber.plist".source = "${cfg.package}/Library/LaunchAgents/org.pqrs.karabiner.agent.karabiner_grabber.plist";
    environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner_observer.plist".source = "${cfg.package}/Library/LaunchAgents/org.pqrs.karabiner.agent.karabiner_observer.plist";
    environment.userLaunchAgents."org.pqrs.karabiner.karabiner_console_user_server.plist".source = "${cfg.package}/Library/LaunchAgents/org.pqrs.karabiner.karabiner_console_user_server.plist";
  };
}
