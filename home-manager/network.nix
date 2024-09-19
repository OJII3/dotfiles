{ pkgs, ... }: {
  home.packages = with pkgs; [
    wireshark
    whois
    traceroute
  ];
}

