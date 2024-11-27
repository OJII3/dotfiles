{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ags.url = "github:Aylur/ags";
  };

  outputs = inputs: {
    nixosConfigurations = {
      Renchon = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nur.nixosModules.nur
          ./nixos/configuration.nix
          ./nixos/configuration.Renchon.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };
      Komachan = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nur.nixosModules.nur
          ./nixos/configuration.nix
          ./nixos/configuration.Komachan.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
    homeConfigurations = {
      myHome = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home-manager
        ];
      };
    };
  };
}
