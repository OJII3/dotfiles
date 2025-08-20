{ ... }: {
  imports = [
    ./.
  ];

  services.tuned.settings.dynamic_tuning = true;
}
