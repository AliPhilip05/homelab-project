# Portable Homelab — Remote Systems & Terminal Monitoring

**Status:** Work in progress · **Platforms:** macOS administration workstation, Debian ARM64 server, Kali Linux lab workstation

A sanitized, reproducible homelab configuration for private remote administration, Docker-based uptime monitoring, and persistent terminal dashboards. This repository is a reference deployment, **not an export of a live system**. Hostnames, users, IPs and credentials are placeholders.

## Architecture

```text
admin-workstation (macOS)
  |  SSH through Tailscale encrypted tailnet
  +-- edge-node (Debian ARM64)
  |     OpenSSH, Docker Engine/Compose, Uptime Kuma
  |     tmux, btop, node-status
  |     [Planned] Grafana, Prometheus, Node Exporter
  +-- lab-node (Kali Linux)
        OpenSSH, Tailscale, tmux, btop
        [Planned] i3 window manager and metrics exporter
```

## Status
**Verified in the working homelab:** private Tailscale connectivity between three devices; SSH access; Docker and Compose on ARM64; Uptime Kuma deployed and checking Linux devices (lab-node monitor green).

**In progress:** reusable terminal-monitoring configuration, metrics stack, alerting, secure backups and hardening.

## Tools and purpose

| Tool | Function |
| --- | --- |
| OpenSSH | Connect remotely to Linux shells |
| Tailscale | Private encrypted mesh VPN without router port forwarding |
| Docker Engine | Run isolated application containers |
| Docker Compose | Describe, start and inspect multi-container services |
| Uptime Kuma | Monitor device reachability and service uptime |
| tmux | Persist and split terminal sessions across SSH disconnects |
| btop | Interactive CPU, memory, disk, network and process monitoring |
| fastfetch | Display OS and hardware summary |
| watch | Refresh shell status output periodically |
| i3 (optional) | Tiling graphical window manager on the lab workstation |
| Grafana + Prometheus + Node Exporter (planned) | Time-series hardware performance dashboards |

## Install and configure

On each **Debian/Kali Linux host**:

```bash
sudo apt update                     # Refresh package metadata
sudo apt install -y openssh-server tmux btop fastfetch curl
sudo systemctl enable --now ssh     # Start SSH and enable it on boot
```

Install Tailscale following the [official Linux guide](https://tailscale.com/download/linux); authenticate each node to the same trusted tailnet. Use `tailscale status` to see connected peers and `tailscale ip -4` to find your device's tailnet address. On macOS install the official Tailscale application.

Merge `configs/ssh/config.example` into your **local** `~/.ssh/config` and replace all placeholders. Do not overwrite an existing SSH config or publish your real one.

```bash
chmod 700 ~/.ssh                    # Secure SSH directory
chmod 600 ~/.ssh/config             # Restrict configuration permissions
ssh edge-node                       # SSH into the ARM64 server
ssh lab-node                        # SSH into the Kali workstation
```

Check the Linux server's release and architecture first with `cat /etc/os-release` and `dpkg --print-architecture`. Install Docker Engine and its Compose plugin according to the [official Debian instructions](https://docs.docker.com/engine/install/debian/) for the detected release. Confirm installation:

```bash
sudo systemctl enable --now docker  # Start and enable Docker
sudo docker run --rm hello-world    # Test pulling and running a container
sudo docker compose version         # Check Compose plugin
```

Deploy Uptime Kuma **on the server** from the checked-out repository:

```bash
cd configs/docker/uptime-kuma
sudo docker compose config -q       # Check YAML validity
sudo docker compose up -d           # Start container in background
sudo docker compose ps              # Show container state
```

On the **admin workstation**, use this secure tunnel (keep it running):

```bash
ssh -N -L 3001:127.0.0.1:3001 edge-node
```

Visit `http://localhost:3001` and create an administrator account. For devices, configure TCP port 22 monitors using **your own** reachable tailnet addresses. Docker bridge connectivity can differ from host connectivity.

## Terminal observability

From a checkout of this repository on **each Linux node**, install the scripts:

```bash
sudo install -m 0755 scripts/node-status /usr/local/bin/node-status
sudo install -m 0755 scripts/start-monitor /usr/local/bin/start-monitor
node-status                          # One-shot CPU, memory, disk and services summary
watch -n 3 node-status               # Refresh status every three seconds
start-monitor                        # Start or reattach a tmux + btop dashboard
```

From the admin workstation:

```bash
ssh -t edge-node start-monitor
ssh -t lab-node start-monitor
```

In tmux, press `Ctrl+B` then `d` to detach, `%` for a vertical split, `"` for a horizontal split, or arrow keys to switch panes. SSH disconnections do not kill tmux sessions; reboots do.

## Optional metrics stack — not yet verified

`configs/docker/monitoring/` contains a **staged** Compose file for Grafana, Prometheus, and Node Exporter, not a claim of completed deployment. From that directory, `sudo docker compose config -q` checks the file. If you decide to deploy, review it and run `sudo docker compose up -d`. Access Grafana using `ssh -N -L 3000:127.0.0.1:3000 edge-node` and `http://localhost:3000`. Grafana can use `http://prometheus:9090` as the data-source URL within the Compose network.

## Command reference

| Command | Explanation |
| --- | --- |
| `ssh edge-node` | Open remote shell via SSH alias |
| `ssh -N -L 3001:127.0.0.1:3001 edge-node` | Securely forward local port 3001 to server loopback |
| `tailscale status` | Display tailnet peers |
| `tailscale ip -4` | Display the node's Tailscale IPv4 |
| `free -h` | Physical RAM and swap statistics |
| `df -h /` | Disk usage for root filesystem |
| `uptime` | Uptime and load averages |
| `btop` | Interactive CPU, RAM, disk, network and process metrics |
| `fastfetch` | OS/hardware summary |
| `sudo docker compose config -q` | Validate Compose configuration |
| `sudo docker compose up -d` | Create/update and start containers |
| `sudo docker compose ps` | Show application container status |
| `sudo docker logs --tail 50 uptime-kuma` | Read recent uptime monitor logs |
| `tmux ls` | List persistent terminal sessions |
| `tmux attach -t monitor` | Attach to monitoring session |
| `systemctl is-active tailscaled` | Check mesh VPN daemon state |

## Files

```text
README.md
.gitignore
LICENSE
configs/ssh/config.example
configs/tmux/tmux.conf
configs/docker/uptime-kuma/compose.yaml
configs/docker/monitoring/compose.yaml
configs/docker/monitoring/prometheus.yml
scripts/node-status
scripts/start-monitor
docs/ROADMAP.md
docs/SECURITY.md
```

## Security and project history

No actual host addresses, account names, private keys, VPN credentials or logs are included. Browser dashboards bind to localhost and are accessed through SSH. Docker access can be root-equivalent; this example deliberately uses `sudo docker`.

**Development is ongoing as of November 2026.** September 2026 is a proposed portfolio timeline, not verified by this repository's commit history; consult [ROADMAP.md](docs/ROADMAP.md) for truthful implementation status. Do not backdate commits.

MIT license. See [SECURITY.md](docs/SECURITY.md) for safe deployment practices.
