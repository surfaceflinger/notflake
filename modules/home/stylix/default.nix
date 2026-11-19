{ inputs, pkgs, ... }: {
  imports = [
    inputs.niri-flake.result.homeModules.stylix
    inputs.stylix.result.homeModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    overlays.enable = false;

    targets.mangohud.enable = false;
    targets.wpaperd.enable = false;

    polarity = "dark";

    base16Scheme = ./corduroy-dark.yaml;

    cursor = {
      name = "miku-cursor";
      package = pkgs.miku-cursor;
      size = 32;
    };

    fonts = {
      monospace = {
        name = "Cascadia Mono PL";
        package = pkgs.cascadia-code;
      };
      sansSerif = {
        name = "Atkinson Hyperlegible Next";
        package = pkgs.atkinson-hyperlegible-next;
      };
      serif = {
        name = "Lora";
        package = pkgs.lora;
      };
      sizes.applications = 11;
    };

    opacity.terminal = 0.9;
  };
}
