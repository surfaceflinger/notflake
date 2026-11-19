# slopped config. idc.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # v2 permissions are ordered; the last matching rule wins, so broad allows
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
in
{
  programs.opencode = {
    enable = true;

    package =
      inputs.llm-agents.result.packages."${pkgs.stdenv.hostPlatform.system}".opencode2.overrideAttrs
        (old: {
          postInstall = (old.postInstall or "") + ''
            ln -s opencode2 $out/bin/opencode
          '';
        });

    cli = {
      theme = {
        name = "system";
        mode = "system";
      };
      attention = {
        notifications = true;
        sound = false;
      };
    };

    settings = {
      model = "opencode-go/deepseek-v4.1-flash";
      update = "disable";
      share = "disabled";
      agents.title.model = "opencode-go/deepseek-v4.1-flash";
    };

    context = ''
      - When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.
      - Always use opencode's read, write, and edit tools for file access; only use python or shell when no tool fits. Opencode edits go through the formatter; shell edits bypass it.
      - When writing scripts, use nix shell shebangs.
      - You can access any tool that's missing in $PATH by using nix commands, eg. nix run.
      - You can locate any binary with `nix-locate bin/<name>`, e.g. `nix-locate bin/vi`.
      - On $PATH you already have node, python3 and jq for processing stuff.
      - Try to use grep, head, tail etc. when appropriate when running commands to save tokens on file, log reads etc.
      - For web search use the kagi_kagi_search tool. For library docs use context7.
      - If you want to use github and github_* tools aren't enough, you can use gh cli, available on $PATH and already authenticated.
      - If you want to do stuff in an external directory, eg. to untar something, you have always-allow access to /tmp/opencode/*
      - When commiting, commit message should on the bottom contain: "Assisted-by: harness:modelslug", eg. "Assisted-by: OpenCode:claude-opus-5-5"
      - Wrap git commit message bodies at 72 columns
      - Prioritize simplicity and maintainability over complexity
      - Follow best practices without over-engineering
      - Avoid comments, write self-explanatory code with clear naming
      - Add comments in English only when they provide non-obvious value
      - If an explanation needs more than one line, put it in the commit message, not a comment; git blame finds it there
      - Never write changelog comments; eg. when an option or a NixOS module schema changes, do not add "this changed in nixpkgs". The code shows the current state; put the why in the commit message
      - Avoid em-dashes
      - Challenge proposals when you have a better alternative
      - Never push to a remote automatically; only push when explicitly asked
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
    settings.formatter.ruff = {
      command = [
        (lib.getExe pkgs.ruff)
        "format"
        "$FILE"
      ];
      extensions = [
        ".py"
        ".pyi"
      ];
    };
    settings.formatter.prettier = {
      command = [
        (lib.getExe pkgs.prettier)
        "--write"
        "$FILE"
      ];
      extensions = [
        ".js"
        ".jsx"
        ".ts"
        ".tsx"
        ".mjs"
        ".cjs"
        ".mts"
        ".cts"
        ".json"
        ".jsonc"
        ".css"
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

      # mcp actions are <server>_<tool>; invalid chars become _, hyphens stay.
      # opencode_* is a plugin namespace, not MCP, so it stays ask.
      (allow "context7_*" "*")
      (allow "github_*" "*")
      (allow "opentofu_*" "*")
      (allow "chrome-devtools_*" "*")
      (allow "kagi_*" "*")
      (allow "probook_*" "*")

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
      (deny "shell" "git push*")
    ];

    settings.plugins = [
      "@dietrichgebert/ponytail@5.3.3"
      "jew-guard@0.12.0"
    ];

    settings.mcp.servers = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
      };
      github = {
        type = "local";
        command = [ (lib.getExe' pkgs.github-mcp-wrapper "github-mcp-wrapper") ];
      };
      opentofu = {
        type = "remote";
        url = "https://mcp.opentofu.org/mcp";
      };
      probook = {
        type = "remote";
        url = "http://probook:45818/mcp";
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
          "kagi_search,kagi_batch_search"
        ];
      };
    };
  };

  xdg.configFile."jew-guard/config.json".text = builtins.toJSON {
    endpoint = "openrouter";
    url = "https://openrouter.ai/api/alpha/decisions";
    keyProvider = "openrouter";
    model = "~perplexity/pplx-decider-latest";
  };
}
