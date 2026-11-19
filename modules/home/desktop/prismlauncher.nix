{ pkgs, ... }: {
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override { jdks = [ pkgs.jdk25 ]; };
  };
}
