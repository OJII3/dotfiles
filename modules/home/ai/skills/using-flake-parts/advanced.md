# Advanced Flake-Parts Features

Flake-parts-specific advanced features: partitions, custom outputs, debug mode, and migration strategies.

## Partitions

**Flake-parts feature**: Different system sets for different purposes (e.g., CI vs dev environments).

### Basic Partition Setup

```nix
{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Enable partitions module
      imports = [ inputs.flake-parts.flakeModules.partitions ];

      # Define partitions
      partitions = {
        dev = {
          module = {
            systems = [ "x86_64-linux" "aarch64-darwin" ];

            perSystem = { pkgs, ... }: {
              packages.dev-tool = pkgs.writeShellScriptBin "dev" "echo dev";
            };
          };
        };

        ci = {
          module = {
            systems = [ "x86_64-linux" ];

            perSystem = { pkgs, ... }: {
              packages.ci-runner = pkgs.writeShellScriptBin "ci" "echo ci";
            };
          };
        };
      };
    };
}
```

**Generated output structure:**
```
packages.x86_64-linux.dev.dev-tool
packages.x86_64-linux.ci.ci-runner
packages.aarch64-darwin.dev.dev-tool
```

### Use Cases

**Separate build matrices:**
```nix
partitions = {
  # Full platform support for releases
  release = {
    module = {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem.packages.app = pkgs.callPackage ./app.nix { };
    };
  };

  # Limited platforms for testing
  test = {
    module = {
      systems = [ "x86_64-linux" ];
      perSystem.checks.unit-tests = pkgs.callPackage ./tests { };
    };
  };
};
```

**Different nixpkgs versions:**
```nix
partitions = {
  stable = {
    module = {
      systems = [ "x86_64-linux" ];
      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs-stable { inherit system; };
        packages.stable-app = pkgs.callPackage ./app.nix { };
      };
    };
  };

  unstable = {
    module = {
      systems = [ "x86_64-linux" ];
      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs-unstable { inherit system; };
        packages.unstable-app = pkgs.callPackage ./app.nix { };
      };
    };
  };
};
```

## Custom Flake Outputs

Define non-standard flake outputs using the module system.

**How it works**: The `flake` option accepts both declared options (with types and validation) and arbitrary attributes. This means you can do:
```nix
flake.nixosConfigurations.machine = ...;  # Works without declaring the option first
```

For better practices, declare custom options explicitly for documentation and type checking.

### Simple Custom Output

```nix
{
  # Define a custom option
  options.flake.myCustomOutput = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Custom output structure";
  };

  # Set the value
  config.flake.myCustomOutput = {
    foo = "bar";
    packages = config.allSystems;
  };
}
```

### Custom Output with perSystem Integration

```nix
{
  options.flake.bundledPackages = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.package);
    description = "Packages bundled by category";
  };

  config = {
    perSystem = { pkgs, ... }: {
      packages = {
        cli-tool1 = pkgs.callPackage ./cli1.nix { };
        cli-tool2 = pkgs.callPackage ./cli2.nix { };
        gui-app1 = pkgs.callPackage ./gui1.nix { };
      };
    };

    flake.bundledPackages = lib.mapAttrs (system: cfg: {
      cli = {
        inherit (cfg.packages) cli-tool1 cli-tool2;
      };
      gui = {
        inherit (cfg.packages) gui-app1;
      };
    }) config.allSystems;
  };
}
```

**Access**: `inputs.my-flake.bundledPackages.x86_64-linux.cli.cli-tool1`

### Custom perSystem Options

Create your own module system within perSystem:

```nix
{
  perSystem = { lib, config, ... }: {
    options.myapp = {
      features = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Enabled features";
      };

      package = lib.mkOption {
        type = lib.types.package;
        description = "Built package with features";
      };
    };

    config = {
      myapp.package = pkgs.callPackage ./app.nix {
        features = config.myapp.features;
      };

      packages.default = config.myapp.package;
    };
  };

  # Configure from top-level
  perSystem.myapp.features = [ "feature1" "feature2" ];
}
```

## Debug Mode

Flake-parts provides a debug mode for introspection.

### Enable Debug Mode

```nix
{
  debug = true;

  perSystem = { pkgs, ... }: {
    packages.test = pkgs.hello;
  };
}
```

### Using nix repl

```bash
nix repl
:lf .

# Inspect all module arguments
currentSystem.allModuleArgs

# Trace option definitions
currentSystem.options.packages.files

# See full config
currentSystem.config

# Inspect specific systems
debug.allSystems.x86_64-linux.config.packages

# Find option declarations
debug.options.systems.declarations
```

