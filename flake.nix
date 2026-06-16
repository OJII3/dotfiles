{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nixpkgs-ros.follows = "nix-ros-overlay/nixpkgs";
    confetti.url = "github:ojii3/confetti";
    anthropics-skills = {
      url = "github:anthropics/skills/main";
      flake = false;
    };
    superpowers = {
      url = "github:obra/superpowers/v5.1.0";
      flake = false;
    };
    # node_modules の FOD ハッシュが上流ピンの nixpkgs(bun バージョン)前提で
    # 計算されているため follows させない。main(HEAD)は darwin 用ハッシュが
    # 更新漏れしていることがあるためリリースタグに固定する。
    opencode.url = "github:sst/opencode/v1.17.4";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    antigravity-nix.url = "github:jacopone/antigravity-nix";
    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs = inputs: {
    nixosConfigurations = (import ./hosts inputs).nixos;
    homeConfigurations = (import ./hosts inputs).home-manager;
    darwinConfigurations = (import ./hosts inputs).nix-darwin;
    nixOnDroidConfigurations = (import ./hosts inputs).nix-on-droid;
  };
}
