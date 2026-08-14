-- Highlight definitions for the "quiet" theme.
--
-- The guiding rule for syntax: colour marks *importance*, not *category*.
-- Variables, parameters, fields, constants, numbers, operators and punctuation
-- all render as normal foreground. Only four things earn an accent:
--
--   functions        muted burnt orange   "something happens here"
--   types            muted ochre          "this is the shape of the data"
--   keywords         pale warm yellow     "this is language scaffolding"
--   control flow     muted teal + bold    "the path branches here"
--
-- Everything else is foreground, comment gray, or UI gray.

---@param c table palette colours
---@return table<string, vim.api.keyset.highlight>
return function(c)
    local transparent = vim.g.quiet_transparent == true
    local bg = transparent and "NONE" or c.bg
    local bg_float = transparent and "NONE" or c.bg_raised

    local hl = {
        -- ── editor ──────────────────────────────────────────────────────────
        Normal = { fg = c.fg, bg = bg },
        NormalNC = { fg = c.fg, bg = bg },
        NormalFloat = { fg = c.fg, bg = bg_float },
        FloatBorder = { fg = c.border, bg = bg_float },
        FloatTitle = { fg = c.fg_quiet, bg = bg_float },
        FloatFooter = { fg = c.comment, bg = bg_float },

        Cursor = { fg = c.bg, bg = c.cursor },
        lCursor = { link = "Cursor" },
        CursorIM = { link = "Cursor" },
        TermCursor = { link = "Cursor" },

        CursorLine = { bg = c.bg_line },
        CursorColumn = { bg = c.bg_line },
        ColorColumn = { bg = c.bg_line },

        LineNr = { fg = c.fg_ui },
        LineNrAbove = { fg = c.fg_ui },
        LineNrBelow = { fg = c.fg_ui },
        CursorLineNr = { fg = c.fg_quiet },
        CursorLineSign = { link = "CursorLine" },
        CursorLineFold = { link = "CursorLine" },
        SignColumn = { fg = c.inactive, bg = bg },
        FoldColumn = { fg = c.inactive, bg = bg },
        Folded = { fg = c.comment, bg = c.bg_line },

        -- selection and search are current state: they may be loud
        Visual = { bg = c.bg_sel },
        VisualNOS = { bg = c.bg_sel },
        Search = { fg = c.search_fg, bg = c.search_bg },
        IncSearch = { fg = c.cursearch_fg, bg = c.cursearch_bg },
        CurSearch = { fg = c.cursearch_fg, bg = c.cursearch_bg },
        Substitute = { fg = c.cursearch_fg, bg = c.orange },

        -- deliberately quiet: bracket matching should not flicker in the
        -- corner of your eye while you type
        MatchParen = { fg = c.fg_bright, bg = c.bg_match },

        Pmenu = { fg = c.fg, bg = c.bg_raised },
        PmenuSel = { fg = c.fg_bright, bg = c.bg_sel },
        PmenuKind = { fg = c.comment, bg = c.bg_raised },
        PmenuKindSel = { fg = c.fg_quiet, bg = c.bg_sel },
        PmenuExtra = { fg = c.comment, bg = c.bg_raised },
        PmenuExtraSel = { fg = c.fg_quiet, bg = c.bg_sel },
        PmenuMatch = { fg = c.ochre, bg = c.bg_raised },
        PmenuMatchSel = { fg = c.ochre, bg = c.bg_sel },
        PmenuSbar = { bg = c.bg_raised },
        PmenuThumb = { bg = c.inactive },
        WildMenu = { link = "PmenuSel" },

        StatusLine = { fg = c.comment, bg = c.bg_raised },
        StatusLineNC = { fg = c.inactive, bg = c.bg_dim },
        WinBar = { fg = c.comment, bg = bg },
        WinBarNC = { fg = c.inactive, bg = bg },

        TabLine = { fg = c.comment, bg = c.bg_dim },
        TabLineFill = { bg = c.bg_dim },
        TabLineSel = { fg = c.fg_bright, bg = bg },

        WinSeparator = { fg = c.border, bg = bg },
        VertSplit = { link = "WinSeparator" },

        Directory = { fg = c.fg_quiet },
        Title = { fg = c.fg_bright },
        Question = { fg = c.teal },
        MoreMsg = { fg = c.teal },
        ModeMsg = { fg = c.fg_quiet },
        MsgArea = { fg = c.fg },
        MsgSeparator = { fg = c.border },
        ErrorMsg = { fg = c.error },
        WarningMsg = { fg = c.warn },

        NonText = { fg = c.inactive },
        Whitespace = { fg = c.inactive },
        SpecialKey = { fg = c.inactive },
        EndOfBuffer = { fg = bg == "NONE" and c.bg or bg },
        Conceal = { fg = c.comment },
        Ignore = { fg = c.inactive },

        QuickFixLine = { bg = c.bg_line },
        qfLineNr = { fg = c.fg_ui },
        qfFileName = { fg = c.fg_quiet },

        SpellBad = { sp = c.error, undercurl = true },
        SpellCap = { sp = c.warn, undercurl = true },
        SpellLocal = { sp = c.hint, undercurl = true },
        SpellRare = { sp = c.hint, undercurl = true },

        -- ── diffs ───────────────────────────────────────────────────────────
        DiffAdd = { bg = c.diff_add },
        DiffDelete = { fg = c.inactive, bg = c.diff_delete },
        DiffChange = { bg = c.diff_change },
        DiffText = { bg = c.diff_text },
        diffAdded = { fg = c.green },
        diffRemoved = { fg = c.red },
        diffChanged = { fg = c.steel },
        diffOldFile = { fg = c.red },
        diffNewFile = { fg = c.green },
        diffFile = { fg = c.fg_quiet },
        diffLine = { fg = c.comment },
        diffIndexLine = { fg = c.comment },
        Added = { fg = c.green },
        Removed = { fg = c.red },
        Changed = { fg = c.steel },

        -- ── legacy syntax groups ────────────────────────────────────────────
        Comment = { fg = c.comment, italic = true },
        SpecialComment = { fg = c.comment, italic = true },
        Todo = { fg = c.teal, bold = true },
        Error = { fg = c.error },
        Underlined = { underline = true },

        Constant = { fg = c.fg },
        String = { fg = c.string },
        Character = { fg = c.string },
        Number = { fg = c.fg },
        Boolean = { fg = c.fg },
        Float = { fg = c.fg },

        Identifier = { fg = c.fg },
        Function = { fg = c.orange },

        Statement = { fg = c.sand },
        Conditional = { fg = c.teal, bold = true },
        Repeat = { fg = c.teal, bold = true },
        Label = { fg = c.sand },
        Operator = { fg = c.fg },
        Keyword = { fg = c.sand },
        Exception = { fg = c.teal, bold = true },

        PreProc = { fg = c.sand },
        Include = { fg = c.sand },
        Define = { fg = c.sand },
        Macro = { fg = c.orange },
        PreCondit = { fg = c.sand },

        Type = { fg = c.ochre },
        StorageClass = { fg = c.sand },
        Structure = { fg = c.ochre },
        Typedef = { fg = c.ochre },

        Special = { fg = c.fg },
        SpecialChar = { fg = c.teal },
        Tag = { fg = c.sand },
        Delimiter = { fg = c.fg },
        Debug = { fg = c.warn },

        -- ── tree-sitter ─────────────────────────────────────────────────────
        -- the long tail of token kinds is intentionally plain foreground
        ["@variable"] = { fg = c.fg },
        ["@variable.builtin"] = { fg = c.fg },
        ["@variable.parameter"] = { fg = c.fg },
        ["@variable.parameter.builtin"] = { fg = c.fg },
        ["@variable.member"] = { fg = c.fg },

        ["@constant"] = { fg = c.fg },
        ["@constant.builtin"] = { fg = c.fg },
        ["@constant.macro"] = { fg = c.sand },

        ["@module"] = { fg = c.fg_quiet },
        ["@module.builtin"] = { fg = c.fg_quiet },
        ["@label"] = { fg = c.sand },

        ["@string"] = { fg = c.string },
        ["@string.documentation"] = { fg = c.comment, italic = true },
        ["@string.regexp"] = { fg = c.teal },
        ["@string.escape"] = { fg = c.teal },
        ["@string.special"] = { fg = c.fg },
        ["@string.special.symbol"] = { fg = c.fg },
        ["@string.special.path"] = { fg = c.fg_quiet },
        ["@string.special.url"] = { fg = c.comment, underline = true },
        ["@character"] = { fg = c.string },
        ["@character.special"] = { fg = c.teal },

        ["@boolean"] = { fg = c.fg },
        ["@number"] = { fg = c.fg },
        ["@number.float"] = { fg = c.fg },

        ["@type"] = { fg = c.ochre },
        ["@type.builtin"] = { fg = c.ochre },
        ["@type.definition"] = { fg = c.ochre },
        ["@type.qualifier"] = { fg = c.sand },
        ["@attribute"] = { fg = c.fg_quiet },
        ["@attribute.builtin"] = { fg = c.fg_quiet },
        ["@property"] = { fg = c.fg },

        ["@function"] = { fg = c.orange },
        ["@function.builtin"] = { fg = c.orange },
        ["@function.call"] = { fg = c.orange },
        ["@function.macro"] = { fg = c.orange },
        ["@function.method"] = { fg = c.orange },
        ["@function.method.call"] = { fg = c.orange },
        ["@constructor"] = { fg = c.ochre },

        ["@operator"] = { fg = c.fg },

        ["@keyword"] = { fg = c.sand },
        ["@keyword.coroutine"] = { fg = c.teal, bold = true },
        ["@keyword.function"] = { fg = c.sand },
        ["@keyword.operator"] = { fg = c.sand },
        ["@keyword.import"] = { fg = c.sand },
        ["@keyword.type"] = { fg = c.sand },
        ["@keyword.modifier"] = { fg = c.sand },
        ["@keyword.repeat"] = { fg = c.teal, bold = true },
        ["@keyword.return"] = { fg = c.teal, bold = true },
        ["@keyword.debug"] = { fg = c.warn },
        ["@keyword.exception"] = { fg = c.teal, bold = true },
        ["@keyword.conditional"] = { fg = c.teal, bold = true },
        ["@keyword.conditional.ternary"] = { fg = c.fg },
        ["@keyword.directive"] = { fg = c.sand },
        ["@keyword.directive.define"] = { fg = c.sand },

        ["@punctuation.delimiter"] = { fg = c.fg },
        ["@punctuation.bracket"] = { fg = c.fg },
        ["@punctuation.special"] = { fg = c.fg },

        ["@comment"] = { fg = c.comment, italic = true },
        ["@comment.documentation"] = { fg = c.comment, italic = true },
        ["@comment.error"] = { fg = c.error, bold = true },
        ["@comment.warning"] = { fg = c.warn, bold = true },
        ["@comment.todo"] = { fg = c.teal, bold = true },
        ["@comment.note"] = { fg = c.fg_quiet, bold = true },

        ["@markup.strong"] = { fg = c.fg_bright, bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },
        ["@markup.heading"] = { fg = c.fg_bright, bold = true },
        ["@markup.heading.1"] = { fg = c.fg_bright, bold = true },
        ["@markup.heading.2"] = { fg = c.fg_bright, bold = true },
        ["@markup.heading.3"] = { fg = c.fg, bold = true },
        ["@markup.heading.4"] = { fg = c.fg, bold = true },
        ["@markup.heading.5"] = { fg = c.fg },
        ["@markup.heading.6"] = { fg = c.fg },
        ["@markup.quote"] = { fg = c.comment, italic = true },
        ["@markup.math"] = { fg = c.ochre },
        ["@markup.link"] = { fg = c.teal },
        ["@markup.link.label"] = { fg = c.teal },
        ["@markup.link.url"] = { fg = c.comment, underline = true },
        ["@markup.raw"] = { fg = c.string },
        ["@markup.raw.block"] = { fg = c.fg },
        ["@markup.list"] = { fg = c.comment },
        ["@markup.list.checked"] = { fg = c.green },
        ["@markup.list.unchecked"] = { fg = c.comment },

        ["@diff.plus"] = { fg = c.green },
        ["@diff.minus"] = { fg = c.red },
        ["@diff.delta"] = { fg = c.steel },

        ["@tag"] = { fg = c.sand },
        ["@tag.builtin"] = { fg = c.sand },
        ["@tag.attribute"] = { fg = c.fg_quiet },
        ["@tag.delimiter"] = { fg = c.comment },

        -- ── LSP ─────────────────────────────────────────────────────────────
        -- semantic tokens are re-mapped onto the same four accents; the noisy
        -- per-token kinds are cleared so tree-sitter shows through unchanged
        ["@lsp.type.class"] = { fg = c.ochre },
        ["@lsp.type.enum"] = { fg = c.ochre },
        ["@lsp.type.interface"] = { fg = c.ochre },
        ["@lsp.type.struct"] = { fg = c.ochre },
        ["@lsp.type.type"] = { fg = c.ochre },
        ["@lsp.type.typeParameter"] = { fg = c.ochre },
        ["@lsp.type.function"] = { fg = c.orange },
        ["@lsp.type.method"] = { fg = c.orange },
        ["@lsp.type.macro"] = { fg = c.orange },
        ["@lsp.type.namespace"] = { fg = c.fg_quiet },
        ["@lsp.type.decorator"] = { fg = c.fg_quiet },

        LspReferenceText = { bg = c.bg_active },
        LspReferenceRead = { bg = c.bg_active },
        LspReferenceWrite = { bg = c.bg_active },
        LspReferenceTarget = {},
        LspSignatureActiveParameter = { fg = c.fg_bright, bold = true },
        LspInlayHint = { fg = c.inactive },
        LspCodeLens = { fg = c.inactive, italic = true },
        LspCodeLensSeparator = { fg = c.inactive },

        -- ── diagnostics ─────────────────────────────────────────────────────
        DiagnosticError = { fg = c.error },
        DiagnosticWarn = { fg = c.warn },
        DiagnosticInfo = { fg = c.info },
        DiagnosticHint = { fg = c.hint },
        DiagnosticOk = { fg = c.green },

        -- signs keep the full colour: they live in the gutter, out of the way
        DiagnosticSignError = { fg = c.error },
        DiagnosticSignWarn = { fg = c.warn },
        DiagnosticSignInfo = { fg = c.info },
        DiagnosticSignHint = { fg = c.hint },
        DiagnosticSignOk = { fg = c.green },

        -- virtual text sits *inside* the code, so it is dimmed hard
        DiagnosticVirtualTextError = { fg = "#8d5f5b" },
        DiagnosticVirtualTextWarn = { fg = "#7f7355" },
        DiagnosticVirtualTextInfo = { fg = c.comment },
        DiagnosticVirtualTextHint = { fg = c.comment },
        DiagnosticVirtualTextOk = { fg = c.comment },

        DiagnosticVirtualLinesError = { fg = "#8d5f5b" },
        DiagnosticVirtualLinesWarn = { fg = "#7f7355" },
        DiagnosticVirtualLinesInfo = { fg = c.comment },
        DiagnosticVirtualLinesHint = { fg = c.comment },

        -- only errors are underlined, and never with a saturated squiggle
        DiagnosticUnderlineError = { sp = c.error, undercurl = true },
        DiagnosticUnderlineWarn = { sp = c.warn, underline = true },
        DiagnosticUnderlineInfo = {},
        DiagnosticUnderlineHint = {},
        DiagnosticUnderlineOk = {},

        DiagnosticFloatingError = { fg = c.error },
        DiagnosticFloatingWarn = { fg = c.warn },
        DiagnosticFloatingInfo = { fg = c.info },
        DiagnosticFloatingHint = { fg = c.hint },
        DiagnosticFloatingOk = { fg = c.green },

        DiagnosticDeprecated = { fg = c.comment, strikethrough = true },
        DiagnosticUnnecessary = { fg = c.comment },

        -- ── mini.statusline ─────────────────────────────────────────────────
        -- the mode block is the one place the statusline is allowed a colour,
        -- because "which mode am I in" is live state
        MiniStatuslineModeNormal = { fg = c.fg_bright, bg = c.border, bold = true },
        MiniStatuslineModeInsert = { fg = "#cfe0dd", bg = "#2f4a46", bold = true },
        MiniStatuslineModeVisual = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
        MiniStatuslineModeReplace = { fg = "#e0cfcd", bg = "#4a2f2d", bold = true },
        MiniStatuslineModeCommand = { fg = "#e0dccf", bg = "#4a442f", bold = true },
        MiniStatuslineModeOther = { fg = c.fg, bg = c.border, bold = true },
        MiniStatuslineDevinfo = { fg = c.comment, bg = c.bg_raised },
        MiniStatuslineFilename = { fg = c.fg, bg = c.bg_raised },
        MiniStatuslineFileinfo = { fg = c.comment, bg = c.bg_raised },
        MiniStatuslineInactive = { fg = c.inactive, bg = c.bg_dim },

        -- ── mini.* ──────────────────────────────────────────────────────────
        MiniSurround = { fg = c.cursearch_fg, bg = c.ochre },
        MiniOperatorsExchangeFrom = { bg = c.bg_match },
        MiniIndentscopeSymbol = { fg = c.inactive },
        MiniIndentscopePrefix = { nocombine = true },

        -- ── blink.cmp ───────────────────────────────────────────────────────
        BlinkCmpMenu = { fg = c.fg, bg = c.bg_raised },
        BlinkCmpMenuBorder = { fg = c.border, bg = c.bg_raised },
        BlinkCmpMenuSelection = { fg = c.fg_bright, bg = c.bg_sel },
        BlinkCmpScrollBarThumb = { bg = c.inactive },
        BlinkCmpScrollBarGutter = { bg = c.bg_raised },
        BlinkCmpLabel = { fg = c.fg },
        BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
        BlinkCmpLabelMatch = { fg = c.ochre },
        BlinkCmpLabelDetail = { fg = c.comment },
        BlinkCmpLabelDescription = { fg = c.comment },
        BlinkCmpKind = { fg = c.comment },
        BlinkCmpSource = { fg = c.comment },
        BlinkCmpGhostText = { fg = c.inactive },
        BlinkCmpDoc = { fg = c.fg, bg = c.bg_raised },
        BlinkCmpDocBorder = { fg = c.border, bg = c.bg_raised },
        BlinkCmpDocSeparator = { fg = c.border, bg = c.bg_raised },
        BlinkCmpDocCursorLine = { bg = c.bg_line },
        BlinkCmpSignatureHelp = { fg = c.fg, bg = c.bg_raised },
        BlinkCmpSignatureHelpBorder = { fg = c.border, bg = c.bg_raised },
        BlinkCmpSignatureHelpActiveParameter = { fg = c.fg_bright, bold = true },

        -- ── fzf-lua ─────────────────────────────────────────────────────────
        -- `fzf_colors = true` derives fzf's own palette from these
        FzfLuaNormal = { fg = c.fg, bg = c.bg_raised },
        FzfLuaBorder = { fg = c.border, bg = c.bg_raised },
        FzfLuaTitle = { fg = c.fg_quiet, bg = c.bg_raised },
        FzfLuaTitleFlags = { fg = c.comment, bg = c.bg_raised },
        FzfLuaBackdrop = { bg = c.bg_dim },
        FzfLuaPreviewNormal = { fg = c.fg, bg = c.bg_raised },
        FzfLuaPreviewBorder = { fg = c.border, bg = c.bg_raised },
        FzfLuaPreviewTitle = { fg = c.fg_quiet, bg = c.bg_raised },
        FzfLuaCursor = { fg = c.bg, bg = c.cursor },
        FzfLuaCursorLine = { fg = c.fg_bright, bg = c.bg_sel },
        FzfLuaCursorLineNr = { fg = c.fg_quiet, bg = c.bg_sel },
        FzfLuaSearch = { fg = c.search_fg, bg = c.search_bg },
        FzfLuaScrollBorderEmpty = { fg = c.border },
        FzfLuaScrollBorderFull = { fg = c.inactive },
        FzfLuaScrollFloatEmpty = { bg = c.bg_raised },
        FzfLuaScrollFloatFull = { bg = c.border },
        FzfLuaHeaderBind = { fg = c.fg_quiet },
        FzfLuaHeaderText = { fg = c.comment },
        FzfLuaPathColNr = { fg = c.comment },
        FzfLuaPathLineNr = { fg = c.comment },
        FzfLuaBufName = { fg = c.fg_quiet },
        FzfLuaBufNr = { fg = c.comment },
        FzfLuaBufFlagCur = { fg = c.ochre },
        FzfLuaBufFlagAlt = { fg = c.comment },
        FzfLuaTabTitle = { fg = c.fg_quiet },
        FzfLuaTabMarker = { fg = c.ochre },
        FzfLuaLiveSym = { fg = c.ochre },
        FzfLuaFzfMatch = { fg = c.ochre },
        FzfLuaFzfPrompt = { fg = c.teal },
        FzfLuaFzfPointer = { fg = c.orange },
        FzfLuaFzfMarker = { fg = c.teal },
        FzfLuaFzfInfo = { fg = c.comment },
        FzfLuaFzfSeparator = { fg = c.border },
        FzfLuaFzfGutter = { bg = c.bg_raised },
        FzfLuaFzfCursorLine = { fg = c.fg_bright, bg = c.bg_sel },
        FzfLuaFzfHeader = { fg = c.comment },
        FzfLuaFzfScrollbar = { fg = c.inactive },

        -- ── which-key ───────────────────────────────────────────────────────
        WhichKey = { fg = c.ochre },
        WhichKeyDesc = { fg = c.fg },
        WhichKeyGroup = { fg = c.fg_quiet },
        WhichKeySeparator = { fg = c.inactive },
        WhichKeyValue = { fg = c.comment },
        WhichKeyNormal = { fg = c.fg, bg = c.bg_raised },
        WhichKeyBorder = { fg = c.border, bg = c.bg_raised },
        WhichKeyTitle = { fg = c.fg_quiet, bg = c.bg_raised },

        -- ── flash ───────────────────────────────────────────────────────────
        FlashBackdrop = { fg = c.inactive },
        FlashMatch = { fg = c.fg_bright, bg = c.bg_match },
        FlashCurrent = { fg = c.cursearch_fg, bg = c.ochre },
        FlashLabel = { fg = c.cursearch_fg, bg = c.orange, bold = true },
        FlashPrompt = { fg = c.fg, bg = c.bg_raised },
        FlashPromptIcon = { fg = c.teal },

        -- ── oil ─────────────────────────────────────────────────────────────
        OilDir = { fg = c.fg_quiet },
        OilDirIcon = { fg = c.inactive },
        OilFile = { fg = c.fg },
        OilLink = { fg = c.teal },
        OilLinkTarget = { fg = c.comment },
        OilSocket = { fg = c.fg_quiet },
        OilCreate = { fg = c.green },
        OilDelete = { fg = c.red },
        OilMove = { fg = c.steel },
        OilCopy = { fg = c.steel },
        OilChange = { fg = c.warn },
        OilRestore = { fg = c.green },
        OilPurge = { fg = c.red },
        OilTrash = { fg = c.warn },
        OilTrashSourcePath = { fg = c.comment },

        -- ── snacks ──────────────────────────────────────────────────────────
        SnacksNormal = { fg = c.fg, bg = c.bg_raised },
        SnacksNormalNC = { fg = c.fg, bg = c.bg_raised },
        SnacksWinBar = { fg = c.fg_quiet, bg = c.bg_raised },
        SnacksWinBarNC = { fg = c.comment, bg = c.bg_raised },
        SnacksBackdrop = { bg = c.bg_dim },
        SnacksDim = { fg = c.inactive },
        SnacksIndent = { fg = c.border },
        SnacksIndentScope = { fg = c.inactive },
        SnacksNotifierInfo = { fg = c.info, bg = c.bg_raised },
        SnacksNotifierWarn = { fg = c.warn, bg = c.bg_raised },
        SnacksNotifierError = { fg = c.error, bg = c.bg_raised },
        SnacksNotifierDebug = { fg = c.comment, bg = c.bg_raised },
        SnacksNotifierTrace = { fg = c.comment, bg = c.bg_raised },
        SnacksPickerMatch = { fg = c.ochre },
        SnacksPickerDir = { fg = c.comment },
        SnacksPickerFile = { fg = c.fg },
        SnacksPickerPathHidden = { fg = c.comment },
        SnacksPickerPathIgnored = { fg = c.inactive },
        SnacksPickerPrompt = { fg = c.teal },
        SnacksPickerSelected = { fg = c.ochre },
        SnacksPickerTitle = { fg = c.fg_quiet, bg = c.bg_raised },
        SnacksPickerBorder = { fg = c.border, bg = c.bg_raised },
        SnacksInputNormal = { fg = c.fg, bg = c.bg_raised },
        SnacksInputBorder = { fg = c.border, bg = c.bg_raised },
        SnacksInputTitle = { fg = c.fg_quiet, bg = c.bg_raised },

        -- ── treesitter-context ──────────────────────────────────────────────
        TreesitterContext = { bg = c.bg_line },
        TreesitterContextLineNumber = { fg = c.inactive, bg = c.bg_line },
        TreesitterContextBottom = { sp = c.border, underline = true },
        TreesitterContextSeparator = { fg = c.border },

        -- ── lazy / mason ────────────────────────────────────────────────────
        LazyNormal = { fg = c.fg, bg = c.bg_raised },
        LazyButton = { fg = c.comment, bg = c.bg_line },
        LazyButtonActive = { fg = c.fg_bright, bg = c.bg_sel },
        LazyH1 = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
        LazyProgressDone = { fg = c.teal },
        LazyProgressTodo = { fg = c.inactive },
        MasonNormal = { fg = c.fg, bg = c.bg_raised },
        MasonHeader = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
        MasonHighlight = { fg = c.teal },
        MasonMuted = { fg = c.comment },
        MasonMutedBlock = { fg = c.comment, bg = c.bg_line },
    }

    -- completion kind icons: uniformly quiet, so the popup reads as a list of
    -- words rather than a colour chart
    for _, kind in ipairs {
        "Text",
        "Method",
        "Function",
        "Constructor",
        "Field",
        "Variable",
        "Class",
        "Interface",
        "Module",
        "Property",
        "Unit",
        "Value",
        "Enum",
        "Keyword",
        "Snippet",
        "Color",
        "File",
        "Reference",
        "Folder",
        "EnumMember",
        "Constant",
        "Struct",
        "Event",
        "Operator",
        "TypeParameter",
    } do
        hl["BlinkCmpKind" .. kind] = { link = "BlinkCmpKind" }
        hl["CmpItemKind" .. kind] = { link = "BlinkCmpKind" }
    end

    -- mini.icons: filetype icons are decoration, not information
    for _, tone in ipairs { "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow" } do
        hl["MiniIcons" .. tone] = { fg = c.fg_quiet }
    end

    -- LSP semantic tokens we deliberately do not colour: clearing them lets
    -- the tree-sitter rules above stay in charge
    for _, kind in ipairs {
        "@lsp.type.comment",
        "@lsp.type.keyword",
        "@lsp.type.number",
        "@lsp.type.operator",
        "@lsp.type.parameter",
        "@lsp.type.property",
        "@lsp.type.string",
        "@lsp.type.variable",
        "@lsp.type.enumMember",
        "@lsp.type.event",
        "@lsp.type.modifier",
        "@lsp.type.regexp",
        "@lsp.mod.readonly",
        "@lsp.mod.static",
        "@lsp.mod.defaultLibrary",
        "@lsp.mod.global",
        "@lsp.mod.constant",
        "@lsp.typemod.variable.readonly",
        "@lsp.typemod.variable.defaultLibrary",
        "@lsp.typemod.variable.global",
        "@lsp.typemod.parameter.declaration",
        "@lsp.typemod.property.declaration",
        "@lsp.typemod.member.readonly",
    } do
        hl[kind] = {}
    end

    return hl
end
