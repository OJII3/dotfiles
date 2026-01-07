{ ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "zsh";
        user = "ojii3";
      };
      default_session = initial_session;
    };
  };
}
