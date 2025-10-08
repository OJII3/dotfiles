{ config, ... }:
{
  sops.secrets."github_runners_tuatmcc_wand" = { };
  environment.etc."github_runners_tuatmcc_wand_env".source =
    config.sops.secrets."github_runners_tuatmcc_wand".path;

  imports = [ ./compose.nix ];
}
