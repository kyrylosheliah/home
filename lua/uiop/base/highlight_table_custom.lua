local def = require(vim.g.username .. ".base.highlight_defaults")
local shade = def.shade

M = {}

local c = {}
-- Tint
c.tin = 0.15
c.tint = def.c["Tan3"]
-- Primary color saturation
c.pri = 0.08
c.primary = def.c["Magenta"]
-- Saturation
c.sat = 1.0
-- Subtleness
c.sub = 0.25
-- Shades
c.black = def.c["Gray5"]
c.gray = def.c["Gray40"]
c.white = def.c["Gray95"]
-- Primary color
c.black = shade(c.primary, c.pri, c.black)
-- Tint warmup
c.gray = shade(c.tint, c.tin, c.gray)
c.white = shade(c.tint, c.tin, c.white)
-- Tint shades
c.sub_black = shade(c.gray, c.sub, c.black)
c.sub_gray = shade(c.white, c.sub, c.black)
c.sub_white = shade(c.white, c.sub, c.gray)
-- Pure shades
c.pure_black = "#000000"
c.pure_gray = def.c["Gray60"]
c.pure_white = "#ffffff"

local palette = {
  red = def.c["LightCoral"],
  green = def.c["LightGreen"], --"SpringGreen" --"PaleGreen2"
  blue = def.c["DeepSkyBlue"], --"DeepSkyBlue" --"DodgerBlue" --"LightSkyBlue"
  yellow = def.c["LightGoldenrod"], --"Peru" --"Khaki" --"Wheat"
  purple = def.c["LightMagenta"],
  cyan = shade(def.c["Cyan"], 0.5, c.white),
  brown = def.c["Peru"],
}
for key, value in pairs(palette) do
  --c[key] = value
  -- Apply saturation by multiplying with the maximum brightness
  c[key] = shade(value, c.sat, c.white)
  -- Apply subtleness relative to the background brightness
  c["sub_" .. key] = shade(c[key], c.sub, c.black)
  --c["sub_" .. key] = shade(c[key], (1-c.sub), c.black)
end
-- Special
c.none = "NONE"
-- Bright and pure
c.pure_red = "#ff0000"
c.pure_green = "#00ff00"
c.pure_blue = "#0000ff"
c.pure_yellow = "#ffff00"
c.pure_purple = "#ff00ff"
c.pure_cyan = "#00ffff"

