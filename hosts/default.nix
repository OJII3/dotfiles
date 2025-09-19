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
    Bronya = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "Bronya";
      username = "ojii3";
      modules = [
        ./Bronya/nixos.nix
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
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
        inputs.proxmox-nixos.nixosModules.proxmox-ve
      ];
    };
  };

  # Home Manager ====================================================================
  home-manager = {
    "ojii3@Bronya" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "ojii3";
      overlays = [ ];
      modules = [ ./Bronya/home-manager.nix ];
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
