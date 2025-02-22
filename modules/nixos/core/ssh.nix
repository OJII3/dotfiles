{ ... }: {
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22222 ];
  };
}
