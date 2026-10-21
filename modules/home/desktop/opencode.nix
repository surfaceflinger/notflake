# slopped config. idc.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # V2 permissions are ordered; the last matching rule wins, so broad allows
  # come first and narrow asks/denies last.
  allow = action: resource: {
    inherit action resource;
    effect = "allow";
  };
  ask = action: resource: {
    inherit action resource;
    effect = "ask";
  };
  deny = action: resource: {
    inherit action resource;
    effect = "deny";
  };

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

    settings = {
      model = "opencode-go/deepseek-v4.1-flash";
      update = "disable";
      share = "disabled";
      agents.title.model = "opencode-go/deepseek-v4.1-flash";
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
    settings.permissions = [
      (ask "*" "*")
      (allow "external_directory" "/nix/store/*")
      (allow "external_directory" "/tmp/opencode/*")

      # jew-guard skips read-only tools, so allow them here or every read prompts
      (allow "read" "*")
      (deny "read" "*.env")
      (deny "read" "*.env.*")
      (allow "read" "*.env.example")
      (allow "glob" "*")
      (allow "grep" "*")
      (allow "skill" "*")
      (allow "subagent" "*")
      (allow "question" "*")
      (allow "jew_workspace" "*")
      (allow "jew_model" "*")
      (allow "jew_yolo" "*")

      # jew-guard judges edits, so its "allow" can skip the prompt
      (allow "edit" "*")
      (ask "edit" "*.env")
      (ask "edit" "*.env.*")
      (ask "edit" "*.git/*")

      # kagi replaces built-in search
      (deny "websearch" "*")

      # MCP calls are judged by jew-guard; summarize fetches URLs
      (allow "context7_*" "*")
      (allow "gh_grep_*" "*")
      (allow "github_*" "*")
      (allow "opentofu_*" "*")
      (allow "chrome-devtools_*" "*")
      (allow "kagi_*" "*")
      (ask "kagi_kagi_summarize" "*")

      # jew-guard judges webfetch; unknown hosts stay ask even when Jev allows
      (ask "webfetch" "*")
      (allow "webfetch" "https://github.com/*")
      (allow "webfetch" "https://raw.githubusercontent.com/*")
      (allow "webfetch" "https://nixos.org/*")
      (allow "webfetch" "https://search.nixos.org/*")
      (allow "webfetch" "https://wiki.nixos.org/*")
      (allow "webfetch" "https://nix.dev/*")
      (allow "webfetch" "https://nix-community.github.io/*")
      (allow "webfetch" "https://opencode.ai/*")
    ];

    settings.plugins = [
      "@dietrichgebert/ponytail@5.1.0"
      "jew-guard@0.10.0"
      # V2 lives behind a subpath export, which cannot carry an @version pin.
      "opencode-pty/v2"
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
          (lib.getExe pkgs.tofu-ls)
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

    settings.mcp.servers = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
      };
      gh_grep = {
        type = "remote";
        url = "https://mcp.grep.app";
      };
      github = {
        type = "local";
        command = [ githubMcp ];
      };
      opentofu = {
        type = "remote";
        url = "https://mcp.opentofu.org/mcp";
      };
      chrome-devtools = {
        type = "local";
        command = [
          "npx"
          "-y"
          "chrome-devtools-mcp@1.11.0"
          "--no-usage-statistics"
          "--no-performance-crux"
          "--browserUrl=http://127.0.0.1:9222"
        ];
      };
      kagi = {
        type = "local";
        command = [
          (lib.getExe inputs.kagi-cli.result.packages."${pkgs.stdenv.hostPlatform.system}".default)
          "mcp"
          "--default-output"
          "toon"
          "--tools"
          "kagi_search,kagi_batch_search,kagi_summarize"
        ];
      };
    };
  };

  xdg.configFile."opencode/cli.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/v2/cli.json";
    theme = {
      name = "system";
      mode = "system";
    };
    attention = {
      notifications = true;
      sound = false;
    };
  };
}
