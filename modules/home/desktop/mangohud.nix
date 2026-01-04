_: {
  programs.mangohud.enable = true;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    toggle_fps_limit=F1

    no_display
    legacy_layout=false
    gpu_stats
    gpu_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power
    gpu_load_change
    gpu_load_value=50,90
    gpu_load_color=FFFFFF,FF7800,CC0000
    gpu_text=GPU
    cpu_stats
    cpu_temp
    core_load
    cpu_power
    cpu_mhz
    cpu_load_change
    core_load_change
    cpu_load_value=50,90
    cpu_load_color=FFFFFF,FF7800,CC0000
    cpu_color=2e97cb
    cpu_text=CPU
    io_color=a491d3
    vram
    vram_color=ad64c1
    ram
    ram_color=c26693
    procmem
    procmem_shared
    procmem_virt
    fps
    engine_color=eb5b5b
    gpu_color=2e9762
    winesync
    wine
    wine_color=eb5b5b
    frame_timing=1
    frametime_color=00ff00
    show_fps_limit
    gamemode
    battery
    exec=echo #add a line for text space
    exec=echo #add a line for text space
    media_player_color=ffffff
    background_alpha=0.4
    font_size=24

    background_color=020202
    position=top-left
    text_color=ffffff
    round_corners=8
    toggle_hud=Shift_R+F12
  '';
}
