{ pkgs, ... }: {
  home.packages = with pkgs.brewCasks; [
    blender
    blockbench
    chatgpt
    # cloudflare-warp
    discord
    # docker
    figma
    firefox
    ghostty
    (google-chrome.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-iHEQ5wNcj7SLL2tVFR4sTZ7bB5m/TkmbhOAvMp10ao0=";
      };
    }))
    jetbrains-toolbox
    (minecraft.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-gsWdmzKFAX4tbRsDX1OUFcH+tQ14daTwNMwprycye0g=";
      };
    }))
    moonlight
    obs
    # (parsec.overrideAttrs (oldAtters: {
    #   src = pkgs.fetchurl {
    #     url = builtins.head oldAtters.src.urls;
    #     hash = "sha256-nge8K8JaLeWAhvyYB8Vgs3X+Ca9QXJT3PsKz8hLK5Sg=";
    #   };
    # }))
    scroll-reverser
    # steam
    (unity-hub.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-jLiBOoRRe7fNzF0RNfCtqPQAEmzdNm2zdhrxsht/Gkc=";
      };
    }))
    visual-studio-code
    wezterm
    # wireshark
  ];
}
