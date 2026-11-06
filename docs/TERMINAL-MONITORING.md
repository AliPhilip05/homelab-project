# Terminal monitoring — verified working workflows

Two independent, persistent tmux dashboards: server and Kali workstation. Host addresses, user names, VPN IPs, and passwords are not included.

## Server (Debian ARM64)

Install tools:
```bash
sudo apt update
sudo apt install -y tmux btop fastfetch lm-sensors
mkdir -p ~/.local/bin
install -m 0755 scripts/pi-status scripts/docker-status scripts/pi-monitor ~/.local/bin/
bash -n ~/.local/bin/pi-monitor
~/.local/bin/pi-monitor
```
`pi-status`: temperature, uptime, memory/swap, root disk, SSH/Docker/Tailscale activity. `docker-status`: list running containers without placing secrets in command output; access may need authorized sudo. `pi-monitor`: create or reconnect to a 3-pane persistent tmux session with btop and refreshed status panes.

## Kali Linux

```bash
sudo apt update
sudo apt install -y kali-desktop-i3 kitty tmux btop lm-sensors
mkdir -p ~/.local/bin
install -m 0755 scripts/kali-monitor ~/.local/bin/
bash -n ~/.local/bin/kali-monitor
~/.local/bin/kali-monitor
```
Add the example shortcut from `configs/i3/monitoring.conf.example` to the *existing* i3 config. Validate with `i3 -C -c ~/.config/i3/config`, reload using `i3-msg reload`, then try Ctrl+Shift+M. No custom window title is used, following a verified compatibility issue.

## Access from macOS

Add generic host aliases (example: `edge-node`) to `~/.ssh/config` and ensure keys/Tailscale work. From the Mac's `~/.zshrc`:

```bash
alias pi-monitor='ssh -t edge-node "bash ~/.local/bin/pi-monitor"'
```

Keep the remote command **quoted** so the remote Linux shell, not macOS, expands `~`.

```bash
source ~/.zshrc
pi-monitor
```

Press `Ctrl+B`, release, then `d` to detach; the tmux dashboard continues after SSH disconnects, but not after host reboot. For persistent usage, avoid launching nested tmux sessions. `tmux ls` lists sessions, and `tmux attach -t pi-monitor` reconnects.

## Known limitations
- Scripts are sanitized copies adapted from locally validated workflows, not byte-for-byte backups of private machine files.
- Docker status may need authorization; don't grant blanket root or Docker group access solely for a dashboard.
- Portability depends on tmux, btop, watch and available hardware sensors.
- Monitor sessions are not boot-persistent yet; automatic restart is a future milestone.
