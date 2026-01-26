# Module Arguments Deep Dive

Complete reference for flake-parts module arguments and how they work.

## Function Signature Inspection

The module system uses `builtins.functionArgs` to determine which arguments to pass:

```nix
# ✅ CORRECT - explicitly requests specific arguments
{ pkgs, system, config, ... }: { }

# The module system inspects this signature and passes:
# - pkgs
# - system
# - config
# - ... (other available arguments)

# ❌ WRONG - catch-all doesn't work
args: {
  # args will NOT contain pkgs, system, etc.
  # The module system can't inspect what you need
}
```

**Key insight**: Only named parameters in your function signature receive values. The module system cannot pass special arguments through a catch-all parameter.

## Per-System Arguments

Available inside `perSystem` blocks:

### pkgs

The nixpkgs package set for the current system.

**Customization via `_module.args.pkgs`:**
```nix
perSystem = { system, ... }: {
  _module.args.pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ inputs.self.overlays.default ];
  };

  # All uses of pkgs now use this customized version
  packages.myapp = pkgs.callPackage ./myapp.nix { };
};
```

**Default**: If not customized, uses `inputs.nixpkgs.legacyPackages.${system}`.

### system

Current architecture string: `"x86_64-linux"`, `"aarch64-linux"`, `"x86_64-darwin"`, etc.

```nix
perSystem = { system, lib, ... }: {
  packages = lib.optionalAttrs (system == "x86_64-linux") {
    linux-only = pkgs.someLinuxTool;
  };
};
```

### inputs'

**Purpose**: Auto-selects system for input flake outputs.

```nix
# ❌ Without inputs' - manual system selection
perSystem = { inputs, system, ... }: {
  packages = {
    tool1 = inputs.nixpkgs.legacyPackages.${system}.gcc;
    tool2 = inputs.some-flake.packages.${system}.default;
  };
};

# ✅ With inputs' - automatic
perSystem = { inputs', ... }: {
  packages = {
    tool1 = inputs'.nixpkgs.legacyPackages.gcc;
    tool2 = inputs'.some-flake.packages.default;
  };
};
```

**How it works**: For each input `foo`, `inputs'.foo` accesses `inputs.foo` with system-specific outputs pre-selected for the current system.

### self'

**Purpose**: Access your flake's own outputs with system pre-selected.

```nix
perSystem = { self', config, ... }: {
  devShells.default = pkgs.mkShell {
    # Access your own packages
    packages = [ self'.packages.myapp ];
  };

  # Or use config (more direct)
  devShells.alt = pkgs.mkShell {
    packages = [ config.packages.myapp ];
  };
};
```

**Difference from config**:
- `config.packages.myapp` - Current perSystem configuration (more direct)
- `self'.packages.myapp` - Full flake output (goes through complete evaluation)

Usually `config` is more efficient.

### config

Access other values in the current perSystem configuration:

```nix
perSystem = { config, ... }: {
  packages = {
    lib = pkgs.callPackage ./lib.nix { };
    app = pkgs.callPackage ./app.nix {
      my-lib = config.packages.lib;
    };
  };

  devShells.default = pkgs.mkShell {
    packages = builtins.attrValues config.packages;
  };
};
```

### final (with easyOverlay)

When using `flakeModules.easyOverlay`, `final` represents the package set after overlays:

```nix
perSystem = { pkgs, final, config, ... }: {
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  packages = {
    lib-base = pkgs.callPackage ./lib-base.nix { };

    lib-extended = pkgs.callPackage ./lib-extended.nix {
      # ✅ Use final to get overlaid version
      lib-base = final.lib-base;
    };

    app = pkgs.callPackage ./app.nix {
      lib-base = final.lib-base;
      lib-extended = final.lib-extended;
    };
  };

  overlayAttrs = {
    inherit (config.packages) lib-base lib-extended app;
  };
};
```

**Key distinction**:
- `pkgs` - "Previous" package set (before your overlay)
- `final` - "Final" package set (after your overlay)

## Top-Level Arguments

Available at flake level (outside perSystem):

### withSystem

**Most important bridge function** - enters a system's scope to access perSystem values:

