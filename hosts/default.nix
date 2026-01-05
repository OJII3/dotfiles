inputs:
let
  mkNixosSystem =
    {
      system,
      hostname,
      username,
      modules,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit inputs hostname username;
      };
    };

  mkHomeManagerConfiguration =
    {
      system,
      username,
      overlays,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
      extraSpecialArgs = {
        inherit inputs username;
        pkgs-ros = import inputs.nixpkgs-ros {
          inherit system;
          overlays = [ inputs.nix-ros-overlay.overlays.default ];
        };
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
            homeDirectory = "${if system == "aarch64-darwin" then "/Users" else "/home"}/${username}";
            stateVersion = "24.11";
          };
          programs.home-manager.enable = true;
        }
      ];
    };

  mkDarwinSystem =
    {
      system,
      hostname,
      username,
      modules,
    }:
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

  mkNixOnDroidConfiguration =
    { system, modules }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      inherit modules;
    };
in
{
  # NixOS ========================================================================
  nixos = {
    Aglaea = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Aglaea";
      username = "ojii3";
      modules = [
        ./Aglaea/nixos.nix
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      ];
    };
    Bronya = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Bronya";
      username = "ojii3";
      modules = [
        ./Bronya/nixos.nix
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      ];
    };
    Cyrene = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Cyrene";
      username = "ojii3";
      modules = [
        inputs.nixos-wsl.nixosModules.default
        ./Cyrene/nixos-wsl.nix
      ];
    };
    Lingsha = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Lingsha";
      username = "ojii3";
      modules = [
        ./Lingsha/nixos.nix
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      ];
    };
    Cipher = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Cipher";
      username = "ojii3";
      modules = [
        ./Cipher/nixos.nix
      ];
    };
  };

  # Home Manager ====================================================================
  home-manager = {
    "ojii3@Aglaea" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Aglaea/home-manager.nix ];
    };
    "ojii3@Bronya" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Bronya/home-manager.nix ];
    };
    "ojii3@Cyrene" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Cyrene/home-manager.nix ];
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
      overlays = [ inputs.brew-nix.overlays.default ];
      modules = [ ./Himeko/home-manager.nix ];
    };
    "ojii3@Welt" = mkHomeManagerConfiguration {
      system = "aarch64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Welt/home-manager.nix ];
    };
  };

  # MacOS ==========================================================================
  nix-darwin = {
    "Himeko" = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "Himeko";
      username = "ojii3";
      modules = [
        inputs.brew-nix.darwinModules.default
        ./Himeko/darwin.nix
      ];
    };
  };

  nix-on-droid = {
    "SilverWolf" = mkNixOnDroidConfiguration {
      system = "aarch64-linux";
      modules = [ ./SilverWolf/nix-on-droid.nix ];
    };
  };
}
