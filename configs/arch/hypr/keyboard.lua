-- Additional keyboard controls; existing bindings are preserved.
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus --new-window"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("kitty --title Network -e nmtui"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("pavucontrol"))
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("kitty --title Bluetooth -e bluetoothctl"))
hl.bind("SUPER + F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("SUPER + minus", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("SUPER + BackSpace", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
for _, entry in ipairs({ {"Left", "left", -30, 0}, {"Right", "right", 30, 0}, {"Up", "up", 0, -30}, {"Down", "down", 0, 30} }) do
    hl.bind("SUPER + " .. entry[1], hl.dsp.focus({ direction = entry[2] }))
    hl.bind("SUPER + SHIFT + " .. entry[1], hl.dsp.window.move({ direction = entry[2] }), { repeating = true })
    hl.bind("SUPER + CTRL + " .. entry[1], hl.dsp.window.resize({ x = entry[3], y = entry[4], relative = true }), { repeating = true })
end