local highlight = {
  ["Comment"] = { fg = c.gray }, -- any comment
  ["Constant"] = { fg = c.white }, -- any constant
  ["String"] = { fg = c.green }, -- a string constant: "this is a string"
  ["Character"] = { fg = c.green }, -- a character constant: 'c', '\n'
  ["Number"] = { fg = c.blue }, -- a number constant: 234, 0xff
  ["Boolean"] = { fg = c.blue }, -- a boolean constant: TRUE, false
  ["Float"] = { fg = c.blue }, -- a floating point constant: 2.3e10
  ["Identifier"] = { fg = c.white }, -- any variable name
  ["Function"] = { fg = c.white }, -- function name (also: methods for classes)
  ["Statement"] = { fg = c.white }, -- any statement
  ["Conditional"] = { fg = c.red }, -- if, then, else, endif, switch, etc.
  ["Repeat"] = { fg = c.red }, -- for, do, while, etc.
  ["Label"] = { fg = c.red }, -- case, default, etc.
  ["Operator"] = { fg = c.yellow }, -- sizeof", "+", "*", etc.
  ["Keyword"] = { fg = c.red }, -- any other keyword
  ["Exception"] = { fg = c.red }, -- try, catch, throw
  ["PreProc"] = { fg = c.red }, -- generic Preprocessor
  ["Include"] = { fg = c.red }, -- preprocessor #include
  ["Define"] = { fg = c.red  }, -- preprocessor #define
  ["Macro"] = { fg = c.red }, -- same as Define
  ["PreCondit"] = { fg = c.red }, -- preprocessor #if, #else, #endif, etc.
  ["Type"] = { fg = c.blue }, -- int, long, char, etc.
  ["StorageClass"] = { fg = c.red }, -- static, register, volatile, etc.
  ["Structure"] = { fg = c.blue }, -- struct, union, enum, etc.
  ["Typedef"] = { fg = c.blue }, -- A typedef
  ["Special"] = { fg = c.red }, -- any special symbol
  ["SpecialChar"] = { fg = c.red }, -- special character in a constant
  ["Tag"] = { fg = c.pure_yellow }, -- you can use CTRL-] on this
  ["SpecialComment"] = { fg = c.pure_yellow }, -- special things inside a comment
  ["Debug"] = { fg = c.pure_blue }, -- debugging statements
  ["Underlined"] = { underline = true }, -- text that stands out, HTML links
  ["Error"] = { fg = c.pure_red }, -- any erroneous construct
  ["Todo"] = { fg = c.pure_yellow }, -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX

  -- Highlighting Groups (descriptions and ordering from ` =h highlight-groups`) {{{
  ["ColorColumn"] = { bg = c.gray }, -- used for the columns set with 'colorcolumn'
  ["Conceal"] = { fg = c.sub_gray }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  ["Cursor"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["lCursor"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["CursorIM"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["CursorLine"] = { bg = c.sub_gray }, -- the screen line that the cursor is in when 'cursorline' is set
  ["Directory"] = { fg = c.blue }, -- directory names (and other special names in listings)
  ["DiffAdd"] = { bg = c.green, fg = c.black }, -- diff mode: Added line
  ["DiffChange"] = { fg = c.yellow, underline = true }, -- diff mode: Changed line
  ["DiffDelete"] = { bg = c.red, fg = c.black }, -- diff mode: Deleted line
  ["DiffText"] = { bg = c.yellow, fg = c.black }, -- diff mode: Changed text within a changed line
  ["EndOfBuffer"] = { fg = c.sub_gray }, -- '~' and '@' at the end of the window
  ["ErrorMsg"] = { fg = c.red }, -- error messages on the command line
  ["VertSplit"] = { fg = c.sub_gray }, -- the column separating vertically split windows
  ["WinSeparator"] = { fg = c.sub_gray }, -- the column separating vertically split windows
  ["Folded"] = { fg = c.gray }, -- line used for closed folds
  ["FoldColumn"] = { bg = vim.g.transparent and c.none or c.black, fg = c.gray }, -- column where folds are displayed
  ["SignColumn"] = { fg = c.white, bg = vim.g.transparent and c.none or nil }, -- column where signs are displayed
  ["IncSearch"] = { fg = c.black, bg = c.pure_green }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  ["CurSearch"] = { fg = c.black, bg = c.pure_green }, -- 'cursearch' highlighting; also used for the text replaced with ":s///c"
  ["LineNr"] = { fg = c.sub_gray, bg = vim.g.transparent and c.none or nil }, -- Line number for " =number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  ["CursorLineNr"] = { fg = c.white, bg = c.sub_gray }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
  ["MatchParen"] = { fg = c.pure_black, bg = c.pure_purple }, -- The character under the cursor or just before it, if it is a paired bracket, and its match.
  ["ModeMsg"] = { fg = c.gray, bold = true }, --' showmode' message (e.g., "-- INSERT --")
  ["MoreMsg"] = { fg = c.pure_purple }, -- more-prompt
  ["NonText"] = { fg = c.sub_gray }, -- characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
  ["Normal"] = { fg = c.white, bg = vim.g.transparent and c.none or c.black }, -- normal text
  ["NormalNC"] = { fg = c.white, bg = vim.g.transparent and c.none or c.pure_black }, -- normal text
  ["NormalFloat"] = { fg = c.white, bg = c.sub_gray }, -- Normal text in floating windows.
  ["FloatBorder"] = { fg = c.gray, bg = c.black }, -- Border of floating windows.
  ["Pmenu"] = { fg = c.white, bg = c.black }, -- Popup menu: normal item.
  ["PmenuSel"] = { fg = c.white, bg = c.gray }, -- Popup menu: selected item.
  ["PmenuSbar"] = { bg = c.sub_gray }, -- Popup menu: scrollbar.
  ["PmenuThumb"] = { bg = c.gray }, -- Popup menu: Thumb of the scrollbar.
  ["Question"] = { fg = c.blue }, -- hit-enter prompt and yes/no questions
  ["QuickFixLine"] = { fg = c.cyan, bg = c.sub_gray }, -- Current quickfix item in the quickfix window.
  ["Search"] = { fg = c.black, bg = c.pure_purple }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
  ["SpecialKey"] = { fg = c.special_grey }, -- Meta and special keys listed with " =map", also for text used to show unprintable characters in the text, 'listchars'. Generally: text that is displayed differently from what it really is.
  ["SpellBad"] = { fg = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker. This will be combined with the highlighting used otherwise.
  ["SpellCap"] = { fg = c.yellow }, -- Word that should start with a capital. This will be combined with the highlighting used otherwise.
  ["SpellLocal"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is used in another region. This will be combined with the highlighting used otherwise.
  ["SpellRare"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is hardly ever used. spell This will be combined with the highlighting used otherwise.
  ["StatusLine"] = { fg = c.black, bg = c.white }, -- status line of current window
  ["StatusLineNC"] = { fg = c.white, bg = c.sub_gray }, -- status lines of not-current windows Note = if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  ["StatusLineTerm"] = { fg = c.pure_blue, bg = c.white }, -- status line of current :terminal window
  ["StatusLineTermNC"] = { fg = c.black, bg = c.sub_gray }, -- status line of non-current  =terminal window
  ["TabLine"] = { fg = c.gray }, -- tab pages line, not active tab page label
  ["TabLineFill"] = { bg = c.black }, -- tab pages line, where there are no labels
  ["TabLineSel"] = { fg = c.white }, -- tab pages line, active tab page label
  ["Terminal"] = { fg = c.white, bg = c.black }, -- terminal window (see terminal-size-color)
  ["Title"] = { fg = c.green }, -- titles for output from " =set all", ":autocmd" etc.
  ["Visual"] = { fg = c.white, bg = c.sub_blue }, -- Visual mode selection
  ["VisualNOS"] = { fg = c.pure_purple, bg = c.sub_blue }, -- Visual mode selection when vim is "Not Owning the Selection". Only X11 Gui's gui-x11 and xterm-clipboard supports this.
  ["WarningMsg"] = { fg = c.pure_yellow }, -- warning messages
  ["WildMenu"] = { fg = c.black, bg = c.blue }, -- current match in 'wildmenu' completion
  ["Winbar"] = { fg = c.white, bg = c.sub_gray }, -- Winbar
  ["WinbarNC"] = { fg = c.gray, bg = c.black }, -- Winbar non-current windows.

  -- HTML
  ["htmlArg"] = { fg = c.green, italic = true }, -- attributes
  ["htmlEndTag"] = { fg = c.pure_gray }, -- end tag />
  ["htmlTitle"] = { fg = c.pure_gray }, -- title tag text
  ["htmlTag"] = { fg = c.pure_gray }, -- tag delimiters
  ["htmlTagN"] = { fg = c.pure_gray },
  ["htmlTagName"] = { fg = c.cyan }, -- tag text

  -- Markdown
  ["markdownH1"] = { fg = c.pure_blue, bold = true },
  ["markdownH2"] = { fg = c.pure_blue, bold = true },
  ["markdownH3"] = { fg = c.pure_blue, bold = true },
  ["markdownH4"] = { fg = c.pure_blue, bold = true },
  ["markdownH5"] = { fg = c.pure_blue, bold = true },
  ["markdownH6"] = { fg = c.pure_blue, bold = true },
  ["markdownHeadingDelimiter"] = { fg = c.gray },
  ["markdownHeadingRule"] = { fg = c.gray },
  ["markdownId"] = { fg = c.cyan },
  ["markdownIdDeclaration"] = { fg = c.blue },
  ["markdownIdDelimiter"] = { fg = c.cyan },
  ["markdownLinkDelimiter"] = { fg = c.gray },
  ["markdownLinkText"] = { fg = c.blue, italic = true },
  ["markdownListMarker"] = { fg = c.gray },
  ["markdownOrderedListMarker"] = { fg = c.gray },
  ["markdownRule"] = { fg = c.gray },
  ["markdownUrl"] = { fg = c.green, bg = c.none },
  ["markdownBlockquote"] = { fg = c.pure_gray },
  ["markdownBold"] = { fg = c.white, bg = c.none, bold = true },
  ["markdownItalic"] = { fg = c.white, bg = c.none, italic = true },
  ["markdownCode"] = { fg = c.yellow },
  ["markdownCodeBlock"] = { fg = c.yellow },
  ["markdownCodeDelimiter"] = { fg = c.gray },

  -- Tree sitter
  ["@boolean"] = { fg = c.blue },
  ["@constructor"] = { fg = c.blue },
  ["@constant.builtin"] = { fg = c.white },
  ["@keyword.function"] = { fg = c.red },
  ["@namespace"] = { fg = c.white },
  ["@parameter"] = { fg = c.white },
  ["@property"] = { fg = c.white },
  ["@punctuation"] = { fg = c.yellow },
  ["@punctuation.delimiter"] = { fg = c.yellow },
  ["@punctuation.bracket"] = { fg = c.yellow },
  ["@punctuation.special"] = { fg = c.yellow },
  ["@string.documentation"] = { fg = c.green },
  ["@string.regex"] = { fg = c.yellow },
  ["@string.escape"] = { fg = c.blue },
  ["@symbol"] = { fg = c.white },
  ["@tag"] = { fg = c.white },
  ["@tag.attribute"] = { fg = c.white },
  ["@tag.delimiter"] = { fg = c.yellow },
  ["@type.builtin"] = { fg = c.blue },
  ["@variable"] = { fg = c.white },
  ["@variable.builtin"] = { fg = c.white },
  ["@variable.parameter"] = { fg = c.white },
  -- Tree sitter language specific overrides
  ["@constructor.javascript"] = { fg = c.green },
  ["@keyword.clojure"] = { fg = c.red },

  -- LSP Semantic Token Groups
  ["@lsp.type.boolean"] = { link = "@boolean" },
  ["@lsp.type.builtinType"] = { link = "@type.builtin" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
  ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
  ["@lsp.type.interface"] = { fg = c.white },
  ["@lsp.type.keyword"] = { link = "@keyword" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.number"] = { link = "@number" },
  ["@lsp.type.operator"] = { link = "@operator" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
  ["@lsp.type.string.rust"] = { link = "@string" },
  ["@lsp.type.typeAlias"] = { link = "@type.definition" },
  ["@lsp.type.unresolvedReference"] = { undercurl = true, sp = c.error },
  ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
  ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
  ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
  ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" },
  ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.operator.injected"] = { link = "@operator" },
  ["@lsp.typemod.string.injected"] = { link = "@string" },
  ["@lsp.typemod.type.defaultLibrary"] = { fg = c.blue },
  ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
  ["@lsp.typemod.variable.injected"] = { link = "@variable" },

  ["@markup.heading"] = { fg = c.pure_gray, bold = true },
  ["@markup.heading.1"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.1.marker"] = { link = "@comment" },
  ["@markup.heading.2"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.2.marker"] = { link = "@comment" },
  ["@markup.heading.3"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.3.marker"] = { link = "@comment" },
  ["@markup.heading.4"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.4.marker"] = { link = "@comment" },
  ["@markup.heading.5"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.5.marker"] = { link = "@comment" },
  ["@markup.heading.6"] = { fg = c.pure_gray, bold = true, italic = true },
  ["@markup.heading.6.marker"] = { link = "@comment" },
  ["@markup.link"] = { fg = c.pure_gray },
  ["@markup.link.label"] = { fg = c.cyan },
  ["@markup.link.url"] = { fg = c.blue },
  ["@markup.list"] = { fg = c.gray, bold = true },
  ["@markup.list.checked"] = { fg = c.gray },
  ["@markup.list.unchecked"] = { fg = c.gray },
  ["@markup.raw.block"] = { fg = c.gray },
  ["@markup.raw.delimiter"] = { fg = c.gray },
  ["@markup.quote"] = { fg = c.pure_gray },
  ["@markup.strikethrough"] = { fg = c.gray, strikethrough = true },

  -- Diagnostics
  ["DiagnosticOk"] = { fg = c.green },
  ["DiagnosticError"] = { fg = c.red },
  ["DiagnosticWarn"] = { fg = c.yellow },
  ["DiagnosticInfo"] = { fg = c.blue },
  ["DiagnosticHint"] = { fg = c.cyan },
  ["DiagnosticUnderlineError"] = { fg = c.red, undercurl = true },
  ["DiagnosticUnderlineWarn"] = { fg = c.yellow, undercurl = true },
  ["DiagnosticUnderlineInfo"] = { fg = c.blue, undercurl = true },
  ["DiagnosticUnderlineHint"] = { fg = c.cyan, undercurl = true },

  -- Neovim's built-in language server client
  ["LspReferenceWrite"] = { bg = c.sub_purple },
  ["LspReferenceText"] = { bg = c.sub_purple },
  ["LspReferenceRead"] = { bg = c.sub_purple },
  ["LspSignatureActiveParameter"] = { fg = c.blue, bold = true },

  -- GitSigns
  ["GitSignsAdd"] = { fg = c.pure_green },
  ["GitSignsChange"] = { fg = c.pure_yellow },
  ["GitSignsDelete"] = { fg = c.pure_red },

  -- Diff
  ["diffAdded"] = { fg = c.pure_green },
  ["diffRemoved"] = { fg = c.pure_red },
  ["diffChanged"] = { fg = c.pure_yellow },
  ["diffOldFile"] = { fg = c.gray },
  ["diffNewFile"] = { fg = c.white },
  ["diffFile"] = { fg = c.gray },
  ["diffLine"] = { fg = c.cyan },
  ["diffIndexLine"] = { fg = c.purple },

  -- Hop
  ["HopNextKey"] = { fg = c.pure_yellow },
  ["HopNextKey1"] = { fg = c.pure_blue },
  ["HopNextKey2"] = { fg = c.pure_cyan },
  ["HopUnmatched"] = { fg = c.gray },
  ["HopCursor"] = { fg = c.pure_cyan },
  ["HopPreview"] = { fg = c.pure_blue },

  -- Cmp
  ["CmpItemAbbrDeprecated"] = { fg = c.gray, strikethrough = true },
  ["CmpItemAbbrMatch"] = { fg = c.blue, bold = true },
  ["CmpItemAbbrMatchFuzzy"] = { fg = c.blue, bold = true },
  ["CmpItemMenu"] = { fg = c.pure_gray },
  ["CmpItemKindText"] = { fg = c.white },
  ["CmpItemKindFunction"] = { fg = c.white },
  ["CmpItemKindVariable"] = { fg = c.white },
  ["CmpItemKindEnum"] = { fg = c.white },
  ["CmpItemKindSnippet"] = { fg = c.yellow },

  -- Navic
  ["NavicIconsFile"] = { fg = c.white, bg = c.none },
  ["NavicIconsModule"] = { fg = c.yellow, bg = c.none },
  ["NavicIconsNamespace"] = { fg = c.white, bg = c.none },
  ["NavicIconsPackage"] = { fg = c.white, bg = c.none },
  ["NavicIconsClass"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsMethod"] = { fg = c.blue, bg = c.none },
  ["NavicIconsProperty"] = { fg = c.green, bg = c.none },
  ["NavicIconsField"] = { fg = c.green, bg = c.none },
  ["NavicIconsConstructor"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEnum"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsInterface"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsFunction"] = { fg = c.blue, bg = c.none },
  ["NavicIconsVariable"] = { fg = c.purple, bg = c.none },
  ["NavicIconsConstant"] = { fg = c.purple, bg = c.none },
  ["NavicIconsString"] = { fg = c.green, bg = c.none },
  ["NavicIconsNumber"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsBoolean"] = { fg = c.yellow, bg = c.none },
  ["NavicIconsArray"] = { fg = c.pure_gray, bg = c.none },
  ["NavicIconsObject"] = { fg = c.pure_gray, bg = c.none },
  ["NavicIconsKey"] = { fg = c.blue, bg = c.none },
  ["NavicIconsKeyword"] = { fg = c.blue, bg = c.none },
  ["NavicIconsNull"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEnumMember"] = { fg = c.green, bg = c.none },
  ["NavicIconsStruct"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEvent"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsOperator"] = { fg = c.white, bg = c.none },
  ["NavicIconsTypeParameter"] = { fg = c.green, bg = c.none },
  ["NavicText"] = { fg = c.white, bg = c.none },
  ["NavicSeparator"] = { fg = c.pure_gray, bg = c.none },

  -- Notify
  ["NotifyBackground"] = { fg = c.white, bg = c.bg },
  ["NotifyERRORBorder"] = { fg = c.red, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBorder"] = { fg = c.yellow, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBorder"] = { fg = c.blue, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBorder"] = { fg = c.pure_gray, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBorder"] = { fg = c.cyan, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyERRORIcon"] = { fg = c.pure_red },
  ["NotifyWARNIcon"] = { fg = c.pure_yellow },
  ["NotifyINFOIcon"] = { fg = c.pure_blue },
  ["NotifyDEBUGIcon"] = { fg = c.gray },
  ["NotifyTRACEIcon"] = { fg = c.pure_cyan },
  ["NotifyERRORTitle"] = { fg = c.pure_red },
  ["NotifyWARNTitle"] = { fg = c.pure_yellow },
  ["NotifyINFOTitle"] = { fg = c.pure_blue },
  ["NotifyDEBUGTitle"] = { fg = c.gray },
  ["NotifyTRACETitle"] = { fg = c.pure_cyan },
  ["NotifyERRORBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },

  -- NeoTree
  ["NeoTreeFloatBorder"] = { fg = c.gray, bg = c.black },
  ["NeoTreeFloatTitle"] = { fg = c.gray, bg = c.pure_gray },
  ["NeoTreeTitleBar"] = { fg = c.gray, bg = c.sub_gray },

  -- Telescope
  ["TelescopeBorder"] = { fg = c.white, bg = c.black },
  ["TelescopeNormal"] = { fg = c.white, bg = c.black },
  ["TelescopePreviewTitle"] = { fg = c.black, bg = c.green, bold = true },
  ["TelescopeResultsTitle"] = { fg = c.black, bg = c.blue },
  ["TelescopePromptTitle"] = { fg = c.black, bg = c.red, bold = true },
  ["TelescopePromptBorder"] = { fg = c.sub_gray, bg = c.sub_gray },
  ["TelescopePromptNormal"] = { fg = c.white, bg = c.sub_gray },
  ["TelescopePromptCounter"] = { fg = c.blue, bg = c.sub_gray },
  ["TelescopeMatching"] = { fg = c.blue },

  -- Dap UI
  ["DapUINormal"] = { link = "Normal" },
  ["DapUIVariable"] = { link = "Normal" },
  ["DapUIScope"] = { fg = c.blue },
  ["DapUIType"] = { fg = c.purple },
  ["DapUIValue"] = { link = "Normal" },
  ["DapUIModifiedValue"] = { fg = c.blue, bold = true },
  ["DapUIDecoration"] = { fg = c.blue },
  ["DapUIThread"] = { fg = c.pure_green },
  ["DapUIStoppedThread"] = { fg = c.blue },
  ["DapUIFrameName"] = { link = "Normal" },
  ["DapUISource"] = { fg = c.purple },
  ["DapUILineNumber"] = { fg = c.blue },
  ["DapUIFloatNormal"] = { link = "NormalFloat" },
  ["DapUIFloatBorder"] = { fg = c.blue },
  ["DapUIWatchesEmpty"] = { fg = c.pure_cyan },
  ["DapUIWatchesValue"] = { fg = c.pure_green },
  ["DapUIWatchesError"] = { fg = c.pure_cyan },
  ["DapUIBreakpointsPath"] = { fg = c.blue },
  ["DapUIBreakpointsInfo"] = { fg = c.pure_green },
  ["DapUIBreakpointsCurrentLine"] = { fg = c.pure_green, bold = true },
  ["DapUIBreakpointsLine"] = { link = "DapUILineNumber" },
  ["DapUIBreakpointsDisabledLine"] = { fg = c.gray },
  ["DapUICurrentFrameName"] = { link = "DapUIBreakpointsCurrentLine" },
  ["DapUIStepOver"] = { fg = c.blue },
  ["DapUIStepInto"] = { fg = c.blue },
  ["DapUIStepBack"] = { fg = c.blue },
  ["DapUIStepOut"] = { fg = c.blue },
  ["DapUIStop"] = { fg = c.pure_cyan },
  ["DapUIPlayPause"] = { fg = c.pure_green },
  ["DapUIRestart"] = { fg = c.pure_green },
  ["DapUIUnavailable"] = { fg = c.gray },
  ["DapUIWinSelect"] = { fg = c.cyan, bold = true },
  ["DapUIEndofBuffer"] = { link = "EndofBuffer" },

  -- Flash
  ["FlashBackdrop"] = { link = "Comment" },
  ["FlashCurrent"] = { link = "IncSearch" },
  ["FlashCursor"] = { bg = c.pure_blue, fg = c.black , bold = true },
  ["FlashLabel"] = { bg = c.cyan, bold = true, fg = c.black },
  ["FlashMatch"] = { link = "Search" },
  ["FlashPrompt"] = { link = "MsgArea" },
  ["FlashPromptIcon"] = { link = "Special" },

}

return highlight
