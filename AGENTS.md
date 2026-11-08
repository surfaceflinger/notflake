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

## Commits

- End with `Assisted-by: harness:modelslug`; wrap bodies at 72 columns.
- Do not push unless asked.
