-- ============================================================================
-- Glacier Signal
-- Misty mountain shadows, glacial cyan, and sparse coral signals.
-- Quiet, low-saturation, glass over chrome. Cool sets the tone.
-- Single source of truth = Style Guide v2.0 (mayo 2026).
-- ============================================================================

local M = {}

-- Palette tokens (match --* del style guide v2, data-palette="glacier") -------
M.palette = {
  -- identity (signal -> frost)
  signal = "#22b8f5", -- primary: keywords, mode, prompt
  glow = "#a8ecff", -- active tab, titles, glow
  mint = "#5ff2cf", -- cursor, functions, diagnostics
  frost = "#e0fbff", -- numbers, highlight

  -- structure (steel -> azure)
  steel = "#5f9bd8", -- branch, session, position
  ice = "#7fe0ff", -- active window, strings
  skyline = "#0a3e57", -- on-ice text, shadow hint

  -- ground (sky behind glass)
  abyss = "#04141c",
  night = "#062230",
  fjord = "#0d3547",
  ridge = "#174b60",
  mauve = "#2e6b83",
  dawn = "#7fb5c4",
  horizon = "#cfe6e4",

  -- foreground
  snow = "#f3faf7", -- default fg
  silver = "#c3d9d6", -- muted fg base

  -- Espectro de alta legibilidad (rediseno 2026-06). Sobre el lienzo dusk:
  -- los fondos siguen siendo Glacier Signal, el TEXTO gana rango cromatico.
  -- Tokens NUEVOS; no pisan los de chrome (signal/ice/etc.) que leen
  -- lualine/bufferline/tmux, asi que la barra de estado no cambia.
  gold = "#ffd873", -- functions / methods
  teal = "#5ff2cf", -- types / namespaces / classes
  green = "#8fdc8f", -- strings
  orange = "#ffd873", -- numbers / constants
  coral = "#ff7a6e", -- booleans / git delete
  azure = "#b8f1ff", -- properties / fields

  -- blended (rgba aproximado sobre night #062230)
  panel = "#0d3547", -- raised surface (floats, menus) = fjord
  cursorline = "#0b2d3d", -- rgba(ice,.06)
  selection = "#0f526f", -- rgba(signal,.22)
  indent = "#0e3244", -- rgba(ice,.10)
  linenr = "#1d5064", -- rgba(ice,.30)  gutter
  comment = "#559eb7", -- lifted 2026-06: era #438198 (50%), poco legible
  punct = "#5b747b", -- rgba(silver,.45)
  muted = "#839b9e", -- rgba(silver,.58)
  pane_border = "#113e51", -- rgba(signal,.12)
  pane_active = "#498aa2", -- rgba(ice,.35)
  branch_bg = "#214c5e", -- rgba(ice,.22)
  diag_bg = "#15455a", -- rgba(mint,.18)
  search_bg = "#143f4f", -- rgba(frost,.14)

  none = "NONE",
}

-- ============================================================================
function M.apply()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "glacier-signal"

  local c = M.palette
  local hl = function(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
  end
  local link = function(from, to)
    vim.api.nvim_set_hl(0, from, { link = to })
  end

  -- ========================================================================
  -- Editor chrome - glass: backgrounds NONE, el wallpaper sangra
  -- ========================================================================
  hl("Normal", { fg = c.snow, bg = c.none })
  hl("NormalNC", { fg = c.snow, bg = c.none })
  hl("NormalFloat", { fg = c.snow, bg = c.none })
  hl("FloatBorder", { fg = c.signal, bg = c.none })
  hl("FloatTitle", { fg = c.glow, bold = true })
  hl("WinSeparator", { fg = c.pane_border, bg = c.none })
  hl("VertSplit", { fg = c.pane_border, bg = c.none })
  hl("SignColumn", { fg = c.muted, bg = c.none })
  hl("FoldColumn", { fg = c.steel, bg = c.none })
  hl("Folded", { fg = c.steel, bg = c.panel })
  hl("EndOfBuffer", { fg = c.night })
  hl("MsgArea", { fg = c.snow })
  hl("ModeMsg", { fg = c.glow, bold = true })
  hl("MoreMsg", { fg = c.ice })
  hl("ErrorMsg", { fg = c.mint, bold = true })
  hl("WarningMsg", { fg = c.frost })

  hl("Cursor", { fg = c.night, bg = c.mint })
  hl("lCursor", { fg = c.night, bg = c.mint })
  hl("CursorLine", { bg = c.cursorline })
  hl("CursorColumn", { bg = c.cursorline })
  hl("ColorColumn", { bg = c.panel })
  hl("CursorLineNr", { fg = c.mint, bold = true })
  hl("LineNr", { fg = c.linenr })

  hl("Visual", { bg = c.selection })
  hl("VisualNOS", { bg = c.selection })

  hl("Search", { fg = c.frost, bg = c.search_bg })
  hl("IncSearch", { fg = c.night, bg = c.frost, bold = true })
  hl("CurSearch", { fg = c.night, bg = c.frost, bold = true })
  hl("MatchParen", { fg = c.mint, bg = c.none, bold = true, underline = true })

  hl("Pmenu", { fg = c.snow, bg = c.panel })
  hl("PmenuSel", { fg = c.night, bg = c.ice, bold = true })
  hl("PmenuSbar", { bg = c.panel })
  hl("PmenuThumb", { bg = c.steel })
  hl("WildMenu", { fg = c.night, bg = c.signal })

  hl("QuickFixLine", { bg = c.branch_bg })
  hl("SpellBad", { sp = c.mint, undercurl = true })
  hl("SpellCap", { sp = c.frost, undercurl = true })
  hl("SpellRare", { sp = c.azure, undercurl = true })
  hl("SpellLocal", { sp = c.ice, undercurl = true })

  -- Status / tabline - lualine/bufferline pintan el resto
  hl("StatusLine", { fg = c.snow, bg = c.panel })
  hl("StatusLineNC", { fg = c.muted, bg = c.panel })
  hl("TabLine", { fg = c.muted, bg = c.night })
  hl("TabLineFill", { bg = c.night })
  hl("TabLineSel", { fg = c.ice, bg = c.branch_bg, bold = true })

  hl("Title", { fg = c.glow, bold = true })
  hl("Directory", { fg = c.ice, bold = true })
  hl("Conceal", { fg = c.comment })
  hl("NonText", { fg = c.indent })
  hl("Whitespace", { fg = c.indent })
  hl("SpecialKey", { fg = c.signal })

  -- ========================================================================
  -- Syntax (legacy vim groups) - tree-sitter hace el resto
  -- ========================================================================
  hl("Comment", { fg = c.comment, italic = true })
  hl("Constant", { fg = c.orange })
  hl("String", { fg = c.green })
  hl("Character", { fg = c.green })
  hl("Number", { fg = c.orange })
  hl("Boolean", { fg = c.coral })
  hl("Float", { fg = c.orange })

  hl("Identifier", { fg = c.snow })
  hl("Function", { fg = c.gold })

  hl("Statement", { fg = c.signal })
  hl("Conditional", { fg = c.signal })
  hl("Repeat", { fg = c.signal })
  hl("Label", { fg = c.signal })
  hl("Operator", { fg = c.signal })
  hl("Keyword", { fg = c.signal })
  hl("Exception", { fg = c.signal })

  hl("PreProc", { fg = c.glow })
  hl("Include", { fg = c.signal })
  hl("Define", { fg = c.signal })
  hl("Macro", { fg = c.glow })
  hl("PreCondit", { fg = c.signal })

  hl("Type", { fg = c.teal })
  hl("StorageClass", { fg = c.signal })
  hl("Structure", { fg = c.teal })
  hl("Typedef", { fg = c.teal })

  hl("Special", { fg = c.mint })
  hl("SpecialChar", { fg = c.mint })
  hl("Tag", { fg = c.signal })
  hl("Delimiter", { fg = c.punct })
  hl("SpecialComment", { fg = c.ice })
  hl("Debug", { fg = c.mint })

  hl("Underlined", { fg = c.ice, underline = true })
  hl("Ignore", { fg = c.muted })
  hl("Error", { fg = c.mint, bold = true })
  hl("Todo", { fg = c.frost, bold = true })

  -- ========================================================================
  -- Tree-sitter captures (contrato §05 del style guide v2)
  -- Sin bold en keywords: el color hace el trabajo.
  -- ========================================================================
  -- Keywords / operators / conditionals -> Signal
  local kw = { fg = c.signal }
  hl("@keyword", kw)
  hl("@keyword.function", kw)
  hl("@keyword.return", kw)
  hl("@keyword.operator", kw)
  hl("@keyword.import", kw)
  hl("@keyword.conditional", kw)
  hl("@keyword.repeat", kw)
  hl("@keyword.exception", kw)
  hl("@keyword.storage", kw)
  hl("@keyword.directive", kw)
  hl("@keyword.coroutine", kw)
  hl("@operator", kw)
  hl("@conditional", kw)
  hl("@repeat", kw)
  hl("@exception", kw)
  hl("@include", kw)

  -- Functions / constructors -> Gold (acento calido, alto contraste)
  local fn = { fg = c.gold }
  hl("@function", fn)
  hl("@function.call", fn)
  hl("@function.builtin", fn)
  hl("@function.method", fn)
  hl("@function.method.call", fn)
  hl("@function.macro", fn)
  hl("@constructor", fn)
  hl("@method", fn)
  hl("@method.call", fn)

  -- Strings -> Green
  hl("@string", { fg = c.green })
  hl("@string.regex", { fg = c.green })
  hl("@string.regexp", { fg = c.green })
  hl("@string.escape", { fg = c.coral })
  hl("@string.special", { fg = c.teal })

  -- Types / namespaces -> Teal
  hl("@type", { fg = c.teal })
  hl("@type.builtin", { fg = c.teal, italic = true })
  hl("@type.definition", { fg = c.teal, bold = true })
  hl("@namespace", { fg = c.teal })
  hl("@module", { fg = c.teal })
  hl("@class", { fg = c.teal })

  -- Numbers / constants -> Orange ; booleans -> Coral
  hl("@number", { fg = c.orange })
  hl("@float", { fg = c.orange })
  hl("@boolean", { fg = c.coral })
  hl("@constant", { fg = c.orange })
  hl("@constant.builtin", { fg = c.orange, italic = true })
  hl("@constant.macro", { fg = c.orange })

  -- Properties / fields -> Azure (azul, distinto de keywords y variables)
  hl("@property", { fg = c.azure })
  hl("@field", { fg = c.azure })
  hl("@tag", { fg = c.signal })
  hl("@tag.builtin", { fg = c.glow })
  hl("@tag.delimiter", { fg = c.punct })

  -- Atributos JSX/HTML -> Mint Mist + italic. Color RESERVADO solo para esto
  -- (ningun otro token lo usa tras mover funciones a dorado), para que el
  -- nombre de la prop nunca se confunda con su valor (var blanco / fn dorado /
  -- string verde). La cursiva es una segunda señal ademas del hue.
  -- Se cubren todos los captures plausibles segun version del parser tsx.
  local attr = { fg = c.mint, italic = true }
  hl("@tag.attribute", attr)
  hl("@attribute", attr)

  -- Variables / parameters -> Snow (default fg, la base calmada)
  hl("@variable", { fg = c.snow })
  hl("@variable.builtin", { fg = c.snow, italic = true })
  hl("@variable.parameter", { fg = c.snow })
  hl("@variable.member", { fg = c.azure })
  hl("@parameter", { fg = c.snow })

  -- Comments -> Ice 50%, italic
  hl("@comment", { fg = c.comment, italic = true })
  hl("@comment.documentation", { fg = c.teal, italic = true })
  hl("@comment.todo", { fg = c.frost, bold = true })
  hl("@comment.note", { fg = c.ice, bold = true })
  hl("@comment.warning", { fg = c.frost, bold = true })
  hl("@comment.error", { fg = c.mint, bold = true })

  -- Punctuation -> Silver 45%
  hl("@punctuation", { fg = c.punct })
  hl("@punctuation.delimiter", { fg = c.punct })
  hl("@punctuation.bracket", { fg = c.punct })
  hl("@punctuation.special", { fg = c.mint })

  -- Text formatting (markdown, etc.)
  hl("@markup.heading", { fg = c.glow, bold = true })
  hl("@markup.heading.1", { fg = c.glow, bold = true })
  hl("@markup.heading.2", { fg = c.mint, bold = true })
  hl("@markup.heading.3", { fg = c.frost, bold = true })
  hl("@markup.heading.4", { fg = c.ice, bold = true })
  hl("@markup.heading.5", { fg = c.azure, bold = true })
  hl("@markup.heading.6", { fg = c.steel, bold = true })
  hl("@markup.strong", { fg = c.glow, bold = true })
  hl("@markup.italic", { fg = c.frost, italic = true })
  hl("@markup.underline", { fg = c.ice, underline = true })
  hl("@markup.strikethrough", { fg = c.muted, strikethrough = true })
  hl("@markup.link", { fg = c.ice, underline = true })
  hl("@markup.link.label", { fg = c.signal })
  hl("@markup.link.url", { fg = c.azure, underline = true })
  hl("@markup.raw", { fg = c.frost, bg = c.panel })
  hl("@markup.quote", { fg = c.comment, italic = true })
  hl("@markup.list", { fg = c.ice })

  -- JSX / HTML / CSS
  hl("@tag.tsx", { fg = c.signal })
  hl("@tag.jsx", { fg = c.signal })
  hl("@tag.attribute.tsx", attr)
  hl("@tag.attribute.jsx", attr)
  hl("@attribute.tsx", attr)
  hl("@attribute.jsx", attr)
  hl("@property.css", { fg = c.azure })
  hl("@type.css", { fg = c.teal })
  hl("@number.css", { fg = c.orange })
  hl("@string.css", { fg = c.green })

  -- ========================================================================
  -- LSP semantic tokens
  -- ========================================================================
  link("@lsp.type.class", "@type")
  link("@lsp.type.comment", "@comment")
  link("@lsp.type.enum", "@type")
  link("@lsp.type.enumMember", "@constant")
  link("@lsp.type.function", "@function")
  link("@lsp.type.interface", "@type")
  link("@lsp.type.keyword", "@keyword")
  link("@lsp.type.macro", "@function.macro")
  link("@lsp.type.method", "@function.method")
  link("@lsp.type.namespace", "@namespace")
  link("@lsp.type.parameter", "@variable.parameter")
  link("@lsp.type.property", "@property")
  link("@lsp.type.struct", "@type")
  link("@lsp.type.type", "@type")
  link("@lsp.type.typeParameter", "@type")
  link("@lsp.type.variable", "@variable")
  hl("@lsp.mod.readonly", { fg = c.orange })
  hl("@lsp.mod.deprecated", { strikethrough = true, fg = c.muted })

  -- ========================================================================
  -- Diagnostics - underline only, sin sign column fill (§05)
  -- err Mint Mist / warn Frost / info Cyan Mist / hint Steel
  -- ========================================================================
  hl("DiagnosticError", { fg = c.mint })
  hl("DiagnosticWarn", { fg = c.frost })
  hl("DiagnosticInfo", { fg = c.azure })
  hl("DiagnosticHint", { fg = c.steel })
  hl("DiagnosticOk", { fg = c.ice })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.mint })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.frost })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.azure })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.steel })
  hl("DiagnosticSignError", { fg = c.mint, bg = c.none })
  hl("DiagnosticSignWarn", { fg = c.frost, bg = c.none })
  hl("DiagnosticSignInfo", { fg = c.azure, bg = c.none })
  hl("DiagnosticSignHint", { fg = c.steel, bg = c.none })
  hl("DiagnosticVirtualTextError", { fg = c.mint, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextWarn", { fg = c.frost, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextInfo", { fg = c.azure, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextHint", { fg = c.steel, bg = c.none, italic = true })

  -- ========================================================================
  -- LSP references / lens
  -- ========================================================================
  hl("LspReferenceText", { bg = c.cursorline })
  hl("LspReferenceRead", { bg = c.cursorline })
  hl("LspReferenceWrite", { bg = c.selection })
  hl("LspCodeLens", { fg = c.comment, italic = true })
  hl("LspCodeLensSeparator", { fg = c.comment })
  hl("LspSignatureActiveParameter", { fg = c.mint, bold = true })
  hl("LspInlayHint", { fg = c.comment, italic = true, bg = c.none })

  -- ========================================================================
  -- Diff / git - add Ice / del Signal / change Frost (§05)
  -- ========================================================================
  hl("DiffAdd", { fg = c.green, bg = c.none })
  hl("DiffChange", { fg = c.orange, bg = c.none })
  hl("DiffDelete", { fg = c.coral, bg = c.none })
  hl("DiffText", { fg = c.orange, bg = c.panel, bold = true })
  hl("diffAdded", { fg = c.green })
  hl("diffRemoved", { fg = c.coral })
  hl("diffChanged", { fg = c.orange })
  hl("diffFile", { fg = c.glow, bold = true })
  hl("diffNewFile", { fg = c.green, bold = true })
  hl("diffLine", { fg = c.teal })

  hl("GitSignsAdd", { fg = c.green })
  hl("GitSignsChange", { fg = c.orange })
  hl("GitSignsDelete", { fg = c.coral })
  hl("GitSignsCurrentLineBlame", { fg = c.comment, italic = true })

  -- ========================================================================
  -- Treesitter context (sticky)
  -- ========================================================================
  hl("TreesitterContext", { bg = c.panel })
  hl("TreesitterContextLineNumber", { fg = c.mint, bg = c.panel })
  hl("TreesitterContextBottom", { sp = c.signal, underline = true })

  -- ========================================================================
  -- Indent guides - ice 10%, barely visible
  -- ========================================================================
  hl("IblIndent", { fg = c.indent, bg = c.none })
  hl("IblScope", { fg = c.steel, bg = c.none })
  hl("IblWhitespace", { fg = c.indent })
  hl("SnacksIndent", { fg = c.indent })
  hl("SnacksIndentScope", { fg = c.steel })
  hl("SnacksIndentChunk", { fg = c.steel })

  -- ========================================================================
  -- Snacks - picker, explorer, notifier, dashboard
  -- ========================================================================
  hl("SnacksPickerTitle", { fg = c.glow, bold = true })
  hl("SnacksPickerBorder", { fg = c.signal })
  hl("SnacksPickerMatch", { fg = c.mint, bold = true })
  hl("SnacksPickerDir", { fg = c.ice })
  hl("SnacksPickerFile", { fg = c.snow })
  hl("SnacksPickerPrompt", { fg = c.signal, bold = true })
  hl("SnacksPickerCursorLine", { bg = c.branch_bg })
  hl("SnacksPickerSelected", { fg = c.ice, bold = true })
  hl("SnacksPickerList", { bg = c.none })
  hl("SnacksPickerListNC", { bg = c.none })
  hl("SnacksPickerPreview", { bg = c.none })
  hl("SnacksPickerPreviewNC", { bg = c.none })
  hl("SnacksPickerInput", { bg = c.none })
  hl("SnacksPickerInputNC", { bg = c.none })
  hl("SnacksPickerBox", { bg = c.none })

  hl("SnacksDashboardTitle", { fg = c.glow, bold = true })
  hl("SnacksDashboardHeader", { fg = c.glow, bold = true })
  hl("SnacksDashboardDesc", { fg = c.snow })
  hl("SnacksDashboardIcon", { fg = c.mint })
  hl("SnacksDashboardKey", { fg = c.ice })
  hl("SnacksDashboardTerminal", { fg = c.signal })
  hl("SnacksDashboardFooter", { fg = c.comment })

  hl("SnacksNotifierInfo", { fg = c.azure })
  hl("SnacksNotifierWarn", { fg = c.frost })
  hl("SnacksNotifierError", { fg = c.mint })
  hl("SnacksNotifierDebug", { fg = c.ice })
  hl("SnacksNotifierTrace", { fg = c.comment })
  hl("SnacksNotifierHistory", { bg = c.panel })

  hl("SnacksWordsCurrent", { bg = c.selection, bold = true })
  hl("SnacksWords", { bg = c.cursorline })

  -- Explorer
  hl("SnacksExplorerDir", { fg = c.ice, bold = true })
  hl("SnacksExplorerFile", { fg = c.snow })
  hl("SnacksExplorerIcon", { fg = c.mint })
  hl("SnacksExplorerRootName", { fg = c.glow, bold = true })

  -- Hidden / ignored / dimmed entries -> muted, italic
  hl("SnacksPickerDimmed", { fg = c.muted })
  hl("SnacksPickerDirHidden", { fg = c.muted, italic = true })
  hl("SnacksPickerFileHidden", { fg = c.muted, italic = true })
  hl("SnacksPickerDirIgnored", { fg = c.muted, italic = true })
  hl("SnacksPickerFileIgnored", { fg = c.muted, italic = true })
  hl("SnacksPickerPathHidden", { fg = c.muted, italic = true })
  hl("SnacksPickerPathIgnored", { fg = c.muted, italic = true })
  hl("SnacksExplorerDirHidden", { fg = c.muted, italic = true })
  hl("SnacksExplorerFileHidden", { fg = c.muted, italic = true })
  hl("SnacksExplorerDirIgnored", { fg = c.muted, italic = true })
  hl("SnacksExplorerFileIgnored", { fg = c.muted, italic = true })
  hl("SnacksExplorerPathHidden", { fg = c.muted, italic = true })
  hl("SnacksExplorerPathIgnored", { fg = c.muted, italic = true })

  -- ========================================================================
  -- blink.cmp
  -- ========================================================================
  hl("BlinkCmpMenu", { bg = c.panel, fg = c.snow })
  hl("BlinkCmpMenuBorder", { fg = c.signal, bg = c.none })
  hl("BlinkCmpMenuSelection", { fg = c.night, bg = c.ice, bold = true })
  hl("BlinkCmpLabel", { fg = c.snow })
  hl("BlinkCmpLabelMatch", { fg = c.mint, bold = true })
  hl("BlinkCmpLabelDetail", { fg = c.comment })
  hl("BlinkCmpKind", { fg = c.azure })
  hl("BlinkCmpKindFunction", { fg = c.mint })
  hl("BlinkCmpKindMethod", { fg = c.mint })
  hl("BlinkCmpKindVariable", { fg = c.snow })
  hl("BlinkCmpKindClass", { fg = c.azure })
  hl("BlinkCmpKindInterface", { fg = c.azure })
  hl("BlinkCmpKindKeyword", { fg = c.signal })
  hl("BlinkCmpKindText", { fg = c.muted })
  hl("BlinkCmpDoc", { bg = c.panel, fg = c.snow })
  hl("BlinkCmpDocBorder", { fg = c.signal, bg = c.none })
  hl("BlinkCmpSignatureHelp", { bg = c.panel, fg = c.snow })
  hl("BlinkCmpSignatureHelpBorder", { fg = c.signal, bg = c.none })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.mint, bold = true })
  hl("BlinkCmpGhostText", { fg = c.comment, italic = true })

  -- ========================================================================
  -- Which-key
  -- ========================================================================
  hl("WhichKey", { fg = c.signal })
  hl("WhichKeyDesc", { fg = c.snow })
  hl("WhichKeyGroup", { fg = c.ice, bold = true })
  hl("WhichKeySeparator", { fg = c.punct })
  hl("WhichKeyValue", { fg = c.frost })
  hl("WhichKeyBorder", { fg = c.signal, bg = c.none })
  hl("WhichKeyFloat", { bg = c.panel })

  -- ========================================================================
  -- Harpoon / trouble / aerial
  -- ========================================================================
  hl("HarpoonBorder", { fg = c.signal })
  hl("HarpoonWindow", { bg = c.panel, fg = c.snow })
  hl("HarpoonActive", { fg = c.ice, bold = true })

  hl("TroubleNormal", { bg = c.none, fg = c.snow })
  hl("TroubleFile", { fg = c.ice, bold = true })
  hl("TroubleCount", { fg = c.glow })
  hl("TroubleSource", { fg = c.muted })
  hl("TroubleSignError", { fg = c.mint })
  hl("TroubleSignWarning", { fg = c.frost })
  hl("TroubleSignInformation", { fg = c.azure })
  hl("TroubleSignHint", { fg = c.steel })

  hl("AerialLine", { bg = c.cursorline })
  hl("AerialLineNC", { fg = c.comment })
  hl("AerialGuide", { fg = c.indent })
  hl("AerialClassIcon", { fg = c.teal })
  hl("AerialFunctionIcon", { fg = c.gold })
  hl("AerialMethodIcon", { fg = c.gold })
  hl("AerialVariableIcon", { fg = c.snow })
  hl("AerialConstantIcon", { fg = c.orange })
  hl("AerialStringIcon", { fg = c.green })
  hl("AerialPropertyIcon", { fg = c.azure })

  -- ========================================================================
  -- Render-markdown
  -- ========================================================================
  hl("RenderMarkdownH1", { fg = c.glow, bold = true })
  hl("RenderMarkdownH2", { fg = c.mint, bold = true })
  hl("RenderMarkdownH3", { fg = c.frost, bold = true })
  hl("RenderMarkdownH4", { fg = c.ice, bold = true })
  hl("RenderMarkdownH5", { fg = c.azure, bold = true })
  hl("RenderMarkdownH6", { fg = c.steel, bold = true })
  hl("RenderMarkdownCode", { bg = c.panel })
  hl("RenderMarkdownCodeInline", { fg = c.frost, bg = c.panel })
  hl("RenderMarkdownQuote", { fg = c.comment, italic = true })
  hl("RenderMarkdownBullet", { fg = c.ice })
  hl("RenderMarkdownDash", { fg = c.pane_border })

  -- ========================================================================
  -- Telescope (por si algun plugin lo usa)
  -- ========================================================================
  hl("TelescopeNormal", { bg = c.panel, fg = c.snow })
  hl("TelescopeBorder", { fg = c.signal, bg = c.panel })
  hl("TelescopePromptNormal", { bg = c.panel })
  hl("TelescopePromptBorder", { fg = c.signal, bg = c.panel })
  hl("TelescopePromptTitle", { fg = c.night, bg = c.signal, bold = true })
  hl("TelescopePreviewTitle", { fg = c.night, bg = c.ice, bold = true })
  hl("TelescopeResultsTitle", { fg = c.night, bg = c.mint, bold = true })
  hl("TelescopeMatching", { fg = c.frost, bold = true })
  hl("TelescopeSelection", { bg = c.branch_bg, fg = c.ice, bold = true })

  -- ========================================================================
  -- Terminal 16 colors (for :terminal) - match ghostty §07
  -- ========================================================================
  -- ANSI con verde/rojo/amarillo REALES (antes el slot verde era azul y el
  -- rojo era rosa: ls, git, fish se veian monocromos). Mismo mapeo en ghostty.
  vim.g.terminal_color_0 = c.abyss
  vim.g.terminal_color_1 = c.coral -- red
  vim.g.terminal_color_2 = c.green -- green
  vim.g.terminal_color_3 = c.gold -- yellow
  vim.g.terminal_color_4 = c.azure -- blue
  vim.g.terminal_color_5 = c.signal -- magenta (identidad)
  vim.g.terminal_color_6 = c.teal -- cyan
  vim.g.terminal_color_7 = c.silver
  vim.g.terminal_color_8 = c.pane_active
  vim.g.terminal_color_9 = c.coral
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.gold
  vim.g.terminal_color_12 = c.azure
  vim.g.terminal_color_13 = c.glow
  vim.g.terminal_color_14 = c.teal
  vim.g.terminal_color_15 = c.snow
end

return M
