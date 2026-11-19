# AGENTS.md

Project-specific guidance. The global `AGENTS.md` still applies.

## Project

- Nilla project, not a flake; `default.nix` imports `nilla.nix`.
- `npins` pins inputs. `nixpkgs` is `surfaceflinger/natpkgs` master, so pinned
  revisions may be uncached; prefer evaluating or testing packages against
  registry nixpkgs when a full build is expensive.
- Every flake/nilla input must use the project's nixpkgs: add flakes to
  `nixpkgsOverrides`, and force `nixpkgs.src` for nilla-project inputs.
- Hosts: `hosts/<host>/configuration.nix`.
- Shared modules: `modules/nixos/`, `modules/home/`.
- Packages: `packages/<name>/default.nix` is auto-exposed as `pkgs.<name>`.

## Desktop modules

- `modules/nixos/desktop-env` is session-agnostic: everything a graphical host
  needs regardless of which session runs (fonts, portal enable, bluetooth,
  logind power key, gtk theming packages, session variables). Sessions opt in
  on top of it.
- Sessions are separate modules and are not imported by `desktop-env`:
  `modules/nixos/niri` (`compositor.nix`, `ly.nix`, `portal.nix`,
  `lock.nix`). Hosts pick it in their `imports`.
- The niri home session lives in `modules/home/niri`, one file per component
  (`ashell`, `compositor`, `hotkeys`, `idle`, `launcher`, `lock`, `nightlight`,
  `polkit`, `tui`, `wallpaper`), all pulled in by `default.nix`.
  `modules/home/stylix` holds the stylix base config (scheme, cursor, enabled
  targets) plus niri-flake's stylix target, which paints the niri decorations.
- The niri config is generated from `programs.niri.settings`
  (niri-flake's home-manager module, `inputs.niri-flake.result.homeModules.config`)
  against the running niri version (`niri-unstable` package from the same
  flake, fetched via its cachix cache).
- niri accepts a single `binds` node in the whole generated config, so all
  keymaps live in `modules/home/niri/hotkeys.nix` even when the bind belongs
  to another component (ashell IPC keys, the hyprlock bind).
- niri windows open floating globally; per-component `window-rule` blocks are
  appended from their own files.

## Theme

- Everything comes from stylix (`modules/home/stylix/default.nix`): the
  vendored `corduroy-dark` base16 scheme, fonts, cursor, opacity, and
  `autoEnable = true` with explicit `enable = false` only for mangohud
  (manual interpolation) and wpaperd (directory cycling).
- Reference `config.lib.stylix.colors` (`.withHashtag` when the consumer wants
  `#rrggbb` strings), `config.stylix.fonts.*` and `config.stylix.opacity.*`.
- Do not hardcode UI colors, font names, radii, blur or opacity in a home
  module. Package names such as the GTK theme (`adw-gtk3`) and icon theme
  (`MoreWaita`) are not colors and may be written literally.
- Theme consuming configs: ashell, bluetuith, wifitui, raffi, hyprtoolkit, the
  ghostty theme, niri via niri-flake and the GTK/dconf font and cursor
  settings.

## Commands

- Evaluate a host:
  ```sh
  nix eval --raw --impure --expr 'let n = import ./nilla.nix; in n.systems.nixos.blahaj.result.config.system.build.toplevel.drvPath'
  ```
- Build a package with the same pattern, ending at
  `n.systems.nixos.blahaj.result.pkgs.<name>`.
- If the pinned set is uncached, test packages against registry nixpkgs:
  ```sh
  nix build --impure --expr 'let p = import (builtins.getFlake "nixpkgs") {}; in p.callPackage ./packages/<name> {}'
  ```
- `nilla` only sees git-tracked files; `git add` new files first.
- Validating session configs: building the generated config file runs the
  program's own checker, e.g.
  ```sh
  nix build --impure --expr 'let n = import ./nilla.nix; in n.systems.nixos.djungelskog.result.config.home-manager.users.nat.xdg.configFile.niri-config.source'
  ```
  which runs `niri validate`; the same works for `"raffi/raffi.yaml"`
  (schema check) and the ashell TOML.

## Style

- `nixfmt`; check with `nixfmt --check`.
- Prefer pipe operators (`|>`) for transformation chains; keep simple calls simple.
- Comments lowercase and only non-obvious `why`; no changelog/narration comments.
- Closure size matters; prefer small packages/wrappers and measure before adding
  heavy dependencies.

## Packages

- Keep packages self-contained: pin sources with `fetchFromGitHub`/`fetchurl`
  instead of importing `npins` or project inputs.
- New packages should build against registry nixpkgs and run upstream tests if
  present.

## Checks

- `nixfmt --check`; `ruff format --check` for Python; `git diff --check`.
- Nix cleanup: `statix fix .` (fix lints), `deadnix -e .` (remove dead code),
  `nixfmt -s .` (strict in-place format).
- Evaluate the affected host. Full builds only when the pinned nixpkgs is cached.
- Do not eval every host by default: evaluate `djungelskog` only, and add another
  host only when the change touches it, since each eval costs about 25s.

## Commits

- End with `Assisted-by: harness:modelslug`; wrap bodies at 72 columns.
- Do not push unless asked.