```nix
flake.nixosConfigurations.machine = withSystem "x86_64-linux" (
  { config, pkgs, self', inputs', ... }:
    # All per-system arguments available here
    nixpkgs.lib.nixosSystem {
      modules = [{
        environment.systemPackages = [
          config.packages.myapp
          self'.packages.mytool
          inputs'.other.packages.tool
        ];
      }];
    }
);
```

**Available arguments inside withSystem**:
- All per-system arguments: `config`, `pkgs`, `system`, `inputs'`, `self'`, `final`
- Access to the complete perSystem configuration for that system

**Without withSystem**:
```nix
environment.systemPackages = [
  self.packages.x86_64-linux.myapp
  self.packages.x86_64-linux.mytool
  # Repetitive and error-prone!
];
```

### getSystem

Retrieves per-system configuration for a specific system:

```nix
let
  x86Packages = (getSystem "x86_64-linux").packages;
  armPackages = (getSystem "aarch64-linux").packages;
in {
  flake.someOutput = {
    inherit x86Packages armPackages;
  };
}
```

**When to use**: Rarely needed. Prefer `withSystem` for most cases.

### moduleWithSystem

Brings perSystem arguments into top-level module scope:

```nix
imports = [
  (moduleWithSystem ({ config, system, ... }: {
    # Can use both top-level and per-system config
    flake.someAttr = config.packages.myapp;
  }))
];
```

**When to use**: When you need both top-level and per-system values in the same module without using withSystem repeatedly.

## The @ Pattern

Access multiple scopes without shadowing:

```nix
{ config, ... }: {
  myTopLevelOption = "foo";

  perSystem = toplevel@{ config, pkgs, ... }: {
    # config          = per-system config
    # toplevel.config = top-level config

    packages.example = pkgs.writeText "value"
      toplevel.config.myTopLevelOption;
  };
}
```

**Without @**, you'd lose access to top-level config:
```nix
{ config, ... }: {
  myTopLevelOption = "foo";

  perSystem = { config, pkgs, ... }: {
    # config is now perSystem config
    # No way to access top-level config!
  };
}
```

**Pattern variations**:
```nix
# Capture top-level in perSystem
perSystem = toplevel@{ config, ... }: { ... }

# Capture per-system in nested module
perSystem = { config, ... }: {
  imports = [ (persystem@{ config, ... }: {
    # persystem.config = perSystem config
    # config = current module config
  }) ];
}
```

## Accessing allSystems

```nix
{ config, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myapp = pkgs.hello;
  };

  # Access all systems' packages at top-level
  flake.allPackages = config.allSystems;
  # Result: { x86_64-linux = { packages = { myapp = ...; }; }; ... }
}
```

## Common Pitfalls

### Forgetting the @ Symbol

```nix
# ❌ WRONG - can't access top-level
{ config, ... }: {
  perSystem = { config, ... }: {
    # Can't access top-level config here!
  };
}

# ✅ CORRECT - use @
{ config, ... }: {
  perSystem = toplevel@{ config, ... }: {
    # Can access both now
  };
}
```

### Using Catch-All Arguments

```nix
# ❌ WRONG - won't receive special arguments
args: {
  packages = args.pkgs.hello;  # pkgs won't be in args!
}

# ✅ CORRECT - explicitly name arguments
{ pkgs, ... }: {
  packages.hello = pkgs.hello;
}
```

### Circular Dependencies with self

```nix
# ❌ WRONG - creates circular dependency
perSystem = { pkgs, ... }: {
  packages.myapp = inputs.self.packages.${pkgs.system}.other;
}

# ✅ CORRECT - use self' or config
perSystem = { pkgs, self', config, ... }: {
  packages.myapp = self'.packages.other;
  # OR
  packages.myapp = config.packages.other;
}
```

## Summary

**Most common arguments**:
- `pkgs` - Nixpkgs for current system
- `config` - Access other perSystem values
- `inputs'` - Input flake outputs with system selected
- `self'` - Your flake's outputs with system selected

**For bridging to flake-level**:
- `withSystem` - Access perSystem values from flake-level (most important)
- `getSystem` - Manual system selection (rare)

**For advanced scenarios**:
- `@` pattern - Access multiple scopes
- `final` - Work with easyOverlay
- `moduleWithSystem` - Bring perSystem args to top-level

Related: [Back to main guide](SKILL.md) | [Overlays guide](overlays.md) | [Advanced patterns](advanced.md)
