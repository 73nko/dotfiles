-- ============================================================================
-- Violet Hour · Glass
-- Ten minutes after sunset: deep indigo sky, distant violet, first stars.
-- Quiet, low-saturation, glass over chrome. Cool sets the tone.
-- Single source of truth = Style Guide v2.0 (mayo 2026).
-- ============================================================================

local M = {}

-- Palette tokens (match --* del style guide v2, data-palette="violet") --------
M.palette = {
  -- identity (orchid -> bloom)
  orchid     = "#22b8f5",  -- primary: keywords, mode, prompt
  lilac      = "#a8ecff",  -- active tab, titles, glow
  rose_mist  = "#5ff2cf",  -- cursor, functions, diagnostics
  bloom      = "#e0fbff",  -- numbers, highlight

  -- structure (periwinkle -> cyan_mist)
  periwinkle = "#5f9bd8",  -- branch, session, position
  ice        = "#7fe0ff",  -- active window, strings
  cyan_mist  = "#b9e0ff",  -- types, namespaces, keys
  skyline    = "#0a3e57",  -- on-ice text, shadow hint

  -- ground (sky behind glass)
  abyss   = "#04141c",
  night   = "#062230",
  indigo  = "#0d3547",
  violet  = "#174b60",
  mauve   = "#2e6b83",
  dawn    = "#7fb5c4",
  horizon = "#cfe6e4",

  -- foreground
  star   = "#f3faf7",  -- default fg
  silver = "#c3d9d6",  -- muted fg base

  -- Espectro de alta legibilidad (rediseno 2026-06). Sobre el lienzo dusk:
  -- los fondos siguen siendo Violet Hour, el TEXTO gana rango cromatico.
  -- Tokens NUEVOS; no pisan los de chrome (orchid/ice/etc.) que leen
  -- lualine/bufferline/tmux, asi que la barra de estado no cambia.
  gold   = "#ffd873",  -- functions / methods
  teal   = "#5ff2cf",  -- types / namespaces / classes
  green  = "#8fdc8f",  -- strings
  orange = "#ffd873",  -- numbers / constants
  coral  = "#ff7a6e",  -- booleans / git delete
  azure  = "#b8f1ff",  -- properties / fields

  -- blended (rgba aproximado sobre night #062230)
  panel       = "#0d3547", -- raised surface (floats, menus) = indigo
  cursorline  = "#0b2d3d", -- rgba(ice,.06)
  selection   = "#0f526f", -- rgba(orchid,.22)
  indent      = "#0e3244", -- rgba(ice,.10)
  linenr      = "#1d5064", -- rgba(ice,.30)  gutter
  comment     = "#559eb7", -- lifted 2026-06: era #438198 (50%), poco legible
  punct       = "#5b747b", -- rgba(silver,.45)
  muted       = "#839b9e", -- rgba(silver,.58)
  pane_border = "#113e51", -- rgba(orchid,.12)
  pane_active = "#498aa2", -- rgba(ice,.35)
  branch_bg   = "#214c5e", -- rgba(ice,.22)
  diag_bg     = "#15455a", -- rgba(rose_mist,.18)
  search_bg   = "#143f4f", -- rgba(bloom,.14)

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
  vim.o.background    = "dark"
  vim.g.colors_name   = "violet-hour"

  local c    = M.palette
  local hl   = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end
  local link = function(from, to) vim.api.nvim_set_hl(0, from, { link = to }) end

  -- ========================================================================
  -- Editor chrome - glass: backgrounds NONE, el wallpaper sangra
  -- ========================================================================
  hl("Normal",       { fg = c.star, bg = c.none })
  hl("NormalNC",     { fg = c.star, bg = c.none })
  hl("NormalFloat",  { fg = c.star, bg = c.none })
  hl("FloatBorder",  { fg = c.orchid, bg = c.none })
  hl("FloatTitle",   { fg = c.lilac, bold = true })
  hl("WinSeparator", { fg = c.pane_border, bg = c.none })
  hl("VertSplit",    { fg = c.pane_border, bg = c.none })
  hl("SignColumn",   { fg = c.muted, bg = c.none })
  hl("FoldColumn",   { fg = c.periwinkle, bg = c.none })
  hl("Folded",       { fg = c.periwinkle, bg = c.panel })
  hl("EndOfBuffer",  { fg = c.night })
  hl("MsgArea",      { fg = c.star })
  hl("ModeMsg",      { fg = c.lilac, bold = true })
  hl("MoreMsg",      { fg = c.ice })
  hl("ErrorMsg",     { fg = c.rose_mist, bold = true })
  hl("WarningMsg",   { fg = c.bloom })

  hl("Cursor",       { fg = c.night, bg = c.rose_mist })
  hl("lCursor",      { fg = c.night, bg = c.rose_mist })
  hl("CursorLine",   { bg = c.cursorline })
  hl("CursorColumn", { bg = c.cursorline })
  hl("ColorColumn",  { bg = c.panel })
  hl("CursorLineNr", { fg = c.rose_mist, bold = true })
  hl("LineNr",       { fg = c.linenr })

  hl("Visual",    { bg = c.selection })
  hl("VisualNOS", { bg = c.selection })

  hl("Search",    { fg = c.bloom, bg = c.search_bg })
  hl("IncSearch", { fg = c.night, bg = c.bloom, bold = true })
  hl("CurSearch", { fg = c.night, bg = c.bloom, bold = true })
  hl("MatchParen",{ fg = c.rose_mist, bg = c.none, bold = true, underline = true })

  hl("Pmenu",      { fg = c.star, bg = c.panel })
  hl("PmenuSel",   { fg = c.night, bg = c.ice, bold = true })
  hl("PmenuSbar",  { bg = c.panel })
  hl("PmenuThumb", { bg = c.periwinkle })
  hl("WildMenu",   { fg = c.night, bg = c.orchid })

  hl("QuickFixLine", { bg = c.branch_bg })
  hl("SpellBad",   { sp = c.rose_mist, undercurl = true })
  hl("SpellCap",   { sp = c.bloom, undercurl = true })
  hl("SpellRare",  { sp = c.cyan_mist, undercurl = true })
  hl("SpellLocal", { sp = c.ice, undercurl = true })

  -- Status / tabline - lualine/bufferline pintan el resto
  hl("StatusLine",   { fg = c.star,  bg = c.panel })
  hl("StatusLineNC", { fg = c.muted, bg = c.panel })
  hl("TabLine",      { fg = c.muted, bg = c.night })
  hl("TabLineFill",  { bg = c.night })
  hl("TabLineSel",   { fg = c.ice, bg = c.branch_bg, bold = true })

  hl("Title",      { fg = c.lilac, bold = true })
  hl("Directory",  { fg = c.ice, bold = true })
  hl("Conceal",    { fg = c.comment })
  hl("NonText",    { fg = c.indent })
  hl("Whitespace", { fg = c.indent })
  hl("SpecialKey", { fg = c.orchid })

  -- ========================================================================
  -- Syntax (legacy vim groups) - tree-sitter hace el resto
  -- ========================================================================
  hl("Comment",   { fg = c.comment, italic = true })
  hl("Constant",  { fg = c.orange })
  hl("String",    { fg = c.green })
  hl("Character", { fg = c.green })
  hl("Number",    { fg = c.orange })
  hl("Boolean",   { fg = c.coral })
  hl("Float",     { fg = c.orange })

  hl("Identifier", { fg = c.star })
  hl("Function",   { fg = c.gold })

  hl("Statement",   { fg = c.orchid })
  hl("Conditional", { fg = c.orchid })
  hl("Repeat",      { fg = c.orchid })
  hl("Label",       { fg = c.orchid })
  hl("Operator",    { fg = c.orchid })
  hl("Keyword",     { fg = c.orchid })
  hl("Exception",   { fg = c.orchid })

  hl("PreProc",   { fg = c.lilac })
  hl("Include",   { fg = c.orchid })
  hl("Define",    { fg = c.orchid })
  hl("Macro",     { fg = c.lilac })
  hl("PreCondit", { fg = c.orchid })

  hl("Type",         { fg = c.teal })
  hl("StorageClass", { fg = c.orchid })
  hl("Structure",    { fg = c.teal })
  hl("Typedef",      { fg = c.teal })

  hl("Special",        { fg = c.rose_mist })
  hl("SpecialChar",    { fg = c.rose_mist })
  hl("Tag",            { fg = c.orchid })
  hl("Delimiter",      { fg = c.punct })
  hl("SpecialComment", { fg = c.ice })
  hl("Debug",          { fg = c.rose_mist })

  hl("Underlined", { fg = c.ice, underline = true })
  hl("Ignore",     { fg = c.muted })
  hl("Error",      { fg = c.rose_mist, bold = true })
  hl("Todo",       { fg = c.bloom, bold = true })

  -- ========================================================================
  -- Tree-sitter captures (contrato §05 del style guide v2)
  -- Sin bold en keywords: el color hace el trabajo.
  -- ========================================================================
  -- Keywords / operators / conditionals -> Orchid
  local kw = { fg = c.orchid }
  hl("@keyword",             kw)
  hl("@keyword.function",    kw)
  hl("@keyword.return",      kw)
  hl("@keyword.operator",    kw)
  hl("@keyword.import",      kw)
  hl("@keyword.conditional", kw)
  hl("@keyword.repeat",      kw)
  hl("@keyword.exception",   kw)
  hl("@keyword.storage",     kw)
  hl("@keyword.directive",   kw)
  hl("@keyword.coroutine",   kw)
  hl("@operator",            kw)
  hl("@conditional",         kw)
  hl("@repeat",              kw)
  hl("@exception",           kw)
  hl("@include",             kw)

  -- Functions / constructors -> Gold (acento calido, alto contraste)
  local fn = { fg = c.gold }
  hl("@function",             fn)
  hl("@function.call",        fn)
  hl("@function.builtin",     fn)
  hl("@function.method",      fn)
  hl("@function.method.call", fn)
  hl("@function.macro",       fn)
  hl("@constructor",          fn)
  hl("@method",               fn)
  hl("@method.call",          fn)

  -- Strings -> Green
  hl("@string",         { fg = c.green })
  hl("@string.regex",   { fg = c.green })
  hl("@string.regexp",  { fg = c.green })
  hl("@string.escape",  { fg = c.coral })
  hl("@string.special", { fg = c.teal })

  -- Types / namespaces -> Teal
  hl("@type",            { fg = c.teal })
  hl("@type.builtin",    { fg = c.teal, italic = true })
  hl("@type.definition", { fg = c.teal, bold = true })
  hl("@namespace",       { fg = c.teal })
  hl("@module",          { fg = c.teal })
  hl("@class",           { fg = c.teal })

  -- Numbers / constants -> Orange ; booleans -> Coral
  hl("@number",           { fg = c.orange })
  hl("@float",            { fg = c.orange })
  hl("@boolean",          { fg = c.coral })
  hl("@constant",         { fg = c.orange })
  hl("@constant.builtin", { fg = c.orange, italic = true })
  hl("@constant.macro",   { fg = c.orange })

  -- Properties / fields -> Azure (azul, distinto de keywords y variables)
  hl("@property",      { fg = c.azure })
  hl("@field",         { fg = c.azure })
  hl("@tag",           { fg = c.orchid })
  hl("@tag.builtin",   { fg = c.lilac })
  hl("@tag.delimiter", { fg = c.punct })

  -- Atributos JSX/HTML -> Rose Mist + italic. Color RESERVADO solo para esto
  -- (ningun otro token lo usa tras mover funciones a dorado), para que el
  -- nombre de la prop nunca se confunda con su valor (var blanco / fn dorado /
  -- string verde). La cursiva es una segunda señal ademas del hue.
  -- Se cubren todos los captures plausibles segun version del parser tsx.
  local attr = { fg = c.rose_mist, italic = true }
  hl("@tag.attribute", attr)
  hl("@attribute",     attr)

  -- Variables / parameters -> Star (default fg, la base calmada)
  hl("@variable",           { fg = c.star })
  hl("@variable.builtin",   { fg = c.star, italic = true })
  hl("@variable.parameter", { fg = c.star })
  hl("@variable.member",    { fg = c.azure })
  hl("@parameter",          { fg = c.star })

  -- Comments -> Ice 50%, italic
  hl("@comment",               { fg = c.comment, italic = true })
  hl("@comment.documentation", { fg = c.teal, italic = true })
  hl("@comment.todo",          { fg = c.bloom, bold = true })
  hl("@comment.note",          { fg = c.ice, bold = true })
  hl("@comment.warning",       { fg = c.bloom, bold = true })
  hl("@comment.error",         { fg = c.rose_mist, bold = true })

  -- Punctuation -> Silver 45%
  hl("@punctuation",           { fg = c.punct })
  hl("@punctuation.delimiter", { fg = c.punct })
  hl("@punctuation.bracket",   { fg = c.punct })
  hl("@punctuation.special",   { fg = c.rose_mist })

  -- Text formatting (markdown, etc.)
  hl("@markup.heading",       { fg = c.lilac, bold = true })
  hl("@markup.heading.1",     { fg = c.lilac, bold = true })
  hl("@markup.heading.2",     { fg = c.rose_mist, bold = true })
  hl("@markup.heading.3",     { fg = c.bloom, bold = true })
  hl("@markup.heading.4",     { fg = c.ice, bold = true })
  hl("@markup.heading.5",     { fg = c.cyan_mist, bold = true })
  hl("@markup.heading.6",     { fg = c.periwinkle, bold = true })
  hl("@markup.strong",        { fg = c.lilac, bold = true })
  hl("@markup.italic",        { fg = c.bloom, italic = true })
  hl("@markup.underline",     { fg = c.ice, underline = true })
  hl("@markup.strikethrough", { fg = c.muted, strikethrough = true })
  hl("@markup.link",          { fg = c.ice, underline = true })
  hl("@markup.link.label",    { fg = c.orchid })
  hl("@markup.link.url",      { fg = c.cyan_mist, underline = true })
  hl("@markup.raw",           { fg = c.bloom, bg = c.panel })
  hl("@markup.quote",         { fg = c.comment, italic = true })
  hl("@markup.list",          { fg = c.ice })

  -- JSX / HTML / CSS
  hl("@tag.tsx",           { fg = c.orchid })
  hl("@tag.jsx",           { fg = c.orchid })
  hl("@tag.attribute.tsx", attr)
  hl("@tag.attribute.jsx", attr)
  hl("@attribute.tsx",     attr)
  hl("@attribute.jsx",     attr)
  hl("@property.css",      { fg = c.azure })
  hl("@type.css",          { fg = c.teal })
  hl("@number.css",        { fg = c.orange })
  hl("@string.css",        { fg = c.green })

  -- ========================================================================
  -- LSP semantic tokens
  -- ========================================================================
  link("@lsp.type.class",         "@type")
  link("@lsp.type.comment",       "@comment")
  link("@lsp.type.enum",          "@type")
  link("@lsp.type.enumMember",    "@constant")
  link("@lsp.type.function",      "@function")
  link("@lsp.type.interface",     "@type")
  link("@lsp.type.keyword",       "@keyword")
  link("@lsp.type.macro",         "@function.macro")
  link("@lsp.type.method",        "@function.method")
  link("@lsp.type.namespace",     "@namespace")
  link("@lsp.type.parameter",     "@variable.parameter")
  link("@lsp.type.property",      "@property")
  link("@lsp.type.struct",        "@type")
  link("@lsp.type.type",          "@type")
  link("@lsp.type.typeParameter", "@type")
  link("@lsp.type.variable",      "@variable")
  hl("@lsp.mod.readonly",   { fg = c.orange })
  hl("@lsp.mod.deprecated", { strikethrough = true, fg = c.muted })

  -- ========================================================================
  -- Diagnostics - underline only, sin sign column fill (§05)
  -- err Rose Mist / warn Bloom / info Cyan Mist / hint Periwinkle
  -- ========================================================================
  hl("DiagnosticError", { fg = c.rose_mist })
  hl("DiagnosticWarn",  { fg = c.bloom })
  hl("DiagnosticInfo",  { fg = c.cyan_mist })
  hl("DiagnosticHint",  { fg = c.periwinkle })
  hl("DiagnosticOk",    { fg = c.ice })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.rose_mist })
  hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.bloom })
  hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.cyan_mist })
  hl("DiagnosticUnderlineHint",  { undercurl = true, sp = c.periwinkle })
  hl("DiagnosticSignError", { fg = c.rose_mist, bg = c.none })
  hl("DiagnosticSignWarn",  { fg = c.bloom, bg = c.none })
  hl("DiagnosticSignInfo",  { fg = c.cyan_mist, bg = c.none })
  hl("DiagnosticSignHint",  { fg = c.periwinkle, bg = c.none })
  hl("DiagnosticVirtualTextError", { fg = c.rose_mist, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextWarn",  { fg = c.bloom, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextInfo",  { fg = c.cyan_mist, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextHint",  { fg = c.periwinkle, bg = c.none, italic = true })

  -- ========================================================================
  -- LSP references / lens
  -- ========================================================================
  hl("LspReferenceText",  { bg = c.cursorline })
  hl("LspReferenceRead",  { bg = c.cursorline })
  hl("LspReferenceWrite", { bg = c.selection })
  hl("LspCodeLens",          { fg = c.comment, italic = true })
  hl("LspCodeLensSeparator", { fg = c.comment })
  hl("LspSignatureActiveParameter", { fg = c.rose_mist, bold = true })
  hl("LspInlayHint", { fg = c.comment, italic = true, bg = c.none })

  -- ========================================================================
  -- Diff / git - add Ice / del Orchid / change Bloom (§05)
  -- ========================================================================
  hl("DiffAdd",    { fg = c.green, bg = c.none })
  hl("DiffChange", { fg = c.orange, bg = c.none })
  hl("DiffDelete", { fg = c.coral, bg = c.none })
  hl("DiffText",   { fg = c.orange, bg = c.panel, bold = true })
  hl("diffAdded",   { fg = c.green })
  hl("diffRemoved", { fg = c.coral })
  hl("diffChanged", { fg = c.orange })
  hl("diffFile",    { fg = c.lilac, bold = true })
  hl("diffNewFile", { fg = c.green, bold = true })
  hl("diffLine",    { fg = c.teal })

  hl("GitSignsAdd",    { fg = c.green })
  hl("GitSignsChange", { fg = c.orange })
  hl("GitSignsDelete", { fg = c.coral })
  hl("GitSignsCurrentLineBlame", { fg = c.comment, italic = true })

  -- ========================================================================
  -- Treesitter context (sticky)
  -- ========================================================================
  hl("TreesitterContext",           { bg = c.panel })
  hl("TreesitterContextLineNumber", { fg = c.rose_mist, bg = c.panel })
  hl("TreesitterContextBottom",     { sp = c.orchid, underline = true })

  -- ========================================================================
  -- Indent guides - ice 10%, barely visible
  -- ========================================================================
  hl("IblIndent",     { fg = c.indent, bg = c.none })
  hl("IblScope",      { fg = c.periwinkle, bg = c.none })
  hl("IblWhitespace", { fg = c.indent })
  hl("SnacksIndent",      { fg = c.indent })
  hl("SnacksIndentScope", { fg = c.periwinkle })
  hl("SnacksIndentChunk", { fg = c.periwinkle })

  -- ========================================================================
  -- Snacks - picker, explorer, notifier, dashboard
  -- ========================================================================
  hl("SnacksPickerTitle",      { fg = c.lilac, bold = true })
  hl("SnacksPickerBorder",     { fg = c.orchid })
  hl("SnacksPickerMatch",      { fg = c.rose_mist, bold = true })
  hl("SnacksPickerDir",        { fg = c.ice })
  hl("SnacksPickerFile",       { fg = c.star })
  hl("SnacksPickerPrompt",     { fg = c.orchid, bold = true })
  hl("SnacksPickerCursorLine", { bg = c.branch_bg })
  hl("SnacksPickerSelected",   { fg = c.ice, bold = true })
  hl("SnacksPickerList",      { bg = c.none })
  hl("SnacksPickerListNC",    { bg = c.none })
  hl("SnacksPickerPreview",   { bg = c.none })
  hl("SnacksPickerPreviewNC", { bg = c.none })
  hl("SnacksPickerInput",     { bg = c.none })
  hl("SnacksPickerInputNC",   { bg = c.none })
  hl("SnacksPickerBox",       { bg = c.none })

  hl("SnacksDashboardTitle",    { fg = c.lilac, bold = true })
  hl("SnacksDashboardHeader",   { fg = c.lilac, bold = true })
  hl("SnacksDashboardDesc",     { fg = c.star })
  hl("SnacksDashboardIcon",     { fg = c.rose_mist })
  hl("SnacksDashboardKey",      { fg = c.ice })
  hl("SnacksDashboardTerminal", { fg = c.orchid })
  hl("SnacksDashboardFooter",   { fg = c.comment })

  hl("SnacksNotifierInfo",    { fg = c.cyan_mist })
  hl("SnacksNotifierWarn",    { fg = c.bloom })
  hl("SnacksNotifierError",   { fg = c.rose_mist })
  hl("SnacksNotifierDebug",   { fg = c.ice })
  hl("SnacksNotifierTrace",   { fg = c.comment })
  hl("SnacksNotifierHistory", { bg = c.panel })

  hl("SnacksWordsCurrent", { bg = c.selection, bold = true })
  hl("SnacksWords",        { bg = c.cursorline })

  -- Explorer
  hl("SnacksExplorerDir",      { fg = c.ice, bold = true })
  hl("SnacksExplorerFile",     { fg = c.star })
  hl("SnacksExplorerIcon",     { fg = c.rose_mist })
  hl("SnacksExplorerRootName", { fg = c.lilac, bold = true })

  -- Hidden / ignored / dimmed entries -> muted, italic
  hl("SnacksPickerDimmed",        { fg = c.muted })
  hl("SnacksPickerDirHidden",     { fg = c.muted, italic = true })
  hl("SnacksPickerFileHidden",    { fg = c.muted, italic = true })
  hl("SnacksPickerDirIgnored",    { fg = c.muted, italic = true })
  hl("SnacksPickerFileIgnored",   { fg = c.muted, italic = true })
  hl("SnacksPickerPathHidden",    { fg = c.muted, italic = true })
  hl("SnacksPickerPathIgnored",   { fg = c.muted, italic = true })
  hl("SnacksExplorerDirHidden",   { fg = c.muted, italic = true })
  hl("SnacksExplorerFileHidden",  { fg = c.muted, italic = true })
  hl("SnacksExplorerDirIgnored",  { fg = c.muted, italic = true })
  hl("SnacksExplorerFileIgnored", { fg = c.muted, italic = true })
  hl("SnacksExplorerPathHidden",  { fg = c.muted, italic = true })
  hl("SnacksExplorerPathIgnored", { fg = c.muted, italic = true })

  -- ========================================================================
  -- blink.cmp
  -- ========================================================================
  hl("BlinkCmpMenu",          { bg = c.panel, fg = c.star })
  hl("BlinkCmpMenuBorder",    { fg = c.orchid, bg = c.none })
  hl("BlinkCmpMenuSelection", { fg = c.night, bg = c.ice, bold = true })
  hl("BlinkCmpLabel",         { fg = c.star })
  hl("BlinkCmpLabelMatch",    { fg = c.rose_mist, bold = true })
  hl("BlinkCmpLabelDetail",   { fg = c.comment })
  hl("BlinkCmpKind",          { fg = c.cyan_mist })
  hl("BlinkCmpKindFunction",  { fg = c.rose_mist })
  hl("BlinkCmpKindMethod",    { fg = c.rose_mist })
  hl("BlinkCmpKindVariable",  { fg = c.star })
  hl("BlinkCmpKindClass",     { fg = c.cyan_mist })
  hl("BlinkCmpKindInterface", { fg = c.cyan_mist })
  hl("BlinkCmpKindKeyword",   { fg = c.orchid })
  hl("BlinkCmpKindText",      { fg = c.muted })
  hl("BlinkCmpDoc",           { bg = c.panel, fg = c.star })
  hl("BlinkCmpDocBorder",     { fg = c.orchid, bg = c.none })
  hl("BlinkCmpSignatureHelp", { bg = c.panel, fg = c.star })
  hl("BlinkCmpSignatureHelpBorder",          { fg = c.orchid, bg = c.none })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.rose_mist, bold = true })
  hl("BlinkCmpGhostText", { fg = c.comment, italic = true })

  -- ========================================================================
  -- Which-key
  -- ========================================================================
  hl("WhichKey",          { fg = c.orchid })
  hl("WhichKeyDesc",      { fg = c.star })
  hl("WhichKeyGroup",     { fg = c.ice, bold = true })
  hl("WhichKeySeparator", { fg = c.punct })
  hl("WhichKeyValue",     { fg = c.bloom })
  hl("WhichKeyBorder",    { fg = c.orchid, bg = c.none })
  hl("WhichKeyFloat",     { bg = c.panel })

  -- ========================================================================
  -- Harpoon / trouble / aerial
  -- ========================================================================
  hl("HarpoonBorder", { fg = c.orchid })
  hl("HarpoonWindow", { bg = c.panel, fg = c.star })
  hl("HarpoonActive", { fg = c.ice, bold = true })

  hl("TroubleNormal",          { bg = c.none, fg = c.star })
  hl("TroubleFile",            { fg = c.ice, bold = true })
  hl("TroubleCount",           { fg = c.lilac })
  hl("TroubleSource",          { fg = c.muted })
  hl("TroubleSignError",       { fg = c.rose_mist })
  hl("TroubleSignWarning",     { fg = c.bloom })
  hl("TroubleSignInformation", { fg = c.cyan_mist })
  hl("TroubleSignHint",        { fg = c.periwinkle })

  hl("AerialLine",         { bg = c.cursorline })
  hl("AerialLineNC",       { fg = c.comment })
  hl("AerialGuide",        { fg = c.indent })
  hl("AerialClassIcon",    { fg = c.teal })
  hl("AerialFunctionIcon", { fg = c.gold })
  hl("AerialMethodIcon",   { fg = c.gold })
  hl("AerialVariableIcon", { fg = c.star })
  hl("AerialConstantIcon", { fg = c.orange })
  hl("AerialStringIcon",   { fg = c.green })
  hl("AerialPropertyIcon", { fg = c.azure })

  -- ========================================================================
  -- Render-markdown
  -- ========================================================================
  hl("RenderMarkdownH1",         { fg = c.lilac, bold = true })
  hl("RenderMarkdownH2",         { fg = c.rose_mist, bold = true })
  hl("RenderMarkdownH3",         { fg = c.bloom, bold = true })
  hl("RenderMarkdownH4",         { fg = c.ice, bold = true })
  hl("RenderMarkdownH5",         { fg = c.cyan_mist, bold = true })
  hl("RenderMarkdownH6",         { fg = c.periwinkle, bold = true })
  hl("RenderMarkdownCode",       { bg = c.panel })
  hl("RenderMarkdownCodeInline", { fg = c.bloom, bg = c.panel })
  hl("RenderMarkdownQuote",      { fg = c.comment, italic = true })
  hl("RenderMarkdownBullet",     { fg = c.ice })
  hl("RenderMarkdownDash",       { fg = c.pane_border })

  -- ========================================================================
  -- Telescope (por si algun plugin lo usa)
  -- ========================================================================
  hl("TelescopeNormal",       { bg = c.panel, fg = c.star })
  hl("TelescopeBorder",       { fg = c.orchid, bg = c.panel })
  hl("TelescopePromptNormal", { bg = c.panel })
  hl("TelescopePromptBorder", { fg = c.orchid, bg = c.panel })
  hl("TelescopePromptTitle",  { fg = c.night, bg = c.orchid, bold = true })
  hl("TelescopePreviewTitle", { fg = c.night, bg = c.ice, bold = true })
  hl("TelescopeResultsTitle", { fg = c.night, bg = c.rose_mist, bold = true })
  hl("TelescopeMatching",     { fg = c.bloom, bold = true })
  hl("TelescopeSelection",    { bg = c.branch_bg, fg = c.ice, bold = true })

  -- ========================================================================
  -- Terminal 16 colors (for :terminal) - match ghostty §07
  -- ========================================================================
  -- ANSI con verde/rojo/amarillo REALES (antes el slot verde era azul y el
  -- rojo era rosa: ls, git, fish se veian monocromos). Mismo mapeo en ghostty.
  vim.g.terminal_color_0  = c.abyss
  vim.g.terminal_color_1  = c.coral   -- red
  vim.g.terminal_color_2  = c.green   -- green
  vim.g.terminal_color_3  = c.gold    -- yellow
  vim.g.terminal_color_4  = c.azure   -- blue
  vim.g.terminal_color_5  = c.orchid  -- magenta (identidad)
  vim.g.terminal_color_6  = c.teal    -- cyan
  vim.g.terminal_color_7  = c.silver
  vim.g.terminal_color_8  = c.pane_active
  vim.g.terminal_color_9  = c.coral
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.gold
  vim.g.terminal_color_12 = c.azure
  vim.g.terminal_color_13 = c.lilac
  vim.g.terminal_color_14 = c.teal
  vim.g.terminal_color_15 = c.star
end

return M