### Debug Options Structure

With `debug = true`, you get:

- `currentSystem` - Current system's full configuration
- `debug.allSystems` - All systems' configurations
- `debug.options` - Top-level option metadata
- `currentSystem.options` - Per-system option metadata

## Migration from Standard Flakes

### Step-by-Step Migration

**1. Add flake-parts input:**
```nix
inputs.flake-parts.url = "github:hercules-ci/flake-parts";
```

**2. Wrap outputs with mkFlake:**
```nix
# Before
outputs = { nixpkgs, ... }: { ... };

# After
outputs = inputs@{ flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];
  };
```

**3. Convert packages to perSystem:**
```nix
# Before
let
  forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
in {
  packages = forAllSystems (system: {
    hello = nixpkgs.legacyPackages.${system}.hello;
  });
}

# After
perSystem = { pkgs, ... }: {
  packages.hello = pkgs.hello;
};
```

**4. Move flake-level outputs to flake option:**
```nix
# Before
outputs = { ... }: {
  nixosConfigurations.machine = ...;
};

# After
flake.nixosConfigurations.machine = ...;
```

**5. Use withSystem for configs:**
```nix
# Before
nixosConfigurations.machine = nixpkgs.lib.nixosSystem {
  modules = [{
    environment.systemPackages = [
      self.packages.x86_64-linux.myapp
    ];
  }];
};

# After
flake.nixosConfigurations.machine = withSystem "x86_64-linux" (
  { config, ... }:
    nixpkgs.lib.nixosSystem {
      modules = [{
        environment.systemPackages = [ config.packages.myapp ];
      }];
    }
);
```

### Incremental Migration

You can mix old and new:

```nix
outputs = inputs@{ flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];

    # New style - using perSystem
    perSystem = { pkgs, ... }: {
      packages.new-package = pkgs.callPackage ./new.nix { };
    };

    # Old style - still works
    flake.packages.x86_64-linux.legacy-package =
      inputs.nixpkgs.legacyPackages.x86_64-linux.hello;
  };
```

### Migration Checklist

- [ ] Add flake-parts input
- [ ] Wrap outputs with mkFlake
- [ ] Define systems list
- [ ] Convert packages to perSystem
- [ ] Convert devShells to perSystem
- [ ] Convert apps to perSystem
- [ ] Update configs to use withSystem
- [ ] Replace manual system interpolation with inputs'/self'
- [ ] Test with `nix flake check`

## allSystems Attribute

Access all per-system configurations from top-level:

```nix
{ config, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myapp = pkgs.hello;
  };

  # Access all systems
  flake.allPackages = config.allSystems;
  # Result: { x86_64-linux = { packages = { myapp = ...; }; }; ... }

  # Or specific system
  flake.x86Only = config.allSystems.x86_64-linux.packages;
}
```

## Flake-Parts Best Practices

### DO:
- Use `perSystem` for multi-system outputs
- Leverage `withSystem` for bridging to single-system configs
- Explicitly name required module arguments
- Use `config` for local perSystem references
- Use importApply when modules need flake context

### DON'T:
- Traverse inputs with `mapAttrs` (use specific references)
- Access `self` directly (use `self'` or `config`)
- Create unnecessary custom outputs
- Over-complicate with partitions unless needed
- Use catch-all arguments (breaks module system)

## Troubleshooting

### "Infinite recursion" Error

**Cause**: Circular reference in modules or options.

**Fix**: Use `@` pattern or reorganize module structure.

### "Path does not exist in flake"

**Cause**: File not tracked by git.

**Fix**: `git add` the file or use `git add -N` for testing.

### "attribute 'final' missing"

**Cause**: Using `final` without importing easyOverlay.

**Fix**: Add `imports = [ inputs.flake-parts.flakeModules.easyOverlay ];`

## Summary

**Flake-parts-specific advanced features**:
- **Partitions**: Different system sets or nixpkgs versions
- **Custom outputs**: Non-standard flake structure
- **Debug mode**: Introspection and troubleshooting
- **allSystems**: Access per-system configs from top-level

**When to use**:
- Partitions: CI/dev separation, multiple nixpkgs versions
- Custom outputs: Specialized flake structure needs
- Debug mode: Complex configuration troubleshooting

Related: [Module arguments](module-arguments.md) | [Modular organization](modular-organization.md) | [Back to main guide](SKILL.md)
