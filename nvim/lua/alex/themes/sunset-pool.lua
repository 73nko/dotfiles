-- ============================================================================
-- Sunset · Pool Splash
-- Miami-sunset warmth + turquoise pool counterweight.
-- Single source of truth = Style Guide v1.0 (abril 2026).
-- ============================================================================

local M = {}

-- Palette tokens (match --sp-* en el style guide) -----------------------------
M.palette = {
  -- warm / identity
  magenta     = "#FF3D8A",
  magenta_hi  = "#FFB8D5",
  tangerine   = "#FF8A3D",
  peach       = "#FFB07A",
  gold        = "#FFD67A",

  -- cool / structure
  turquoise    = "#4EC9D7",
  turquoise_hi = "#7FE0EB",
  aqua         = "#8FE3E8",
  deep_pool    = "#0D4858",

  -- ground
  dusk     = "#1A0A28",
  plum     = "#3A1550",
  wine     = "#6A2050",
  sunburn  = "#C95A4A",
  sunsoft  = "#F2A070",
  rosegold = "#FFC6A0",
  cream    = "#F5ECD7",

  -- blended (rgba aproximado sobre dusk)
  bg_alt       = "#1E0A2E", -- sp-bg alpha blended
  cursorline   = "#11222E", -- rgba(127,224,235,.06) sobre dusk
  selection    = "#4B1637", -- rgba(255,61,138,.22) sobre dusk
  indent       = "#1B2F3A", -- rgba(127,224,235,.12) sobre dusk
  comment      = "#3E9AA5", -- rgba(127,224,235,.55) clamped
  punct        = "#A6826F", -- rgba(255,198,160,.55) clamped
  muted        = "#A58670", -- rgba(255,198,160,.60) clamped
  pane_border  = "#331127", -- rgba(255,61,138,.12) sobre dusk
  pane_active  = "#2E5260", -- rgba(127,224,235,.35) sobre dusk
  branch_bg    = "#1F3E48", -- rgba(127,224,235,.2) sobre dusk
  diag_bg      = "#402418", -- rgba(255,138,61,.18) sobre dusk

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

  vim.o.termguicolors   = true
  vim.o.background      = "dark"
  vim.g.colors_name     = "sunset-pool"

  local c   = M.palette
  local hl  = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end
  local link = function(from, to) vim.api.nvim_set_hl(0, from, { link = to }) end

  -- ========================================================================
  -- Editor chrome
  -- ========================================================================
  hl("Normal",            { fg = c.rosegold, bg = c.none })
  hl("NormalNC",          { fg = c.rosegold, bg = c.none })
  hl("NormalFloat",       { fg = c.rosegold, bg = c.none })
  hl("FloatBorder",       { fg = c.magenta,  bg = c.none })
  hl("FloatTitle",        { fg = c.magenta_hi, bold = true })
  hl("WinSeparator",      { fg = c.pane_border, bg = c.none })
  hl("VertSplit",         { fg = c.pane_border, bg = c.none })
  hl("SignColumn",        { fg = c.muted, bg = c.none })
  hl("FoldColumn",        { fg = c.turquoise, bg = c.none })
  hl("Folded",            { fg = c.turquoise, bg = c.plum })
  hl("EndOfBuffer",       { fg = c.dusk })
  hl("MsgArea",           { fg = c.rosegold })
  hl("ModeMsg",           { fg = c.magenta_hi, bold = true })
  hl("MoreMsg",           { fg = c.turquoise_hi })
  hl("ErrorMsg",          { fg = c.magenta, bold = true })
  hl("WarningMsg",        { fg = c.tangerine })

  hl("Cursor",            { fg = c.dusk, bg = c.tangerine })
  hl("lCursor",           { fg = c.dusk, bg = c.tangerine })
  hl("CursorLine",        { bg = c.cursorline })
  hl("CursorColumn",      { bg = c.cursorline })
  hl("ColorColumn",       { bg = c.plum })
  hl("CursorLineNr",      { fg = c.tangerine, bold = true })
  hl("LineNr",            { fg = c.indent })

  hl("Visual",            { bg = c.selection })
  hl("VisualNOS",         { bg = c.selection })

  hl("Search",            { fg = c.gold, bg = "#3E2E0F" })
  hl("IncSearch",         { fg = c.dusk, bg = c.gold, bold = true })
  hl("CurSearch",         { fg = c.dusk, bg = c.gold, bold = true })
  hl("MatchParen",        { fg = c.tangerine, bg = c.none, bold = true, underline = true })

  hl("Pmenu",             { fg = c.rosegold, bg = c.plum })
  hl("PmenuSel",          { fg = c.dusk, bg = c.turquoise_hi, bold = true })
  hl("PmenuSbar",         { bg = c.plum })
  hl("PmenuThumb",        { bg = c.turquoise })
  hl("WildMenu",          { fg = c.dusk, bg = c.magenta })

  hl("QuickFixLine",      { bg = c.branch_bg })
  hl("SpellBad",          { sp = c.magenta, undercurl = true })
  hl("SpellCap",          { sp = c.tangerine, undercurl = true })
  hl("SpellRare",         { sp = c.aqua, undercurl = true })
  hl("SpellLocal",        { sp = c.turquoise_hi, undercurl = true })

  -- Status / tabline se tintan desde lualine/bufferline; minimos aqui.
  hl("StatusLine",        { fg = c.rosegold, bg = c.plum })
  hl("StatusLineNC",      { fg = c.muted,    bg = c.plum })
  hl("TabLine",           { fg = c.muted,    bg = c.dusk })
  hl("TabLineFill",       { bg = c.dusk })
  hl("TabLineSel",        { fg = c.turquoise_hi, bg = c.branch_bg, bold = true })

  hl("Title",             { fg = c.magenta_hi, bold = true })
  hl("Directory",         { fg = c.turquoise_hi, bold = true })
  hl("Conceal",           { fg = c.comment })
  hl("NonText",           { fg = c.indent })
  hl("Whitespace",        { fg = c.indent })
  hl("SpecialKey",        { fg = c.magenta })

  -- ========================================================================
  -- Syntax (legacy vim groups) - minimos, tree-sitter hace el resto
  -- ========================================================================
  hl("Comment",           { fg = c.comment, italic = true })
  hl("Constant",          { fg = c.gold })
  hl("String",            { fg = c.turquoise_hi })
  hl("Character",         { fg = c.turquoise_hi })
  hl("Number",            { fg = c.gold })
  hl("Boolean",           { fg = c.gold })
  hl("Float",             { fg = c.gold })

  hl("Identifier",        { fg = c.rosegold })
  hl("Function",          { fg = c.tangerine })

  hl("Statement",         { fg = c.magenta })
  hl("Conditional",       { fg = c.magenta })
  hl("Repeat",            { fg = c.magenta })
  hl("Label",             { fg = c.magenta })
  hl("Operator",          { fg = c.magenta })
  hl("Keyword",           { fg = c.magenta })
  hl("Exception",         { fg = c.magenta })

  hl("PreProc",           { fg = c.magenta_hi })
  hl("Include",           { fg = c.magenta })
  hl("Define",            { fg = c.magenta })
  hl("Macro",             { fg = c.magenta_hi })
  hl("PreCondit",         { fg = c.magenta })

  hl("Type",              { fg = c.aqua })
  hl("StorageClass",      { fg = c.magenta })
  hl("Structure",         { fg = c.aqua })
  hl("Typedef",           { fg = c.aqua })

  hl("Special",           { fg = c.tangerine })
  hl("SpecialChar",       { fg = c.tangerine })
  hl("Tag",               { fg = c.magenta })
  hl("Delimiter",         { fg = c.punct })
  hl("SpecialComment",    { fg = c.turquoise_hi })
  hl("Debug",             { fg = c.tangerine })

  hl("Underlined",        { fg = c.turquoise_hi, underline = true })
  hl("Ignore",            { fg = c.muted })
  hl("Error",             { fg = c.magenta, bold = true })
  hl("Todo",              { fg = c.gold, bold = true })

  -- ========================================================================
  -- Tree-sitter captures (contrato §04 del style guide)
  -- ========================================================================
  -- Keywords / operators / conditionals -> Magenta
  local kw = { fg = c.magenta }
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

  -- Functions / constructors -> Tangerine
  local fn = { fg = c.tangerine }
  hl("@function",              fn)
  hl("@function.call",         fn)
  hl("@function.builtin",      fn)
  hl("@function.method",       fn)
  hl("@function.method.call",  fn)
  hl("@function.macro",        fn)
  hl("@constructor",           fn)
  hl("@method",                fn)
  hl("@method.call",           fn)

  -- Strings -> Turquoise Hi
  hl("@string",         { fg = c.turquoise_hi })
  hl("@string.regex",   { fg = c.turquoise_hi })
  hl("@string.regexp",  { fg = c.turquoise_hi })
  hl("@string.escape",  { fg = c.tangerine })
  hl("@string.special", { fg = c.aqua })

  -- Types / namespaces -> Aqua
  hl("@type",            { fg = c.aqua })
  hl("@type.builtin",    { fg = c.aqua, italic = true })
  hl("@type.definition", { fg = c.aqua, bold = true })
  hl("@namespace",       { fg = c.aqua })
  hl("@module",          { fg = c.aqua })
  hl("@class",           { fg = c.aqua })

  -- Numbers / booleans / constants -> Gold
  hl("@number",           { fg = c.gold })
  hl("@float",            { fg = c.gold })
  hl("@boolean",          { fg = c.gold })
  hl("@constant",         { fg = c.gold })
  hl("@constant.builtin", { fg = c.gold, italic = true })
  hl("@constant.macro",   { fg = c.gold })

  -- Properties / fields / tags -> Magenta (intencional per §04)
  hl("@property",       { fg = c.magenta })
  hl("@field",          { fg = c.magenta })
  hl("@tag",            { fg = c.magenta })
  hl("@tag.builtin",    { fg = c.magenta_hi })
  hl("@tag.attribute",  { fg = c.tangerine })
  hl("@tag.delimiter",  { fg = c.punct })

  -- Variables / parameters -> Rosegold
  hl("@variable",           { fg = c.rosegold })
  hl("@variable.builtin",   { fg = c.rosegold, italic = true })
  hl("@variable.parameter", { fg = c.rosegold })
  hl("@variable.member",    { fg = c.magenta })
  hl("@parameter",          { fg = c.rosegold })

  -- Comments -> Turquoise al 55%, italic
  hl("@comment",             { fg = c.comment, italic = true })
  hl("@comment.documentation", { fg = c.aqua, italic = true })
  hl("@comment.todo",        { fg = c.gold, bold = true })
  hl("@comment.note",        { fg = c.turquoise_hi, bold = true })
  hl("@comment.warning",     { fg = c.tangerine, bold = true })
  hl("@comment.error",       { fg = c.magenta, bold = true })

  -- Punctuation -> Rosegold 55%
  hl("@punctuation",            { fg = c.punct })
  hl("@punctuation.delimiter",  { fg = c.punct })
  hl("@punctuation.bracket",    { fg = c.punct })
  hl("@punctuation.special",    { fg = c.tangerine })

  -- Text formatting (markdown, etc.)
  hl("@markup.heading",       { fg = c.magenta_hi, bold = true })
  hl("@markup.heading.1",     { fg = c.magenta_hi, bold = true })
  hl("@markup.heading.2",     { fg = c.tangerine,  bold = true })
  hl("@markup.heading.3",     { fg = c.gold,       bold = true })
  hl("@markup.heading.4",     { fg = c.turquoise_hi, bold = true })
  hl("@markup.heading.5",     { fg = c.aqua, bold = true })
  hl("@markup.heading.6",     { fg = c.rosegold, bold = true })
  hl("@markup.strong",        { fg = c.magenta_hi, bold = true })
  hl("@markup.italic",        { fg = c.peach, italic = true })
  hl("@markup.underline",     { fg = c.turquoise_hi, underline = true })
  hl("@markup.strikethrough", { fg = c.muted, strikethrough = true })
  hl("@markup.link",          { fg = c.turquoise_hi, underline = true })
  hl("@markup.link.label",    { fg = c.magenta })
  hl("@markup.link.url",      { fg = c.aqua, underline = true })
  hl("@markup.raw",           { fg = c.gold, bg = c.plum })
  hl("@markup.quote",         { fg = c.comment, italic = true })
  hl("@markup.list",          { fg = c.turquoise_hi })

  -- JSX / HTML / CSS
  hl("@tag.tsx",              { fg = c.magenta })
  hl("@tag.jsx",              { fg = c.magenta })
  hl("@tag.attribute.tsx",    { fg = c.tangerine })
  hl("@tag.attribute.jsx",    { fg = c.tangerine })
  hl("@property.css",         { fg = c.magenta })
  hl("@type.css",             { fg = c.aqua })
  hl("@number.css",           { fg = c.gold })
  hl("@string.css",           { fg = c.turquoise_hi })

  -- ========================================================================
  -- LSP semantic tokens
  -- ========================================================================
  link("@lsp.type.class",        "@type")
  link("@lsp.type.comment",      "@comment")
  link("@lsp.type.enum",         "@type")
  link("@lsp.type.enumMember",   "@constant")
  link("@lsp.type.function",     "@function")
  link("@lsp.type.interface",    "@type")
  link("@lsp.type.keyword",      "@keyword")
  link("@lsp.type.macro",        "@function.macro")
  link("@lsp.type.method",       "@function.method")
  link("@lsp.type.namespace",    "@namespace")
  link("@lsp.type.parameter",    "@variable.parameter")
  link("@lsp.type.property",     "@property")
  link("@lsp.type.struct",       "@type")
  link("@lsp.type.type",         "@type")
  link("@lsp.type.typeParameter","@type")
  link("@lsp.type.variable",     "@variable")
  hl("@lsp.mod.readonly",        { fg = c.gold })
  hl("@lsp.mod.deprecated",      { strikethrough = true, fg = c.muted })

  -- ========================================================================
  -- Diagnostics - underline only, sin sign column fill (§04)
  -- ========================================================================
  hl("DiagnosticError",            { fg = c.magenta })
  hl("DiagnosticWarn",             { fg = c.tangerine })
  hl("DiagnosticInfo",             { fg = c.aqua })
  hl("DiagnosticHint",             { fg = c.turquoise_hi })
  hl("DiagnosticOk",               { fg = c.turquoise_hi })
  hl("DiagnosticUnderlineError",   { undercurl = true, sp = c.magenta })
  hl("DiagnosticUnderlineWarn",    { undercurl = true, sp = c.tangerine })
  hl("DiagnosticUnderlineInfo",    { undercurl = true, sp = c.aqua })
  hl("DiagnosticUnderlineHint",    { undercurl = true, sp = c.turquoise_hi })
  hl("DiagnosticSignError",        { fg = c.magenta, bg = c.none })
  hl("DiagnosticSignWarn",         { fg = c.tangerine, bg = c.none })
  hl("DiagnosticSignInfo",         { fg = c.aqua, bg = c.none })
  hl("DiagnosticSignHint",         { fg = c.turquoise_hi, bg = c.none })
  hl("DiagnosticVirtualTextError", { fg = c.magenta, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextWarn",  { fg = c.tangerine, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextInfo",  { fg = c.aqua, bg = c.none, italic = true })
  hl("DiagnosticVirtualTextHint",  { fg = c.turquoise_hi, bg = c.none, italic = true })

  -- ========================================================================
  -- LSP references / lens
  -- ========================================================================
  hl("LspReferenceText",         { bg = c.cursorline })
  hl("LspReferenceRead",         { bg = c.cursorline })
  hl("LspReferenceWrite",        { bg = c.selection })
  hl("LspCodeLens",              { fg = c.comment, italic = true })
  hl("LspCodeLensSeparator",     { fg = c.comment })
  hl("LspSignatureActiveParameter", { fg = c.tangerine, bold = true })
  hl("LspInlayHint",             { fg = c.comment, italic = true, bg = c.none })

  -- ========================================================================
  -- Diff / git
  -- ========================================================================
  hl("DiffAdd",      { fg = c.turquoise_hi, bg = c.none })
  hl("DiffChange",   { fg = c.gold, bg = c.none })
  hl("DiffDelete",   { fg = c.magenta, bg = c.none })
  hl("DiffText",     { fg = c.gold, bg = c.plum, bold = true })
  hl("diffAdded",    { fg = c.turquoise_hi })
  hl("diffRemoved",  { fg = c.magenta })
  hl("diffChanged",  { fg = c.gold })
  hl("diffFile",     { fg = c.magenta_hi, bold = true })
  hl("diffNewFile",  { fg = c.turquoise_hi, bold = true })
  hl("diffLine",     { fg = c.aqua })

  hl("GitSignsAdd",    { fg = c.turquoise_hi })
  hl("GitSignsChange", { fg = c.gold })
  hl("GitSignsDelete", { fg = c.magenta })
  hl("GitSignsCurrentLineBlame", { fg = c.comment, italic = true })

  -- ========================================================================
  -- Treesitter context (sticky)
  -- ========================================================================
  hl("TreesitterContext",           { bg = c.plum })
  hl("TreesitterContextLineNumber", { fg = c.tangerine, bg = c.plum })
  hl("TreesitterContextBottom",     { sp = c.magenta, underline = true })

  -- ========================================================================
  -- Indent guides - barely visible
  -- ========================================================================
  hl("IblIndent",     { fg = c.indent, bg = c.none })
  hl("IblScope",      { fg = c.turquoise, bg = c.none })
  hl("IblWhitespace", { fg = c.indent })
  hl("SnacksIndent",          { fg = c.indent })
  hl("SnacksIndentScope",     { fg = c.turquoise })
  hl("SnacksIndentChunk",     { fg = c.turquoise })

  -- ========================================================================
  -- Snacks - picker, explorer, notifier, dashboard
  -- ========================================================================
  hl("SnacksPickerTitle",       { fg = c.magenta_hi, bold = true })
  hl("SnacksPickerBorder",      { fg = c.magenta })
  hl("SnacksPickerMatch",       { fg = c.tangerine, bold = true })
  hl("SnacksPickerDir",         { fg = c.turquoise_hi })
  hl("SnacksPickerFile",        { fg = c.rosegold })
  hl("SnacksPickerPrompt",      { fg = c.magenta, bold = true })
  hl("SnacksPickerCursorLine",  { bg = c.branch_bg })
  hl("SnacksPickerSelected",    { fg = c.turquoise_hi, bold = true })
  -- Forzar transparencia en los paneles (list/preview/input) para que no
  -- se rellenen con bg propio por encima de NormalFloat.
  hl("SnacksPickerList",        { bg = c.none })
  hl("SnacksPickerListNC",      { bg = c.none })
  hl("SnacksPickerPreview",     { bg = c.none })
  hl("SnacksPickerPreviewNC",   { bg = c.none })
  hl("SnacksPickerInput",       { bg = c.none })
  hl("SnacksPickerInputNC",     { bg = c.none })
  hl("SnacksPickerBox",         { bg = c.none })

  hl("SnacksDashboardTitle",  { fg = c.magenta_hi, bold = true })
  hl("SnacksDashboardHeader", { fg = c.magenta_hi, bold = true })
  hl("SnacksDashboardDesc",   { fg = c.rosegold })
  hl("SnacksDashboardIcon",   { fg = c.tangerine })
  hl("SnacksDashboardKey",    { fg = c.turquoise_hi })
  hl("SnacksDashboardTerminal", { fg = c.magenta })
  hl("SnacksDashboardFooter", { fg = c.comment })

  hl("SnacksNotifierInfo",    { fg = c.aqua })
  hl("SnacksNotifierWarn",    { fg = c.tangerine })
  hl("SnacksNotifierError",   { fg = c.magenta })
  hl("SnacksNotifierDebug",   { fg = c.turquoise_hi })
  hl("SnacksNotifierTrace",   { fg = c.comment })
  hl("SnacksNotifierHistory", { bg = c.plum })

  hl("SnacksWordsCurrent", { bg = c.selection, bold = true })
  hl("SnacksWords",        { bg = c.cursorline })

  -- Explorer
  hl("SnacksExplorerDir",         { fg = c.turquoise_hi, bold = true })
  hl("SnacksExplorerFile",        { fg = c.rosegold })
  hl("SnacksExplorerIcon",        { fg = c.tangerine })
  hl("SnacksExplorerRootName",    { fg = c.magenta_hi, bold = true })

  -- Hidden/ignored/dimmed entries (dotfiles, gitignored). NonText fallback queda
  -- en c.indent (#1B2F3A) que es casi invisible sobre Dusk (#1A0A28). Declaramos
  -- los grupos de Snacks explicitamente con c.muted (#A58670) para atenuar sin
  -- ocultar, y en italic para senalar que estan "dim".
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
  hl("BlinkCmpMenu",            { bg = c.plum, fg = c.rosegold })
  hl("BlinkCmpMenuBorder",      { fg = c.magenta, bg = c.none })
  hl("BlinkCmpMenuSelection",   { fg = c.dusk, bg = c.turquoise_hi, bold = true })
  hl("BlinkCmpLabel",           { fg = c.rosegold })
  hl("BlinkCmpLabelMatch",      { fg = c.tangerine, bold = true })
  hl("BlinkCmpLabelDetail",     { fg = c.comment })
  hl("BlinkCmpKind",            { fg = c.aqua })
  hl("BlinkCmpKindFunction",    { fg = c.tangerine })
  hl("BlinkCmpKindMethod",      { fg = c.tangerine })
  hl("BlinkCmpKindVariable",    { fg = c.rosegold })
  hl("BlinkCmpKindClass",       { fg = c.aqua })
  hl("BlinkCmpKindInterface",   { fg = c.aqua })
  hl("BlinkCmpKindKeyword",     { fg = c.magenta })
  hl("BlinkCmpKindText",        { fg = c.muted })
  hl("BlinkCmpDoc",             { bg = c.plum, fg = c.rosegold })
  hl("BlinkCmpDocBorder",       { fg = c.magenta, bg = c.none })
  hl("BlinkCmpSignatureHelp",   { bg = c.plum, fg = c.rosegold })
  hl("BlinkCmpSignatureHelpBorder",          { fg = c.magenta, bg = c.none })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.tangerine, bold = true })
  hl("BlinkCmpGhostText",       { fg = c.comment, italic = true })

  -- ========================================================================
  -- Which-key
  -- ========================================================================
  hl("WhichKey",          { fg = c.magenta })
  hl("WhichKeyDesc",      { fg = c.rosegold })
  hl("WhichKeyGroup",     { fg = c.turquoise_hi, bold = true })
  hl("WhichKeySeparator", { fg = c.punct })
  hl("WhichKeyValue",     { fg = c.gold })
  hl("WhichKeyBorder",    { fg = c.magenta, bg = c.none })
  hl("WhichKeyFloat",     { bg = c.plum })

  -- ========================================================================
  -- Harpoon / trouble / aerial
  -- ========================================================================
  hl("HarpoonBorder",          { fg = c.magenta })
  hl("HarpoonWindow",          { bg = c.plum, fg = c.rosegold })
  hl("HarpoonActive",          { fg = c.turquoise_hi, bold = true })

  hl("TroubleNormal",          { bg = c.none, fg = c.rosegold })
  hl("TroubleFile",            { fg = c.turquoise_hi, bold = true })
  hl("TroubleCount",           { fg = c.magenta_hi })
  hl("TroubleSource",          { fg = c.muted })
  hl("TroubleSignError",       { fg = c.magenta })
  hl("TroubleSignWarning",     { fg = c.tangerine })
  hl("TroubleSignInformation", { fg = c.aqua })
  hl("TroubleSignHint",        { fg = c.turquoise_hi })

  hl("AerialLine",       { bg = c.cursorline })
  hl("AerialLineNC",     { fg = c.comment })
  hl("AerialGuide",      { fg = c.indent })
  hl("AerialClassIcon",  { fg = c.aqua })
  hl("AerialFunctionIcon", { fg = c.tangerine })
  hl("AerialMethodIcon", { fg = c.tangerine })
  hl("AerialVariableIcon", { fg = c.rosegold })
  hl("AerialConstantIcon", { fg = c.gold })
  hl("AerialStringIcon", { fg = c.turquoise_hi })
  hl("AerialPropertyIcon", { fg = c.magenta })

  -- ========================================================================
  -- Render-markdown
  -- ========================================================================
  hl("RenderMarkdownH1",       { fg = c.magenta_hi, bold = true })
  hl("RenderMarkdownH2",       { fg = c.tangerine,  bold = true })
  hl("RenderMarkdownH3",       { fg = c.gold,       bold = true })
  hl("RenderMarkdownH4",       { fg = c.turquoise_hi, bold = true })
  hl("RenderMarkdownH5",       { fg = c.aqua,       bold = true })
  hl("RenderMarkdownH6",       { fg = c.rosegold,   bold = true })
  hl("RenderMarkdownCode",     { bg = c.plum })
  hl("RenderMarkdownCodeInline", { fg = c.gold, bg = c.plum })
  hl("RenderMarkdownQuote",    { fg = c.comment, italic = true })
  hl("RenderMarkdownBullet",   { fg = c.turquoise_hi })
  hl("RenderMarkdownDash",     { fg = c.pane_border })

  -- ========================================================================
  -- Telescope (por si algun plugin lo usa)
  -- ========================================================================
  hl("TelescopeNormal",         { bg = c.plum, fg = c.rosegold })
  hl("TelescopeBorder",         { fg = c.magenta, bg = c.plum })
  hl("TelescopePromptNormal",   { bg = c.plum })
  hl("TelescopePromptBorder",   { fg = c.magenta, bg = c.plum })
  hl("TelescopePromptTitle",    { fg = c.dusk, bg = c.magenta, bold = true })
  hl("TelescopePreviewTitle",   { fg = c.dusk, bg = c.turquoise_hi, bold = true })
  hl("TelescopeResultsTitle",   { fg = c.dusk, bg = c.tangerine, bold = true })
  hl("TelescopeMatching",       { fg = c.gold, bold = true })
  hl("TelescopeSelection",      { bg = c.branch_bg, fg = c.turquoise_hi, bold = true })

  -- ========================================================================
  -- Terminal 16 colors (for :terminal)
  -- ========================================================================
  vim.g.terminal_color_0  = c.dusk
  vim.g.terminal_color_1  = c.magenta
  vim.g.terminal_color_2  = c.turquoise_hi
  vim.g.terminal_color_3  = c.gold
  vim.g.terminal_color_4  = c.turquoise
  vim.g.terminal_color_5  = c.magenta
  vim.g.terminal_color_6  = c.aqua
  vim.g.terminal_color_7  = c.rosegold
  vim.g.terminal_color_8  = c.plum
  vim.g.terminal_color_9  = c.magenta_hi
  vim.g.terminal_color_10 = c.aqua
  vim.g.terminal_color_11 = c.peach
  vim.g.terminal_color_12 = c.turquoise_hi
  vim.g.terminal_color_13 = c.tangerine
  vim.g.terminal_color_14 = c.turquoise_hi
  vim.g.terminal_color_15 = c.cream
end

return M
