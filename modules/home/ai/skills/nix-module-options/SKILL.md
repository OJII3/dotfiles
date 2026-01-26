**name:** nix-module-options

**description:** Query NixOS and Home Manager module options programmatically using flake evaluation. Use this skill when the user asks to check if a module exists, explore available options, get option documentation, or verify what options are available in upstream NixOS/Home Manager (not custom user modules). Activates for queries like "does home manager have a module for X", "what options does service Y have", "check nixos options for Z", or "explore available options".

**allowed-tools:** Bash, Read

---

## Nix Module Options Explorer

Expert guidance for programmatically querying NixOS and Home Manager module options using flake evaluation.

### Core Capability

This skill provides optimized Nix expressions to query module options from your flake-parts configuration, reusing pre-evaluated values for performance.

### Key Benefits

1. Offline queries - No need for web searches or option search sites
2. Upstream purity - Queries pure Home Manager/NixOS modules (excludes user custom modules)
3. Performance - Reuses pre-evaluated `pkgs` from flake debug
4. System-agnostic - Uses `currentSystem` for portability
5. Complete documentation - Returns type, description, default, examples via `optionAttrSetToDocList`

### Home Manager Module Options

**Check if option exists:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
    hmLib = args.pkgs.lib.extend (self: super: {
      hm = import "${flake.inputs.home-manager}/modules/lib" { lib = self; };
    });
  in
    (hmLib.evalModules {
      modules = import "${flake.inputs.home-manager}/modules/modules.nix" {
        lib = hmLib;
        pkgs = args.pkgs;
        check = false;
      };
    }).options.OPTION.PATH or null
' --json | jq 'if . == null then "NOT FOUND" else "EXISTS" end'
```

**Get full option documentation:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
    hmLib = args.pkgs.lib.extend (self: super: {
      hm = import "${flake.inputs.home-manager}/modules/lib" { lib = self; };
    });
  in
    args.pkgs.lib.optionAttrSetToDocList (
      hmLib.evalModules {
        modules = import "${flake.inputs.home-manager}/modules/modules.nix" {
          lib = hmLib;
          pkgs = args.pkgs;
          check = false;
        };
      }
    ).options.OPTION.PATH
' --json | jq
```

**List all options in a category:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
    hmLib = args.pkgs.lib.extend (self: super: {
      hm = import "${flake.inputs.home-manager}/modules/lib" { lib = self; };
    });
    opts = (hmLib.evalModules {
      modules = import "${flake.inputs.home-manager}/modules/modules.nix" {
        lib = hmLib;
        pkgs = args.pkgs;
        check = false;
      };
    }).options;
  in
    builtins.attrNames opts.CATEGORY
' --json | jq -r '.[]'
```

### NixOS Module Options

**Check if option exists:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
  in
    (args.pkgs.lib.evalModules {
      modules = import "${flake.inputs.nixpkgs}/nixos/modules/module-list.nix" ++ [
        { nixpkgs.hostPlatform = args.system; }
      ];
    }).options.OPTION.PATH or null
' --json | jq 'if . == null then "NOT FOUND" else "EXISTS" end'
```

**Get full option documentation:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
  in
    args.pkgs.lib.optionAttrSetToDocList (
      args.pkgs.lib.evalModules {
        modules = import "${flake.inputs.nixpkgs}/nixos/modules/module-list.nix" ++ [
          { nixpkgs.hostPlatform = args.system; }
        ];
      }
    ).options.OPTION.PATH
' --json | jq
```

**List all options in a category:**
```bash
nix eval --impure --expr '
  let
    flake = builtins.getFlake (builtins.toString ./.);
    args = flake.currentSystem.allModuleArgs;
    opts = (args.pkgs.lib.evalModules {
      modules = import "${flake.inputs.nixpkgs}/nixos/modules/module-list.nix" ++ [
        { nixpkgs.hostPlatform = args.system; }
      ];
    }).options;
  in
    builtins.attrNames opts.CATEGORY
' --json | jq -r '.[]'
```

### Common Option Categories

**Home Manager top-level:**
- `programs.*` - User programs (git, vim, zsh, etc.)
- `services.*` - User services (gpg-agent, syncthing, etc.)
- `home.*` - Home directory settings
- `xdg.*` - XDG directory configuration
- `accounts.*` - Email, calendar accounts
- `systemd.*` - User systemd units
- `gtk.*`, `qt.*` - Desktop theming
- `wayland.*` - Wayland compositors

**NixOS top-level:**
- `services.*` - System services (nginx, postgresql, etc.)
- `programs.*` - System-wide programs
- `hardware.*` - Hardware configuration
- `boot.*` - Boot loader and kernel
- `networking.*` - Network configuration
- `environment.*` - System environment
- `systemd.*` - System units
- `users.*` - User management
- `virtualisation.*` - Containers, VMs
- `security.*` - Security settings

### Option Documentation Fields

`lib.optionAttrSetToDocList` returns structured documentation:

- **name** - Full option path (e.g., `programs.git.enable`)
- **description** - What the option does (markdown formatted)
- **type** - Expected value type (e.g., `boolean`, `string`, `list of string`)
- **default** - Default value if not set
- **example** - Usage examples
- **declarations** - Source file where option is defined
- **visible** - Whether option appears in documentation
- **readOnly** - Whether option can be modified
- **internal** - Whether option is internal-only

### Usage Patterns

**Quick existence check:** When user asks "does home manager have a duf module?", use null-checking patterns.

**Get option details:** When user asks "what options does programs.git have?", filter visible options and extract key fields.

**List available options:** When user asks "what programs are available in home manager?", enumerate attribute names.

### Technical Details

**Why use `currentSystem.allModuleArgs`?**

1. Pre-evaluated - `pkgs` already instantiated by flake-parts
2. System-aware - `args.system` provides current system automatically
3. Overlay-aware - Includes your overlays
4. Faster - Reuses existing evaluation

**Purity Guarantees:**

These expressions query upstream modules only, importing directly from flake inputs without including user custom modules or actual configurations.

### Best Practices

1. Use `jq` for filtering - Pipe to `jq` for readable output
2. Filter visible options - Use `select(.visible == true)` to hide internal options
3. Cache results - Add frequently-used queries to flake outputs
4. Check existence first - Use `or null` pattern before getting full docs
5. Reference declarations - Use `.declarations` field to find upstream source

### Troubleshooting

**"path does not exist" error:** The flake path must exist. Ensure running from within your flake repository.

**"attribute does not exist" error:** Verify correct category, nesting, and that the option exists upstream.

**Evaluation too slow:** Consider adding queries as flake outputs.

**Wrong module system:** Use appropriate evalModules function for Home Manager vs NixOS.

---

**Version History:** v1.0 (2025-10-28) - Initial skill creation with optimized flake-parts evaluation
