{
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

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
    antigravity-nix.url = "github:jacopone/antigravity-nix";
    llm-agents-nix.url = "github:numtide/llm-agents.nix";
    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      nixosConfigurations = (import ./hosts inputs).nixos;
      homeConfigurations = (import ./hosts inputs).home-manager;
      darwinConfigurations = (import ./hosts inputs).nix-darwin;
      nixOnDroidConfigurations = (import ./hosts inputs).nix-on-droid;

      formatter = lib.genAttrs systems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree);

      checks = lib.genAttrs systems (system: {
        formatting =
          inputs.nixpkgs.legacyPackages.${system}.runCommand "nix-fmt-check-${system}" { src = ./.; }
            ''
              cp -rL $src src
              chmod -R u+w src
              cd src
              ${inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree}/bin/treefmt --ci --tree-root "$PWD"
              touch $out
            '';

        darwin-modules =
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            minimalDarwin = inputs.nix-darwin.lib.darwinSystem {
              inherit system;
              modules = [
                ./modules/darwin
                {
                  dot.darwin.core.enable = true;
                  nix.enable = false;
                  system.stateVersion = 6;
                }
              ];
              specialArgs = {
                inherit inputs;
                hostname = "eval-test";
                username = "eval-test";
              };
            };
          in
          builtins.seq minimalDarwin.config.system.build.toplevel.drvPath (
            pkgs.runCommand "darwin-modules" { } ''
              echo "Darwin module evaluation: OK" >&2
              touch $out
            ''
          );
      });
    };
}
