{ ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        user = "ojii3";
      };
      default_session = initial_session;
    };
  };
}
