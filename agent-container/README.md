# Containerized coding agents

This setup runs Pi, Codex, and Claude Code in one Docker image. The container runs with the invoking user's UID/GID, drops all Linux capabilities, prevents privilege escalation, and does not receive the Docker socket or host API-key environment variables.

## Install

From this directory's parent (`~/.pi` in the current dotfiles setup):

```bash
mise run agents:install
mise run agents:build
```

The install task adds `container/tasks` to mise's global task configuration, so the agent commands work from any directory.

## Usage

```bash
mise run pi
mise run codex
mise run claude

# Arguments after -- are passed to the agent.
mise run pi -- -p "Summarize this repository"
mise run codex -- "Review the current changes"
mise run claude -- -p "Explain this function"
```

Normal Claude and Codex runs retain their built-in approval behavior. To rely only on the container boundary:

```bash
mise run claude:yolo
mise run codex:yolo
mise run pi:yolo
```

Pi does not have per-command approval prompts: its built-in tools are already unrestricted. `pi:yolo` additionally passes `--approve`, which trusts project-local Pi resources for that run.

## Help

List all available tasks and their short descriptions, or show the sandbox help:

```bash
mise tasks
mise run agents:help
```

Pass `--help` to an underlying agent or the update task for command-specific options:

```bash
mise run pi -- --help
mise run codex -- --help
mise run claude -- --help
mise run agents:update -- --help
```

Run `mise run agents:health` to check mise, Docker, and the image. Run `mise run agents:test` to test mount and update logic without starting a container.

## Filesystem access

Every agent receives read/write access to these host paths:

- `~/Code`
- `~/dev`
- `~/.claude`
- `~/.codex`
- `~/.pi`
- `~/bin`
- `~/scripts`
- `~/shared`

When started inside a Git working tree, the repository root is available and the original launch directory remains the working directory. For a linked worktree, its external common Git metadata is mounted too. Outside Git, the launch directory is mounted. A separate project mount is omitted when an existing shared mount already covers it.

Missing paths from the list are created by the launcher. Files written through bind mounts are owned by the invoking host user because the container runs as `$(id -u):$(id -g)`.

The host's `~/.gitconfig`, SSH keys/agent, Docker socket, and API-key environment variables are not mounted or forwarded. Git is installed and HTTPS remotes work, but commits do not inherit host identity automatically. Configure identity in a repository when needed:

```bash
git config user.name "Your Name"
git config user.email "you@example.com"
```

## Security boundary

The container limits filesystem damage to the mounted paths, but all listed paths are writable. An agent can delete or corrupt every repository under `~/Code` and `~/dev`, and can read or modify credentials and settings in its three configuration directories.

The agents require network access for model APIs. Consequently, a compromised or prompt-injected agent can exfiltrate any mounted data, including credentials stored in `~/.claude`, `~/.codex`, or `~/.pi`. Containers also reduce rather than eliminate the possibility of runtime/kernel escape. Do not treat this setup as a security guarantee.

To limit resource exhaustion, runs default to 8 GiB memory, 4 CPUs, and 1024 processes. Adjust these host-side controls when a project needs different limits:

```bash
AGENT_SANDBOX_MEMORY=12g AGENT_SANDBOX_CPUS=6 AGENT_SANDBOX_PIDS_LIMIT=2048 mise run codex
```

## Maintenance

Agent versions are pinned near the top of `container/Dockerfile`. Update all three to their current npm releases and rebuild the image with:

```bash
mise run agents:update
```

Update only selected agents by passing their names:

```bash
mise run agents:update -- pi
mise run agents:update -- claude codex
```

The task resolves each package's current npm `latest` version, updates the pin, and rebuilds the image. To rebuild without changing versions:

```bash
mise run agents:build
```

Optional launcher controls (used by the host only, not forwarded into the container):

```bash
AGENT_CONTAINER_RUNTIME=podman mise run pi
AGENT_SANDBOX_IMAGE=my-agents:latest mise run agents:build
```
