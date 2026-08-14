# quiet

A dark, low-saturation, high-contrast theme spanning Ghostty, Neovim, tmux,
starship and the command line tools.

## The rule

> Use colour according to how much something deserves attention, not merely
> because it belongs to a different syntax category.

Unfocus your eyes on a source file and it should read as monochrome. Roughly
70% Jonathan Blow, 30% Casey Muratori: enough semantic landmarks to find
functions, types and control flow at a glance, but no rainbow rendering of the
AST.

Readability comes from **luminance contrast**, not saturation. Normal
foreground sits at 11:1 against the background; no accent drops below 4.8:1.
Nothing is washed out to feel calm.

## Palette

| role              | hex       | contrast vs bg |
| ----------------- | --------- | -------------- |
| background        | `#101311` | —              |
| normal foreground | `#c5c9c5` | 11.2:1         |
| important text    | `#e1e3df` | 14.5:1         |
| strings           | `#bcc4b8` | 10.4:1         |
| secondary text    | `#9aa39c` | 7.2:1          |
| comments          | `#707a73` | 4.2:1          |
| line numbers      | `#59635b` | 3.0:1          |
| inactive UI       | `#424944` | 2.0:1          |
| orange (function) | `#c47b5a` | 5.6:1          |
| ochre (type)      | `#c2ad72` | 8.5:1          |
| sand (keyword)    | `#bcae86` | 8.5:1          |
| teal (control)    | `#69a6a0` | 6.7:1          |
| green             | `#718b78` | 5.0:1          |
| red               | `#b76d68` | 4.8:1          |

The background is a neutral near-black with a faint green cast — dark enough
to be restful, never `#000000`.

## Syntax

Four accents, everything else is foreground:

| tokens                                          | colour               |
| ----------------------------------------------- | -------------------- |
| functions, methods, macros                      | muted burnt orange   |
| types, constructors, type parameters            | muted ochre          |
| keywords, modifiers, imports, preprocessor      | pale warm yellow     |
| control flow (`if` `for` `return` `throw` …)    | muted teal, **bold** |
| strings                                         | foreground, a hair greener |
| comments                                        | sage gray, italic    |
| everything else                                 | normal foreground    |

Variables, parameters, fields, properties, constants, booleans, numbers,
operators and punctuation all render as plain foreground. Bold is reserved for
control flow — the one thing worth spotting from across the screen — and is
not used for functions or types.

LSP semantic tokens are re-mapped onto the same four accents; the noisy
per-token kinds (`@lsp.type.variable`, `@lsp.mod.readonly`, …) are cleared so
they cannot reintroduce colour behind tree-sitter's back.

## What is deliberately quiet

Cursorline (1.05:1 against the background), matching brackets, indent guides,
inlay hints, code lenses, reference highlights, git indicators, filetype
icons, completion kind icons, the statusline, and hint/info diagnostics.

Diagnostics follow a hierarchy: hints and info are comment-coloured, warnings
are a muted ochre and underlined, errors get the strongest red plus an
undercurl. Virtual text only ever appears on the line the cursor is already
on, and is dimmed further so it does not compete with the code around it.

## What is deliberately loud

Search matches, the current search match, visual selections, the cursor, and
genuine errors. These are transient state, and transient state is exactly what
colour is for.

## Files

| file                                   | what it themes                         |
| -------------------------------------- | -------------------------------------- |
| `nvim/lua/vstegen/theme/palette.lua`    | source of truth for every colour       |
| `nvim/lua/vstegen/theme/highlights.lua` | all Neovim highlight groups            |
| `nvim/colors/quiet.lua`                 | `:colorscheme quiet`                   |
| `ghostty/themes/quiet`                  | terminal background + ANSI palette     |
| `tmux/.tmux.conf`                       | status line, panes, copy mode          |
| `starship.toml`                         | prompt                                 |
| `zsh/zshrc/colors.zsh`                  | fzf, bat, eza, less, zsh highlighting  |
| `fish/conf.d/quiet_theme.fish`          | fish syntax colours                    |
| `ripgrep/ripgreprc`                     | ripgrep output                         |
| `git/quiet.gitconfig`                   | git diff / status / log / grep         |
| `pi/agent/themes/quiet.json`            | the pi agent TUI                       |

Set `vim.g.quiet_transparent = true` before the colorscheme loads to let the
terminal background show through instead of painting it.

The ANSI palette is intentionally flatter than Neovim's syntax accents:
terminal programs pick colours by convention rather than by importance, so
they get less room to shout. Bright variants are only moderately brighter.
