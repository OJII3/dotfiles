inputs:
let
  mkNixosSystem =
    { system, hostname, username, modules }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit inputs hostname username;
      };
    };

  mkHomeManagerConfiguration =
    { system, username, overlays, modules }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
      extraSpecialArgs = {
        inherit inputs username;
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
      };
      modules = modules ++ [
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "24.11";
          };
          programs.home-manager.enable = true;
        }
      ];
    };
in
{
  nixos = {
    Renchon = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Renchon";
      username = "ojii3";
      modules = [
        ./Renchon/nixos.nix
      ];
    };
    Komachan = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Komachan";
      username = "ojii3";
      modules = [ ./Komachan/nixos.nix ];
    };
  };

  home-manager = {
    "ojii3@Renchon" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [
        ./Renchon/home-manager.nix
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
    };
    "ojii3@Komachan" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Komachan/home-manager.nix ];
    };
  };
}

