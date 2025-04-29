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
  # NixOS ========================================================================
  nixos = {
    Renchon = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Renchon";
      username = "ojii3";
      modules = [
        ./Renchon/nixos.nix
      ];
    };
    Lingsha = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Lingsha";
      username = "ojii3";
      modules = [ ./Lingsha/nixos.nix ];
    };
    Oshio = mkNixosSystem {
      system = "aarch64-linux";
      hostname = "Oshio";
      username = "ojii3";
      modules = [ ./Oshio/nixos.nix ];
    };
  };

  # Home Manager ====================================================================
  home-manager = {
    "ojii3@Renchon" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Renchon/home-manager.nix ];
    };
    "ojii3@Lingsha" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Lingsha/home-manager.nix ];
    };
    "ojii3@Cipher" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Cipher/home-manager.nix ];
    };
    "ojii3@Himeko" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Himeko/home-manager.nix ];
    };
    "ojii3@Oshio" = mkHomeManagerConfiguration {
      system = "aarch64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Oshio/home-manager.nix ];
    };
  };

  # MacOS ==========================================================================
  nix-darwin = {
    "Himeko" = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "Himeko";
      username = "ojii3";
      modules = [ ./Himeko/darwin.nix ];
    };
  };
}

