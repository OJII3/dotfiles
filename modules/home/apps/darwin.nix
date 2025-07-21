{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    appcleaner
    scroll-reverser
    terminal-notifier
    utm
  ] ++
  (with pkgs.brewCasks; [
    # cloudflare-warp
    # docker
    # wireshark
    bleunlock
    blockbench
    chatgpt
    figma
    firefox
    ghostty
    moonlight
    obs
    (minecraft.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-gsWdmzKFAX4tbRsDX1OUFcH+tQ14daTwNMwprycye0g=";
      };
    }))
    # (parsec.overrideAttrs (oldAtters: {
    #   src = pkgs.fetchurl {
    #     url = builtins.head oldAtters.src.urls;
    #     hash = "sha256-nge8K8JaLeWAhvyYB8Vgs3X+Ca9QXJT3PsKz8hLK5Sg=";
    #   };
    # }))
    # steam
    (unity-hub.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-jLiBOoRRe7fNzF0RNfCtqPQAEmzdNm2zdhrxsht/Gkc=";
      };
    }))
  ]);
}
