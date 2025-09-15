{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    immersed
  ];

  # openxr
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      vaapiVdpau
    ];
  };
}
