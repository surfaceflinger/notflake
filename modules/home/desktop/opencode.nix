{ lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    # Core settings
    settings = {
      model = "nano-gpt/moonshotai/kimi-k2.5:thinking";
      small_model = "nano-gpt/moonshotai/kimi-k2.5";
      autoupdate = false;
      theme = "system";
    };

    # Rules
    rules = ''
      - When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.
      - When writing scripts, use nix shell shebangs.
      - You can access any tool that's missing in $PATH by using nix commands, eg. nix run.
      - On $PATH you already have node, python3 and jq for processing stuff.
      - Try to use grep, head, tail etc. when appropriate when running commands to save tokens on file, log reads etc.
    '';

    # Skills
    skills = { };

    # AI Provider Configuration
    settings.provider.nano-gpt = {
      name = "NanoGPT";
      npm = "@ai-sdk/openai-compatible";
      options.baseURL = "https://nano-gpt.com/api/v1";
      models = {
        "moonshotai/kimi-k2.5" = {
          name = "Kimi K2.5";
          limit = {
            context = 256000;
            output = 65535;
          };
        };
        "moonshotai/kimi-k2.5:thinking" = {
          name = "Kimi K2.5 Thinking";
          limit = {
            context = 256000;
            output = 65535;
          };
        };
      };
    };

    # Formatters
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

    # File Watcher
    settings.watcher.ignore = [
      ".git/**"
      "node_modules/**"
      "result/**"
      ".terraform/**"
    ];

    # Permission Settings
    settings.permission = {
      "*" = "ask";
      codesearch = "allow";
      doom_loop = "ask";
      edit = "allow";
      external_directory = "ask";
      glob = "allow";
      grep = "allow";
      list = "allow";
      lsp = "allow";
      read = "allow";
      skill = "allow";
      task = "allow";
      todoread = "allow";
      todowrite = "allow";
      webfetch = "allow";
      websearch = "allow";
      bash = {
        "*" = "ask";
        # Git commands
        "git status*" = "allow";
        "git log*" = "allow";
        "git diff*" = "allow";
        "git show*" = "allow";
        "git branch*" = "allow";
        "git remote*" = "allow";
        "git config*" = "allow";
        "git rev-parse*" = "allow";
        "git ls-files*" = "allow";
        "git ls-remote*" = "allow";
        "git describe*" = "allow";
        "git tag --list*" = "allow";
        "git blame*" = "allow";
        "git shortlog*" = "allow";
        "git reflog*" = "allow";
        "git add*" = "allow";
        # Nix commands
        "nix search*" = "allow";
        "nix eval*" = "allow";
        "nix show-config*" = "allow";
        "nix flake show*" = "allow";
        "nix flake check*" = "allow";
        "nix log*" = "allow";
        # File system operations
        "ls*" = "allow";
        "pwd*" = "allow";
        "find*" = "allow";
        "grep*" = "allow";
        "rg*" = "allow";
        "cat*" = "allow";
        "head*" = "allow";
        "tail*" = "allow";
        "mkdir*" = "allow";
        "chmod*" = "allow";
      };
    };

    # Plugins
    settings.plugin = [
      "opencode-pty"
      "@tarquinen/opencode-dcp@latest"
    ];

    # LSP Configuration
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

  # MCP Configuration
  programs.mcp = {
    enable = true;
    servers = {
      gh_grep.url = "https://mcp.grep.app";
      context7.url = "https://mcp.context7.com/mcp";
    };
  };
}
