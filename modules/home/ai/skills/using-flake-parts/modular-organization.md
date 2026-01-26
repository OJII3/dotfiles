# Modular Organization with Flake-Parts

Flake-parts-specific patterns for organizing modules: imports, importApply, and reusable flakeModules.

## Basic Module Imports

Simple modules that don't need flake-level context:

```nix
# flake.nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./modules/packages.nix
        ./modules/shells.nix
      ];
    };
}

# modules/packages.nix
{ perSystem = { pkgs, ... }: {
  packages.tool = pkgs.callPackage ../packages/tool { };
}; }

# modules/shells.nix
{ perSystem = { pkgs, config, ... }: {
  devShells.default = pkgs.mkShell {
    packages = [ config.packages.tool ];
  };
}; }
```

## importApply Pattern

**Problem**: Modules imported via `imports` don't have access to the flake's lexical scope (like `withSystem`, `inputs`, etc.).

**Solution**: `importApply` - a flake-parts utility that passes arguments to modules.

### Basic importApply

```nix
# flake.nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = [ "x86_64-linux" ];

      imports = [
        ./modules/packages.nix
        # Pass withSystem to module that needs it
        (inputs.flake-parts.lib.importApply ./modules/nixos.nix {
          inherit withSystem;
        })
      ];
    });
}

# modules/nixos.nix
{ withSystem }: { inputs, ... }: {
  # Now has access to withSystem
  flake.nixosConfigurations.machine = withSystem "x86_64-linux" (
    { config, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [{
          environment.systemPackages = [ config.packages.tool ];
        }];
      }
  );
}
```

**Key insight**: The module file is a **function that returns a module**.

### Multiple Arguments

```nix
# flake.nix
imports = [
  (inputs.flake-parts.lib.importApply ./modules/complex.nix {
    inherit withSystem inputs;
    myCustomArg = "value";
  })
];

# modules/complex.nix
{ withSystem, inputs, myCustomArg }: { config, ... }: {
  # Can use all passed arguments
  flake.example = myCustomArg;
}
```

## Reusable Flake Modules

Export modules via `flakeModules` output for use in other flakes.

### Creating a Reusable Module

```nix
# your-tool/flake.nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      # Build the actual package
      perSystem = { pkgs, ... }: {
        packages.your-tool = pkgs.callPackage ./package.nix { };
      };

      # Export reusable module
      flake.flakeModules.default = {
        perSystem = { config, lib, pkgs, ... }: {
          options.your-tool = {
            enable = lib.mkEnableOption "your-tool";

            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.your-tool;
              description = "Package to use";
            };
          };

          config = lib.mkIf config.your-tool.enable {
            packages.your-tool = config.your-tool.package;
          };
        };
      };
    };
}
```

### Using a Reusable Module

```nix
# consumer-flake/flake.nix
{
  inputs.your-tool.url = "github:you/your-tool";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Import the module
      imports = [ inputs.your-tool.flakeModules.default ];

      systems = [ "x86_64-linux" ];

      perSystem = { ... }: {
        # Enable the tool
        your-tool.enable = true;

        # Or customize
        # your-tool = {
        #   enable = true;
        #   package = pkgs.callPackage ./custom.nix { };
        # };
      };
    };
}
```

## Dogfooding Pattern

**Problem**: You can't import from `self` (`imports = [ inputs.self.flakeModules.default ];` creates circular dependency).

**Solution**: Use importApply to pass the flake module in.

```nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = [ "x86_64-linux" ];

      # Define the module
      flake.flakeModules.default = {
        perSystem = { config, lib, pkgs, ... }: {
          options.myproject.enable = lib.mkEnableOption "myproject";
          config = lib.mkIf config.myproject.enable {
            packages.myproject = pkgs.callPackage ./package.nix { };
          };
        };
      };

      # Use it in the same flake (dogfooding)
      imports = [
        (inputs.flake-parts.lib.importApply (
          { flakeModules }: { imports = [ flakeModules.default ]; }
        ) {
          flakeModules = inputs.self.flakeModules;
        })
      ];

      perSystem.myproject.enable = true;
    });
}
```

## Module File Structures

### Directory Hierarchy

```nix
# flake.nix
{
  imports = [ ./modules ];
}

# modules/default.nix
{
  imports = [
    ./packages.nix
    ./shells.nix
  ];
}

# modules/packages.nix
{ perSystem = { pkgs, ... }: {
  packages.tool = pkgs.callPackage ../packages/tool { };
}; }
```

### Using Directory Imports

Flake-parts automatically imports `default.nix` from directories:

```
modules/
├── default.nix
├── packages.nix
└── shells.nix
```

```nix
# flake.nix
imports = [ ./modules ];  # Loads modules/default.nix

# modules/default.nix
{ imports = [ ./packages.nix ./shells.nix ]; }
```

## Best Practices

### When to Use Simple Imports

Use simple `imports` when modules only need:
- `perSystem` arguments (`pkgs`, `config`, `system`, `inputs'`, `self'`)
- Top-level module arguments (`config`, `lib`, `options`)

```nix
# modules/simple.nix
{ perSystem = { pkgs, ... }: {
  packages.tool = pkgs.hello;
}; }
```

### When to Use importApply

Use `importApply` when modules need:
- Flake-level context (`withSystem`, `getSystem`, `moduleWithSystem`)
- Custom values from your flake's lexical scope

```nix
# Needs withSystem
imports = [
  (importApply ./modules/nixos.nix { inherit withSystem; })
];
```

### When to Create flakeModules

Create `flakeModules` output when:
- Building reusable tools for other flakes
- Want others to import your module
- Need versioned module distribution

## Common Patterns

### Multiple Module Outputs

```nix
flake.flakeModules = {
  default = ./modules/default.nix;
  minimal = ./modules/minimal.nix;
  full = ./modules/full.nix;
};

# Consumers choose
imports = [ inputs.your-tool.flakeModules.minimal ];
```

### Conditional Module Loading

```nix
perSystem = { system, lib, ... }: {
  imports = lib.optionals (system == "x86_64-linux") [
    ./modules/linux-specific.nix
  ];
};
```

## Summary

**Key flake-parts features**:
- **Simple imports**: For modules needing only standard arguments
- **importApply**: Pass flake-level context to modules
- **flakeModules output**: Export reusable modules
- **Dogfooding**: Use your own modules via importApply

**Decision tree**:
1. Module needs `withSystem`? → Use importApply
2. Module is reusable? → Export as flakeModules
3. Otherwise → Use simple imports

Related: [Module arguments](module-arguments.md) | [Advanced patterns](advanced.md) | [Back to main guide](SKILL.md)
