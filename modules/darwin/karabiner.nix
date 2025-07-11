{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    karabiner-elements
    goku
  ];

  # environment.launchDaemons = {
  #   "org.pqrs.service.daemon.karabiner_grabber" = {
  #     enable = true;
  #     source = "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Privileged Daemons.app/Contents/Library/LaunchDaemons/org.pqrs.service.daemon.karabiner_grabber.plist";
  #   };
  # };
  #
  # environment.userLaunchAgents = {
  #   "karabiner_session_monitor" = {
  #     enable = true;
  #     source = "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner_session_monitor.plist";
  #   };
  #   "karabiner_console_user_server" = {
  #     enable = true;
  #     source = "${pkgs.karabiner-elements}/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Elements Non-Privileged Agents.app/Contents/Library/LaunchAgents/org.pqrs.service.agent.karabiner_console_user_server.plist";
  #   };
  # };
}

