{ username, ... }: {
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ username ];
  };
}

