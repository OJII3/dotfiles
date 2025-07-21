{
  # uwsm need to be enabled from NixOS configuration
  home.file.".config/uwsm/env".source = ./env;
}
