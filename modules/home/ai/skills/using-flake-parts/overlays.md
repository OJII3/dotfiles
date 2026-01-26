# easyOverlay Module

The easyOverlay module is a flake-parts-specific feature that auto-generates overlays from perSystem packages.

## What is easyOverlay?

Instead of manually writing overlay functions, easyOverlay automatically generates `overlays.default` from your `perSystem` configuration.

**Key benefit**: Define packages once in perSystem, automatically get an overlay for free.

## Basic Usage

```nix
{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { config, pkgs, final, ... }: {
        # Import the easyOverlay module
        imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

        # Define your packages normally
        packages = {
          mylib = pkgs.callPackage ./mylib.nix { };
          myapp = pkgs.callPackage ./myapp.nix {
            # Use 'final' to reference overlaid packages
            my-lib = final.mylib;
          };
        };

        # Specify which packages should be in the overlay
        overlayAttrs = {
          inherit (config.packages) mylib myapp;
        };
      };

      # Auto-generates: flake.overlays.default
    };
}
```

**What happens**:
1. You define packages in `perSystem.packages`
2. You specify which go in the overlay via `overlayAttrs`
3. Flake-parts generates `overlays.default` automatically

## final vs pkgs

With `easyOverlay` imported, you get two package set arguments:

**`pkgs`** - The "previous" package set (before your overlay):
```nix
packages.mylib = pkgs.callPackage ./mylib.nix { };
```
Use this for normal package definitions.

**`final`** - The "final" package set (after your overlay):
```nix
packages.myapp = pkgs.callPackage ./myapp.nix {
  my-lib = final.mylib;  # Gets the overlaid version
};
```
Use this when packages reference each other.

### Why This Matters

```nix
perSystem = { config, pkgs, final, ... }: {
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  packages = {
    # Base library - uses pkgs
    lib-base = pkgs.stdenv.mkDerivation {
      name = "lib-base";
      src = ./lib-base;
    };

    # Extension library - depends on base
    lib-extended = pkgs.stdenv.mkDerivation {
      name = "lib-extended";
      src = ./lib-extended;
      buildInputs = [ final.lib-base ];  # ✅ Use final
    };

    # Application - depends on both
    myapp = pkgs.stdenv.mkDerivation {
      name = "myapp";
      src = ./app;
      buildInputs = [
        final.lib-base
        final.lib-extended
      ];
    };
  };

  # All packages available via overlay
  overlayAttrs = {
    inherit (config.packages) lib-base lib-extended myapp;
  };
};
```

## Selective overlayAttrs

You don't have to include all packages in the overlay:

```nix
perSystem = { config, pkgs, ... }: {
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  packages = {
    # Public packages
    public-tool = pkgs.callPackage ./public-tool.nix { };
    public-lib = pkgs.callPackage ./public-lib.nix { };

    # Internal tools (not in overlay)
    internal-helper = pkgs.writeShellScript "helper" "...";
  };

  # Only public packages in overlay
  overlayAttrs = {
    inherit (config.packages) public-tool public-lib;
    # internal-helper intentionally excluded
  };
};
```

## Common Pitfalls

### Using pkgs Instead of final

```nix
# ❌ WRONG - mylib not in pkgs yet
packages.myapp = pkgs.callPackage ./app.nix {
  my-lib = pkgs.mylib;  # undefined!
};

# ✅ CORRECT - use final
packages.myapp = pkgs.callPackage ./app.nix {
  my-lib = final.mylib;
};
```

### Circular Dependencies

```nix
# ❌ WRONG - circular dependency
packages = {
  a = pkgs.callPackage ./a.nix { b = final.b; };
  b = pkgs.callPackage ./b.nix { a = final.a; };
};

# ✅ CORRECT - break the cycle
packages = {
  a = pkgs.callPackage ./a.nix { };
  b = pkgs.callPackage ./b.nix { a = final.a; };
};
```

### Forgetting to Import easyOverlay

```nix
# ❌ WRONG - final argument won't be available
perSystem = { pkgs, final, ... }: {
  # Error: final is undefined
};

# ✅ CORRECT - import the module
perSystem = { pkgs, final, ... }: {
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  # Now final is available
};
```

## Generated Overlay Structure

The generated overlay has this form:

```nix
overlays.default = final: prev: {
  # Your overlayAttrs packages become available in pkgs
  mylib = <derivation>;
  myapp = <derivation>;
};
```

This allows consumers to apply your overlay and get your packages in their `pkgs`.

## Summary

**Key concepts**:
- Import `flakeModules.easyOverlay` to enable
- Define packages in `perSystem.packages` as normal
- Specify overlay contents with `overlayAttrs`
- Use `final` when packages reference each other
- Flake-parts auto-generates `overlays.default`

**When to use**:
- Building libraries that other packages depend on
- Want your packages available in the pkgs namespace
- Need proper dependency resolution between packages

Related: [Module arguments](module-arguments.md) | [Modular organization](modular-organization.md) | [Back to main guide](SKILL.md)
