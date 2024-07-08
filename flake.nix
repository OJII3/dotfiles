{
	inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "git+file:dotfiles";
      flake = false;
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      myNixOS = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
					./configuration.nix
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
					./home.nix
				];
			};
 		};
	};
}
