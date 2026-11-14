_: {
  programs.mangohud.enable = true;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    toggle_fps_limit=F1
    toggle_hud=Shift_R+F12

    no_display
    legacy_layout=false
    position=top-left
    offset_x=12
    offset_y=12
    round_corners=12
    background_color=14111C
    background_alpha=0.75
    text_color=F7F3FF
    text_outline
    text_outline_color=0B0910
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
    gpu_load_color=A8F0C6,FFD166,FFA8A8
    gpu_text=GPU
    gpu_color=8BE9C0

    cpu_stats
    cpu_temp
    cpu_power
    cpu_mhz
    cpu_efficiency
    core_load
    core_load_change
    cpu_load_change
    cpu_load_value=50,90
    cpu_load_color=A8F0C6,FFD166,FFA8A8
    cpu_text=CPU
    cpu_color=8CC8FF

    vram
    vram_color=D2B2FF
    ram
    ram_color=FFA3C9
    swap
    procmem
    procmem_shared
    procmem_virt
    proc_vram

    fps
    fps_color_change
    fps_value=30,60
    fps_color=FFA8A8,FFD166,8CE99A
    frametime
    frame_timing=1
    throttling_status
    throttling_status_graph
    frametime_color=9DFFB0
    show_fps_limit

    wine
    winesync
    wine_color=FFA8B7
    present_mode

    battery
    battery_icon
    battery_watt
    battery_time
    battery_color=FFD98A

    exec=echo
    exec=echo
  '';
}
