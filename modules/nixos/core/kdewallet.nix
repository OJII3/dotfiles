{ ... }: {
  # Kwallet for no GUI sessions
  security.pam.services.login.kwallet = {
    enable = true;
    forceRun = true;
  };
}
