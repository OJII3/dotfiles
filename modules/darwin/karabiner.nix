{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # karabiner-elements
    goku
  ];

  services.karabiner-elements.enable = true;

  # LaunchAgents for Karabiner-Elements
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner_observer.plist".enable = false;
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner_grabber.plist" = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner_grabber.plist";
  };
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner-Menu.plist" = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner-Menu.plist";
  };
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner-NotificationWindow.plist" = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner-NotificationWindow.plist";
  };
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner-MultitouchExtension.plist" = {
    enable = false;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner-MultitouchExtension.plist";
  };
  environment.userLaunchAgents."org.pqrs.karabiner.agent.karabiner_session_monitor.plist" = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner_session_monitor.plist";
  };
  environment.userLaunchAgents."org.pqrs.karabiner.karabiner_console_user_server.plist" = {
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner_console_user_server.plist";
  };

  # LaunchDaemons for Karabiner-Elements
  environment.launchDaemons.Karabiner-DriverKit-VirtualHIDDeviceClient = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Privileged Daemons.app/Contents/Library/LaunchDaemons/org.pqrs.service.daemon.karabiner_driverkit_virtual_hid_device_client.plist";
  };
  environment.launchDaemons.karabiner_grabber = {
    enable = true;
    source = lib.mkForce "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Privileged Daemons.app/Contents/Library/LaunchDaemons/org.pqrs.service.daemon.karabiner_grabber.plist";
  };
}

