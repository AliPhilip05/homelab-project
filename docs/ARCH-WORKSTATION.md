# Personal Arch workstation

The personal workstation runs Arch Linux with Hyprland's Lua configuration.
These modules capture its workspace and portable keyboard settings as inspected
in November 2026. They are configuration excerpts, not a complete desktop backup.

## Install

These files use the Lua `hl` API; they are not legacy hyprland.conf syntax.
Keep your existing monitor, theme, launcher and startup configuration.

Back up any existing keyboard.lua and workspaces.lua before copying:

```bash
mkdir -p ~/.config/hypr
cp configs/arch/hypr/keyboard.lua ~/.config/hypr/keyboard.lua
cp configs/arch/hypr/workspaces.lua ~/.config/hypr/workspaces.lua
```

In ~/.config/hypr/hyprland.lua, load each module once:

```lua
require("workspaces")
require("keyboard")
```

Replace an existing numbered-workspace binding loop with the workspaces module
rather than registering the shortcuts twice. The inspected workstation already
has that loop and loads keyboard.lua; it needs no change to enable these shortcuts.

Keyboard commands require Kitty, Nautilus, NetworkManager's nmtui, pavucontrol,
bluetoothctl and wpctl. Install the applications you want before using their
shortcuts. Base packages on Arch include kitty, nautilus, networkmanager,
pavucontrol, bluez-utils and wireplumber; service and audio setup remain
host-specific.

The workstation's custom application menu, session menu and Desktop guide
shortcuts depend on local scripts. They are intentionally omitted from this
portable module because those assets are not included here.

## Desktop shortcuts

Super is usually the Windows-logo key.

| Keys | Action |
| --- | --- |
| Super + 1–9 | Switch to workspace 1–9 |
| Super + 0 | Switch to workspace 10 |
| Super + Shift + 1–9 | Move the focused window to workspace 1–9 |
| Super + Shift + 0 | Move the focused window to workspace 10 |
| Super + Return | Open Kitty |
| Super + E | Open Nautilus |
| Super + arrows | Focus a window |
| Super + Shift + arrows | Move a window in that direction |
| Super + Ctrl + arrows | Resize by 30 pixels |
| Super + F11 | Toggle fullscreen |
| Super + N | Open nmtui |
| Super + A | Open audio controls |
| Super + Ctrl + B | Open bluetoothctl |
| Super + equal / minus | Raise / lower volume |
| Super + Backspace | Toggle speaker mute |

To move an individual browser tab, detach it into a window first, then focus
that window and use Super + Shift + number.

## Validation

Run `luac -p` separately on each module to check Lua syntax. After applying
them to a compatible Hyprland session, reload with `hyprctl reload` and inspect
`hyprctl configerrors`. Manually verify workspace switching and window movement;
syntax checks alone do not establish that a desktop session loaded the bindings.
