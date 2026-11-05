# Security notes

This public project contains generalized placeholders, not live infrastructure exports. Never commit real machine addresses, names, passwords, VPN keys, private SSH keys, authentication links, wireless SSIDs, screenshots showing secrets, logs, or data volumes.

## Controls
- Grant tailnet access only to trusted users and devices.
- Bind monitoring user interfaces to 127.0.0.1 and connect through SSH tunnels.
- Verify SSH host fingerprints using trusted out-of-band information.
- Keep operating systems, VPN software and container images updated.
- Docker group membership grants root-equivalent power; use cautiously.
- Back up and test restoration of stateful Docker volumes.
- Review host PID/filesystem access for monitoring exporters.
- Never expose Docker management sockets publicly.

## Review
Use `git diff --cached` and review all files before pushing. Search for host details, tokens and accidental credentials.
