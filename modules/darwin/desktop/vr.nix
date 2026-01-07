{ username, ... }:
{
  homebrew = {
    taps = [
      "Oculus-VR/tap"
    ];
    brews = [
      "meta-xr-simulator"
    ];
  };

  environment.variables = {
    XR_RUNTIME_JSON = "/Users/${username}/Libraray/MetaXR/MetaXRSimulator/71.0.0/meta_xr_simulator.json";
  };
}
