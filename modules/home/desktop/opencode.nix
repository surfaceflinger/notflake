# slopped config. idc.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # hm dumps this via builtins.tojson (keys sorted) and last matching rule wins,
  # so an override must sort *after* the rule it overrides.
  # "*" always sorts first (good), and `cmd *` < `cmd *-flag*` < `cmd *.env*`.

  allow = cmds: lib.genAttrs cmds (_: "allow");

  # `cmd` and `cmd *` instead of `cmd*`, which would also match lsblk, filefrag, ...
  allowWithArgs =
    cmds:
    allow (
      lib.concatMap (c: [
        c
        "${c} *"
      ]) cmds
    );

  roCmds = [
    "df"
    "du"
    "file"
    "find"
    "grep"
    "head"
    "jq"
    "ls"
    "pwd"
    "rg"
    "stat"
    "tail"
    "tree"
    "type"
    "wc"
    "which"
  ];

  gitRo = [
    "git blame"
    "git branch --list"
    "git branch -a"
    "git branch -v"
    "git config --get"
    "git config --list"
    "git describe"
    "git diff"
    "git log"
    "git ls-files"
    "git ls-remote"
    "git rev-parse"
    "git remote -v"
    "git remote get-url"
    "git remote show"
    "git reflog show"
    "git shortlog"
    "git show"
    "git stash list"
    "git status"
    "git tag --list"
    "git tag -l"
  ];

  nixRo = [
    "nix config show"
    "nix derivation show"
    "nix eval"
    "nix flake check"
    "nix flake metadata"
    "nix flake show"
    "nix log"
    "nix path-info"
    "nix search"
    "nix store diff-closures"
    "nix why-depends"
  ];

  githubMcp = pkgs.writeShellScript "github-mcp-wrapper" ''
    set -euo pipefail
    token="$(${lib.getExe pkgs.gh} auth token)"
    export GITHUB_PERSONAL_ACCESS_TOKEN="$token"
    exec ${lib.getExe pkgs.github-mcp-server} \
      --read-only \
      --toolsets ${lib.concatStringsSep "," githubToolsets} \
      stdio
  '';

  githubToolsets = [
    "context" # who am I / which repo
    "repos" # files, commits, branches, releases, search
    "git" # trees, blobs, refs
    "issues"
    "pull_requests" # incl. diffs, review comments, status checks
    "discussions"
    "actions" # workflow runs + job logs: "why is CI red?"
    "labels"
  ];
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    settings = {
      model = "opencode-go/muse-spark-1.3";
      small_model = "opencode-go/muse-spark-1.3";
      autoupdate = false;
      share = "disabled";
    };

    tui = {
      theme = "system";
      attention = {
        enabled = true;
        sound = false;
      };
    };

    context = ''
      - When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.
      - When writing scripts, use nix shell shebangs.
      - You can access any tool that's missing in $PATH by using nix commands, eg. nix run.
      - On $PATH you already have node, python3 and jq for processing stuff.
      - Try to use grep, head, tail etc. when appropriate when running commands to save tokens on file, log reads etc.
      - For web search use the kagi_kagi_search tool. For library docs use context7, for real-world code examples use gh_grep.
      - If you want to use github and github_* tools aren't enough, you can use gh cli, available on $PATH and already authenticated.
      - If you want to do stuff in an external directory, eg. to untar something, you have always-allow access to /tmp/opencode/*
      - When commiting, commit message should on the bottom contain: "Assisted-by: harness:modelslug", eg. "Assisted-by: OpenCode:claude-opus-5-5"
      - Prioritize simplicity and maintainability over complexity
      - Follow best practices without over-engineering
      - Avoid comments, write self-explanatory code with clear naming
      - Add comments in English only when they provide non-obvious value
      - Challenge proposals when you have a better alternative
      - Keep responses concise and actionable
      - Avoid sloppy AI prose (as if this was going to help lmao)
    '';

    # formatters
    settings.formatter.nixfmt = {
      command = [
        (lib.getExe pkgs.nixfmt)
        "$FILE"
      ];
      extensions = [ ".nix" ];
    };
    settings.formatter.opentofu = {
      command = [
        (lib.getExe' pkgs.opentofu "tofu")
        "fmt"
        "$FILE"
      ];
      extensions = [
        ".tf"
        ".tfvars"
        ".tofu"
      ];
    };

    settings.watcher.ignore = [
      ".git/**"
      "node_modules/**"
      "result/**"
      ".terraform/**"
    ];

    # permissions
    settings.permission = {
      "*" = "ask";

      # kagi mcp replaces built-in search; gh_grep + context7 cover codesearch.
      # deny also hides the tool from the model (saves tokens).
      websearch = "deny";
      codesearch = "deny";

      # webfetch matches the url; only known doc hosts auto-allow,
      # rest prompts, so no read-secret-then-fetch-evil.com exfil
      #webfetch = {
      #  "*" = "ask";
      #  "https://github.com/*" = "allow";
      #  "https://raw.githubusercontent.com/*" = "allow";
      #  "https://nixos.org/*" = "allow";
      #  "https://search.nixos.org/*" = "allow";
      #  "https://wiki.nixos.org/*" = "allow";
      #  "https://nix.dev/*" = "allow";
      #  "https://nix-community.github.io/*" = "allow";
      #  "https://opencode.ai/*" = "allow";
      #};

      # explicit read=allow would override stock .env denies, so restate them.
      read = {
        "*" = "allow";
        "*.env" = "deny";
        "*.env.*" = "deny";
        "*.env.example" = "allow";
      };

      edit = {
        "*" = "allow";
        "*.env" = "ask";
        "*.env.*" = "ask";
        "*.git/*" = "ask";
      };

      external_directory = {
        "/nix/store/*" = "allow";
        "/tmp/opencode/*" = "allow";
      };

      glob = "allow";
      grep = "allow";
      list = "allow";
      lsp = "allow";
      skill = "allow";
      # subagents are still bound by these same rules
      task = "allow";
      todoread = "allow";
      todowrite = "allow";

      # mcp tools are named <server>_<tool>, so "*"=ask prompted on every call.
      "context7_*" = "allow";
      "gh_grep_*" = "allow";
      "github_*" = "allow";
      "kagi_*" = "allow";
      # these make kagi fetch any url, same exfil channel as webfetch
      "kagi_kagi_extract" = "ask";
      "kagi_kagi_summarize" = "ask";

      bash = {
        "git add *" = "allow"; # local staging only; flakes can't see untracked files
        "git add" = "allow";
        "git remote" = "allow";
        "git reflog" = "allow";
        "mkdir *" = "allow";
        "nix build *--dry-run*" = "allow";

        # these can still exec/write via flags
        "find *-delete*" = "ask";
        "find *-exec*" = "ask";
        "find *-fprint*" = "ask";
        "find *-ok*" = "ask";
        "git diff *--output*" = "ask";
        "rg *--pre*" = "ask";
      }
      // allowWithArgs roCmds
      // allowWithArgs gitRo
      // allowWithArgs nixRo
      // lib.genAttrs (map (c: "${c} *.env*") roCmds) (_: "ask");
    };

    settings.plugin = [
      "@dietrichgebert/ponytail@5.1.0"
      "jew-guard@0.9.1"
      "opencode-pty@0.4.0"
    ];

    settings.lsp = {
      nixd = {
        command = [ (lib.getExe pkgs.nixd) ];
        extensions = [ ".nix" ];
        initialization.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
      };
      pyright = {
        command = [ (lib.getExe pkgs.pyright) ];
        extensions = [
          ".py"
          ".pyi"
        ];
      };
      bash = {
        command = [
          (lib.getExe pkgs.bash-language-server)
          "start"
        ];
        extensions = [
          ".bash"
          ".ksh"
          ".sh"
          ".zsh"
        ];
      };
      clangd = {
        command = [ (lib.getExe' pkgs.clang-tools "clangd") ];
        extensions = [
          ".c"
          ".cpp"
          ".cc"
          ".cxx"
          ".c++"
          ".h"
          ".hpp"
          ".hh"
          ".hxx"
          ".h++"
        ];
      };
      rust = {
        command = [ (lib.getExe pkgs.rust-analyzer) ];
        extensions = [ ".rs" ];
      };
      terraform = {
        command = [
          (lib.getExe pkgs.terraform-ls)
          "serve"
        ];
        extensions = [
          ".tf"
          ".tfvars"
        ];
      };
      yaml-ls = {
        command = [
          (lib.getExe pkgs.yaml-language-server)
          "--stdio"
        ];
        extensions = [
          ".yaml"
          ".yml"
        ];
      };
      json-ls = {
        command = [
          (lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server")
          "--stdio"
        ];
        extensions = [
          ".json"
          ".jsonc"
        ];
      };
    };
  };

  # mcp
  programs.mcp = {
    enable = true;
    servers = {
      context7.url = "https://mcp.context7.com/mcp";
      gh_grep.url = "https://mcp.grep.app";
      github.command = "${githubMcp}";
      opentofu.url = "https://mcp.opentofu.org/mcp";
      chrome-devtools = {
        command = "npx";
        args = [
          "-y"
          "chrome-devtools-mcp@1.10.1"
          "--no-usage-statistics"
          "--no-performance-crux"
          "--browserUrl=http://127.0.0.1:9222"
        ];
      };
      kagi = {
        command = lib.getExe inputs.kagi-cli.result.packages."${pkgs.stdenv.hostPlatform.system}".default;
        args = [
          "mcp"
          "--default-output"
          "toon"
          "--tools"
          "kagi_search,kagi_batch_search,kagi_summarize"
        ];
      };
    };
  };
}
