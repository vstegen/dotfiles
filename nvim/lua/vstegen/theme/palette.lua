-- Palette for the "quiet" theme.
--
-- Design rules:
--  * Readability comes from luminance contrast, not from saturation.
--  * Colour is a signal of attention, not a taxonomy of syntax nodes.
--  * Accents stay under ~45% saturation so that unfocused eyes see monochrome.
--
-- Keep this file the single source of truth: the Ghostty theme, the starship
-- prompt, tmux and the shell tools all mirror these values.

local M = {}

M.colors = {
    -- surfaces ---------------------------------------------------------------
    bg = "#101311", -- editor background (neutral, faint green cast)
    bg_dim = "#0c0f0d", -- below the background: inactive windows, gutters
    bg_line = "#151815", -- cursorline, barely perceptible
    bg_raised = "#171b18", -- floats, popup menus, statusline
    bg_active = "#1c211e", -- reference highlights, subtle "here" markers
    bg_match = "#242a26", -- matching bracket
    bg_sel = "#2f3a35", -- visual selection: must be obvious
    border = "#2a302c", -- window separators and float borders

    -- text -------------------------------------------------------------------
    fg = "#c5c9c5", -- normal foreground: most tokens land here
    fg_bright = "#e1e3df", -- genuinely important text
    fg_quiet = "#9aa39c", -- annotations, attributes, secondary text
    fg_ui = "#59635b", -- line numbers and other legible-but-quiet chrome
    string = "#bcc4b8", -- strings: fg with the faintest green shift
    comment = "#707a73", -- sage gray, recedes but stays readable
    inactive = "#424944", -- separators, fills, disabled UI

    -- accents ----------------------------------------------------------------
    orange = "#c47b5a", -- functions
    ochre = "#c2ad72", -- types
    sand = "#bcae86", -- keywords (paler: they are everywhere)
    teal = "#69a6a0", -- control flow and other "special" keywords
    green = "#718b78", -- additions
    red = "#b76d68", -- deletions
    steel = "#7b8c95", -- information
    mauve = "#9a7f96", -- rare, mostly for ANSI parity

    -- editor state -----------------------------------------------------------
    error = "#c2726b", -- allowed to be the loudest thing on screen
    warn = "#b09a63",
    info = "#7b8c95",
    hint = "#6b7a72",

    search_bg = "#413c2b",
    search_fg = "#e8e4d6",
    cursearch_bg = "#c2ad72",
    cursearch_fg = "#141712",

    cursor = "#d7dad4",

    -- diffs ------------------------------------------------------------------
    diff_add = "#18211a",
    diff_delete = "#241a19",
    diff_change = "#161d20",
    diff_text = "#223034",
}

-- ANSI palette. Deliberately flatter than the syntax palette: terminal
-- programs pick colours by convention, not by importance, so they get less
-- room to shout. Bright variants are only moderately brighter.
M.ansi = {
    [0] = "#262b27",
    [1] = "#b76d68",
    [2] = "#718b78",
    [3] = "#b79f6b",
    [4] = "#6f8aa0",
    [5] = "#9a7f96",
    [6] = "#69a6a0",
    [7] = "#c5c9c5",
    [8] = "#424944",
    [9] = "#c98079",
    [10] = "#859e88",
    [11] = "#c9b57e",
    [12] = "#839db2",
    [13] = "#ab90a6",
    [14] = "#7cb8b1",
    [15] = "#e1e3df",
}

return M
