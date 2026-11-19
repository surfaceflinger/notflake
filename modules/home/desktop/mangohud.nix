{ config, ... }:
let
  c = config.lib.stylix.colors;
in
{
  programs.mangohud.enable = true;

  # plain text: the nix settings module sorts keys, and the trailing exec
  # lines cannot be expressed twice as attributes
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    toggle_fps_limit=F1
    toggle_hud=Shift_R+F12

    no_display
    legacy_layout=false
    position=top-left
    offset_x=12
    offset_y=12
    round_corners=12
    background_color=${c.base00}
    background_alpha=0.75
    text_color=${c.base05}
    text_outline
    text_outline_color=${c.base00}
    text_outline_thickness=1.5
    font_size=24

    gpu_stats
    gpu_temp
    gpu_junction_temp
    gpu_mem_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_voltage
    gpu_power
    gpu_power_limit
    gpu_fan
    gpu_efficiency
    gpu_load_change
    gpu_load_value=50,90
    gpu_load_color=${c.base0B},${c.base0A},${c.base08}
    gpu_text=GPU
    gpu_color=${c.base0B}

    cpu_stats
    cpu_temp
    cpu_power
    cpu_mhz
    cpu_efficiency
    core_load
    core_load_change
    cpu_load_change
    cpu_load_value=50,90
    cpu_load_color=${c.base0B},${c.base0A},${c.base08}
    cpu_text=CPU
    cpu_color=${c.base0D}

    vram
    vram_color=${c.base0E}
    ram
    ram_color=${c.base0F}
    swap
    procmem
    procmem_shared
    procmem_virt
    proc_vram

    fps
    fps_color_change
    fps_value=30,60
    fps_color=${c.base08},${c.base0A},${c.base0B}
    frametime
    frame_timing=1
    throttling_status
    throttling_status_graph
    frametime_color=${c.base0B}
    show_fps_limit

    wine
    winesync
    wine_color=${c.base08}
    present_mode

    battery
    battery_icon
    battery_watt
    battery_time
    battery_color=${c.base0A}

    exec=echo
    exec=echo
  '';
}
