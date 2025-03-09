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
            homeDirectory =
              "${if system == "aarch64-darwin" then "/Users" else "/home"}/${username}";
            stateVersion = "24.11";
          };
          programs.home-manager.enable = true;
        }
      ];
    };

  mkDarwinSystem =
    { system, hostname, username, modules }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = modules ++ [
        {
          nix.enable = false;
          # stateVersion = "6";
        }
      ];
      specialArgs = {
        inherit inputs hostname username;
      };
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
    Oshio = mkNixosSystem {
      system = "aarch64-linux";
      hostname = "Oshio";
      username = "ojii3";
      modules = [ ./Oshio/nixos.nix ];
    };
  };

  home-manager = {
    "ojii3@Renchon" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Renchon/home-manager.nix ];
    };
    "ojii3@Komachan" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Komachan/home-manager.nix ];
    };
    "ojii3@Dagashiya" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Dagashiya/home-manager.nix ];
    };
    "ojii3@Oshio" = mkHomeManagerConfiguration {
      system = "aarch64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Oshio/home-manager.nix ];
    };
  };

  nix-darwin = {
    "Dagashiya" = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "Dagashiya";
      username = "ojii3";
      modules = [ ./Dagashiya/darwin.nix ];
    };
  };
}

