{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    settings = {
      am.threeWay = true;
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      help.autoCorrect = "prompt";
      http.postBuffer = 524288000;
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      pull.rebase = true;
      tag.sort = "version:refname";
      core = {
        editor = with pkgs; (lib.getExe nano);
        whitespace = "trailing-space,space-before-tab,tab-in-indent";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
    };
  };
}
