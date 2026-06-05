# dotfiles

Personal configuration files, primarily for macOS.

## What's in here

| Directory       | Tool                                          |
| --------------- | --------------------------------------------- |
| `nvim/`         | Neovim (Lua config, lazy.nvim)                |
| `fish/`         | Fish shell                                    |
| `zsh/`          | Zsh shell                                     |
| `tmux/`         | tmux                                          |
| `starship.toml` | Starship prompt                               |
| `kitty/`        | Kitty terminal + themes                       |
| `alacritty/`    | Alacritty terminal + themes                   |
| `ghostty/`      | Ghostty terminal                              |
| `aerospace/`    | AeroSpace tiling window manager               |
| `sketchybar/`   | SketchyBar status bar                         |
| `keyboard/`     | QMK keymaps (Corne, Voyager)                  |
| `agents/`       | AI agent skills, prompts, and config          |
| `claude/`       | Claude Code settings                          |
| `codex/`        | Codex config                                  |

## Install

The `install.sh` script symlinks the configs into place (`~/.config`, `$HOME`):

```sh
git clone --recurse-submodules <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` overwrites any existing symlinks at the target paths. Back up
real files there first if you want to keep them.

## Submodules

`agents/skill-repos/` contains git submodules. If you cloned without
`--recurse-submodules`, fetch them with:

```sh
git submodule update --init --recursive
```
