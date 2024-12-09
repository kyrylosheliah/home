vim.g.transparent = false
vim.o.background = 'dark'

local def = require(vim.g.username .. ".base.highlight_defaults")
local shade = def.shade

-- colorscheme transparancy
--[[M.apply_transparency = function()
  vim.api.nvim_set_hl(0, "Normal", { bg="none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })
  vim.api.nvim_set_hl(0, "LineNr", { bg="none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg="none" })
end
M.apply_transparency()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("base.highlight", { clear = true }),
  pattern = "*",
  callback = M.apply_transparency,
})]]

M = {}

local c = {}
-- Tint
c.tin = 0.1
c.tint = def.c["Tan1"]
-- Primary color saturation
c.pri = 0.1
c.primary = def.c["Magenta"]
-- Saturation
c.sat = 1.0
-- Subtleness
c.sub = 0.25
-- Shades
c.black = def.c["Gray5"]
c.gray1 = def.c["Gray15"]
c.gray2 = def.c["Gray20"]
c.gray3 = def.c["Gray25"]
c.gray4 = def.c["Gray30"]
c.gray5 = def.c["Gray35"]
c.gray6 = def.c["Gray40"]
c.gray7 = def.c["Gray45"]
c.gray8 = def.c["Gray50"]
c.white = def.c["Gray95"]
-- Primary color tint
c.black = shade(c.primary, c.pri, c.black)
-- Warmup
c.gray1 = shade(c.tint, c.tin, c.gray1)
c.gray2 = shade(c.tint, c.tin, c.gray2)
c.gray3 = shade(c.tint, c.tin, c.gray3)
c.gray4 = shade(c.tint, c.tin, c.gray4)
c.gray5 = shade(c.tint, c.tin, c.gray5)
c.gray6 = shade(c.tint, c.tin, c.gray6)
c.gray7 = shade(c.tint, c.tin, c.gray7)
c.gray8 = shade(c.tint, c.tin, c.gray8)
c.white = shade(c.tint, c.tin, c.white)
-- Normal
c.red = def.c["LightCoral"]
c.green = def.c["LightGreen"] --"SpringGreen" --"PaleGreen2"
c.blue = def.c["DeepSkyBlue"] --"DodgerBlue" --"LightSkyBlue"
c.yellow = def.c["LightGoldenrod"] --"Peru" --"Khaki" --"Wheat"
c.purple = def.c["Violet"] --"LightMagenta"
c.cyan = shade(def.c["Cyan"], 0.5, c.white)
-- Apply saturation by multiplying with the maximum brightness
c.red = shade(c.red, c.sat, c.white)
c.green = shade(c.green, c.sat, c.white)
c.blue = shade(c.blue, c.sat, c.white)
c.yellow = shade(c.yellow, c.sat, c.white)
c.purple = shade(c.purple, c.sat, c.white)
c.cyan = shade(c.cyan, c.sat, c.white)
-- Apply subtleness relative to the background brightness
c.sub_red = shade(c.red, c.sub, c.black)
c.sub_green = shade(c.green, c.sub, c.black)
c.sub_blue = shade(c.blue, c.sub, c.black)
c.sub_yellow = shade(c.yellow, c.sub, c.black)
c.sub_purple = shade(c.purple, c.sub, c.black)
c.sub_cyan = shade(c.cyan, c.sub, c.black)
-- Special
c.none = "NONE"
-- Bright and pure
c.pure_black = "#000000"
c.pure_red = "#ff0000"
c.pure_green = "#00ff00"
c.pure_blue = "#0000ff"
c.pure_yellow = "#ffff00"
c.pure_purple = "#ff00ff"
c.pure_cyan = "#00ffff"
c.pure_white = "#ffffff"

local highlight = {
  ["Comment"] = { fg = c.gray8 }, -- any comment
  ["Constant"] = { fg = c.white }, -- any constant
  ["String"] = { fg = c.green }, -- a string constant: "this is a string"
  ["Character"] = { fg = c.green }, -- a character constant: 'c', '\n'
  ["Number"] = { fg = c.green }, -- a number constant: 234, 0xff
  ["Boolean"] = { fg = c.green }, -- a boolean constant: TRUE, false
  ["Float"] = { fg = c.green }, -- a floating point constant: 2.3e10
  ["Identifier"] = { fg = c.white }, -- any variable name
  ["Function"] = { fg = c.white }, -- function name (also: methods for classes)
  ["Statement"] = { fg = c.white }, -- any statement
  ["Conditional"] = { fg = c.blue }, -- if, then, else, endif, switch, etc.
  ["Repeat"] = { fg = c.blue }, -- for, do, while, etc.
  ["Label"] = { fg = c.blue }, -- case, default, etc.
  ["Operator"] = { fg = c.red }, -- sizeof", "+", "*", etc.
  ["Keyword"] = { fg = c.blue }, -- any other keyword
  ["Exception"] = { fg = c.blue }, -- try, catch, throw
  ["PreProc"] = { fg = c.blue }, -- generic Preprocessor
  ["Include"] = { fg = c.blue }, -- preprocessor #include
  ["Define"] = { fg = c.blue  }, -- preprocessor #define
  ["Macro"] = { fg = c.blue }, -- same as Define
  ["PreCondit"] = { fg = c.blue }, -- preprocessor #if, #else, #endif, etc.
  ["Type"] = { fg = c.green }, -- int, long, char, etc.
  ["StorageClass"] = { fg = c.blue }, -- static, register, volatile, etc.
  ["Structure"] = { fg = c.green }, -- struct, union, enum, etc.
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
  ["ColorColumn"] = { bg = c.gray1 }, -- used for the columns set with 'colorcolumn'
  ["Conceal"] = { fg = c.gray3 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  ["Cursor"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["lCursor"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["CursorIM"] = { fg = c.black, bg = c.white }, -- the character under the cursor
  ["CursorLine"] = { bg = c.gray1 }, -- the screen line that the cursor is in when 'cursorline' is set
  ["Directory"] = { fg = c.blue }, -- directory names (and other special names in listings)
  ["DiffAdd"] = { bg = c.green, fg = c.black }, -- diff mode: Added line
  ["DiffChange"] = { fg = c.yellow, underline = true }, -- diff mode: Changed line
  ["DiffDelete"] = { bg = c.red, fg = c.black }, -- diff mode: Deleted line
  ["DiffText"] = { bg = c.yellow, fg = c.black }, -- diff mode: Changed text within a changed line
  ["EndOfBuffer"] = { fg = c.gray1 }, -- '~' and '@' at the end of the window
  ["ErrorMsg"] = { fg = c.red }, -- error messages on the command line
  ["VertSplit"] = { fg = c.gray3 }, -- the column separating vertically split windows
  ["WinSeparator"] = { fg = c.gray3 }, -- the column separating vertically split windows
  ["Folded"] = { fg = c.gray5 }, -- line used for closed folds
  ["FoldColumn"] = { bg = vim.g.transparent and c.none or c.black, fg = c.gray6 }, -- column where folds are displayed
  ["SignColumn"] = { fg = c.white }, -- column where signs are displayed
  ["IncSearch"] = { fg = c.black, bg = c.pure_purple }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  ["CurSearch"] = { fg = c.black, bg = c.pure_green }, -- 'cursearch' highlighting; also used for the text replaced with ":s///c"
  ["LineNr"] = { fg = c.gray3 }, -- Line number for " =number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  ["CursorLineNr"] = { fg = c.white, bg = c.gray1 }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
  ["MatchParen"] = { bg = c.pure_purple, fg = c.black, strikethrough = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match.
  ["ModeMsg"] = { fg = c.gray4, bold = true }, --' showmode' message (e.g., "-- INSERT --")
  ["MoreMsg"] = { fg = c.pure_purple }, -- more-prompt
  ["NonText"] = { fg = c.gray3 }, -- characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
  ["Normal"] = { fg = c.white, bg = vim.g.transparent and c.none or c.black }, -- normal text
  ["NormalNC"] = { fg = c.white, bg = vim.g.transparent and c.none or c.pure_black }, -- normal text
  ["NormalFloat"] = { fg = c.white, bg = c.gray1 }, -- Normal text in floating windows.
  ["FloatBorder"] = { fg = c.gray4, bg = c.black }, -- Border of floating windows.
  ["Pmenu"] = { fg = c.white, bg = c.black }, -- Popup menu: normal item.
  ["PmenuSel"] = { fg = c.white, bg = c.gray4 }, -- Popup menu: selected item.
  ["PmenuSbar"] = { bg = c.gray3 }, -- Popup menu: scrollbar.
  ["PmenuThumb"] = { bg = c.gray4 }, -- Popup menu: Thumb of the scrollbar.
  ["Question"] = { fg = c.blue }, -- hit-enter prompt and yes/no questions
  ["QuickFixLine"] = { fg = c.cyan, bg = c.gray3 }, -- Current quickfix item in the quickfix window.
  ["Search"] = { fg = c.black, bg = c.pure_purple}, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
  ["SpecialKey"] = { fg = c.special_grey }, -- Meta and special keys listed with " =map", also for text used to show unprintable characters in the text, 'listchars'. Generally: text that is displayed differently from what it really is.
  ["SpellBad"] = { fg = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker. This will be combined with the highlighting used otherwise.
  ["SpellCap"] = { fg = c.yellow }, -- Word that should start with a capital. This will be combined with the highlighting used otherwise.
  ["SpellLocal"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is used in another region. This will be combined with the highlighting used otherwise.
  ["SpellRare"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is hardly ever used. spell This will be combined with the highlighting used otherwise.
  ["StatusLine"] = { fg = c.black, bg = c.white }, -- status line of current window
  ["StatusLineNC"] = { fg = c.white, bg = c.gray1 }, -- status lines of not-current windows Note = if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  ["StatusLineTerm"] = { fg = c.pure_blue, bg = c.white }, -- status line of current :terminal window
  ["StatusLineTermNC"] = { fg = c.black, bg = c.gray3 }, -- status line of non-current  =terminal window
  ["TabLine"] = { fg = c.gray6 }, -- tab pages line, not active tab page label
  ["TabLineFill"] = { bg = c.black }, -- tab pages line, where there are no labels
  ["TabLineSel"] = { fg = c.white }, -- tab pages line, active tab page label
  ["Terminal"] = { fg = c.white, bg = c.black }, -- terminal window (see terminal-size-color)
  ["Title"] = { fg = c.green }, -- titles for output from " =set all", ":autocmd" etc.
  ["Visual"] = { bg = c.sub_blue }, -- Visual mode selection
  ["VisualNOS"] = { bg = c.sub_blue }, -- Visual mode selection when vim is "Not Owning the Selection". Only X11 Gui's gui-x11 and xterm-clipboard supports this.
  ["WarningMsg"] = { fg = c.pure_yellow }, -- warning messages
  ["WildMenu"] = { fg = c.black, bg = c.blue }, -- current match in 'wildmenu' completion
  ["Winbar"] = { fg = c.white, bg = c.gray2 }, -- Winbar
  ["WinbarNC"] = { fg = c.gray6, bg = c.black }, -- Winbar non-current windows.

  -- HTML
  ["htmlArg"] = { fg = c.green, italic = true }, -- attributes
  ["htmlEndTag"] = { fg = c.gray7 }, -- end tag />
  ["htmlTitle"] = { fg = c.gray8 }, -- title tag text
  ["htmlTag"] = { fg = c.gray7 }, -- tag delimiters
  ["htmlTagN"] = { fg = c.gray7 },
  ["htmlTagName"] = { fg = c.cyan }, -- tag text

  -- Markdown
  ["markdownH1"] = { fg = c.pure_blue, bold = true },
  ["markdownH2"] = { fg = c.pure_blue, bold = true },
  ["markdownH3"] = { fg = c.pure_blue, bold = true },
  ["markdownH4"] = { fg = c.pure_blue, bold = true },
  ["markdownH5"] = { fg = c.pure_blue, bold = true },
  ["markdownH6"] = { fg = c.pure_blue, bold = true },
  ["markdownHeadingDelimiter"] = { fg = c.gray6 },
  ["markdownHeadingRule"] = { fg = c.gray6 },
  ["markdownId"] = { fg = c.cyan },
  ["markdownIdDeclaration"] = { fg = c.blue },
  ["markdownIdDelimiter"] = { fg = c.cyan },
  ["markdownLinkDelimiter"] = { fg = c.gray6 },
  ["markdownLinkText"] = { fg = c.blue, italic = true },
  ["markdownListMarker"] = { fg = c.gray6 },
  ["markdownOrderedListMarker"] = { fg = c.gray6 },
  ["markdownRule"] = { fg = c.gray6 },
  ["markdownUrl"] = { fg = c.green, bg = c.none },
  ["markdownBlockquote"] = { fg = c.gray8 },
  ["markdownBold"] = { fg = c.white, bg = c.none, bold = true },
  ["markdownItalic"] = { fg = c.white, bg = c.none, italic = true },
  ["markdownCode"] = { fg = c.yellow },
  ["markdownCodeBlock"] = { fg = c.yellow },
  ["markdownCodeDelimiter"] = { fg = c.gray6 },

  -- Tree sitter
  ["@boolean"] = { fg = c.green },
  ["@constructor"] = { fg = c.green },
  ["@constant.builtin"] = { fg = c.green },
  ["@keyword.function"] = { fg = c.blue },
  ["@namespace"] = { fg = c.white },
  ["@parameter"] = { fg = c.white },
  ["@property"] = { fg = c.white },
  ["@punctuation"] = { fg = c.red },
  ["@punctuation.delimiter"] = { fg = c.red },
  ["@punctuation.bracket"] = { fg = c.red },
  ["@punctuation.special"] = { fg = c.red },
  ["@string.documentation"] = { fg = c.green },
  ["@string.regex"] = { fg = c.yellow },
  ["@string.escape"] = { fg = c.blue },
  ["@symbol"] = { fg = c.white },
  ["@tag"] = { fg = c.white },
  ["@tag.attribute"] = { fg = c.white },
  ["@tag.delimiter"] = { fg = c.yellow },
  ["@type.builtin"] = { fg = c.green },
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

  ["@markup.heading"] = { fg = c.gray7, bold = true },
  ["@markup.heading.1"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.1.marker"] = { link = "@comment" },
  ["@markup.heading.2"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.2.marker"] = { link = "@comment" },
  ["@markup.heading.3"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.3.marker"] = { link = "@comment" },
  ["@markup.heading.4"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.4.marker"] = { link = "@comment" },
  ["@markup.heading.5"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.5.marker"] = { link = "@comment" },
  ["@markup.heading.6"] = { fg = c.gray7, bold = true, italic = true },
  ["@markup.heading.6.marker"] = { link = "@comment" },
  ["@markup.link"] = { fg = c.gray7 },
  ["@markup.link.label"] = { fg = c.cyan },
  ["@markup.link.url"] = { fg = c.blue },
  ["@markup.list"] = { fg = c.gray6, bold = true },
  ["@markup.list.checked"] = { fg = c.gray6 },
  ["@markup.list.unchecked"] = { fg = c.gray6 },
  ["@markup.raw.block"] = { fg = c.gray6 },
  ["@markup.raw.delimiter"] = { fg = c.gray6 },
  ["@markup.quote"] = { fg = c.gray7 },
  ["@markup.strikethrough"] = { fg = c.gray5, strikethrough = true },

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
  ["diffOldFile"] = { fg = c.gray5 },
  ["diffNewFile"] = { fg = c.white },
  ["diffFile"] = { fg = c.gray6 },
  ["diffLine"] = { fg = c.cyan },
  ["diffIndexLine"] = { fg = c.purple },

  -- Hop
  ["HopNextKey"] = { fg = c.pure_yellow },
  ["HopNextKey1"] = { fg = c.pure_blue },
  ["HopNextKey2"] = { fg = c.pure_cyan },
  ["HopUnmatched"] = { fg = c.gray5 },
  ["HopCursor"] = { fg = c.pure_cyan },
  ["HopPreview"] = { fg = c.pure_blue },

  -- Cmp
  ["CmpItemAbbrDeprecated"] = { fg = c.gray5, strikethrough = true },
  ["CmpItemAbbrMatch"] = { fg = c.blue, bold = true },
  ["CmpItemAbbrMatchFuzzy"] = { fg = c.blue, bold = true },
  ["CmpItemMenu"] = { fg = c.gray8 },
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
  ["NavicIconsArray"] = { fg = c.gray7, bg = c.none },
  ["NavicIconsObject"] = { fg = c.gray7, bg = c.none },
  ["NavicIconsKey"] = { fg = c.blue, bg = c.none },
  ["NavicIconsKeyword"] = { fg = c.blue, bg = c.none },
  ["NavicIconsNull"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEnumMember"] = { fg = c.green, bg = c.none },
  ["NavicIconsStruct"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEvent"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsOperator"] = { fg = c.white, bg = c.none },
  ["NavicIconsTypeParameter"] = { fg = c.green, bg = c.none },
  ["NavicText"] = { fg = c.white, bg = c.none },
  ["NavicSeparator"] = { fg = c.gray7, bg = c.none },

  -- Notify
  ["NotifyBackground"] = { fg = c.white, bg = c.bg },
  ["NotifyERRORBorder"] = { fg = c.red, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBorder"] = { fg = c.yellow, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBorder"] = { fg = c.blue, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBorder"] = { fg = c.gray7, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBorder"] = { fg = c.cyan, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyERRORIcon"] = { fg = c.pure_red },
  ["NotifyWARNIcon"] = { fg = c.pure_yellow },
  ["NotifyINFOIcon"] = { fg = c.pure_blue },
  ["NotifyDEBUGIcon"] = { fg = c.gray6 },
  ["NotifyTRACEIcon"] = { fg = c.pure_cyan },
  ["NotifyERRORTitle"] = { fg = c.pure_red },
  ["NotifyWARNTitle"] = { fg = c.pure_yellow },
  ["NotifyINFOTitle"] = { fg = c.pure_blue },
  ["NotifyDEBUGTitle"] = { fg = c.gray6 },
  ["NotifyTRACETitle"] = { fg = c.pure_cyan },
  ["NotifyERRORBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },

  -- NeoTree
  ["NeoTreeFloatBorder"] = { fg = c.gray4, bg = c.black },
  ["NeoTreeFloatTitle"] = { fg = c.gray6, bg = c.gray8 },
  ["NeoTreeTitleBar"] = { fg = c.gray6, bg = c.gray2 },

  -- Telescope
  ["TelescopeBorder"] = { fg = c.white, bg = c.black },
  ["TelescopeNormal"] = { fg = c.white, bg = c.black },
  ["TelescopePreviewTitle"] = { fg = c.black, bg = c.green, bold = true },
  ["TelescopeResultsTitle"] = { fg = c.black, bg = c.blue },
  ["TelescopePromptTitle"] = { fg = c.black, bg = c.red, bold = true },
  ["TelescopePromptBorder"] = { fg = c.gray1, bg = c.gray1 },
  ["TelescopePromptNormal"] = { fg = c.white, bg = c.gray1 },
  ["TelescopePromptCounter"] = { fg = c.blue, bg = c.gray1 },
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
  ["DapUIBreakpointsDisabledLine"] = { fg = c.gray4 },
  ["DapUICurrentFrameName"] = { link = "DapUIBreakpointsCurrentLine" },
  ["DapUIStepOver"] = { fg = c.blue },
  ["DapUIStepInto"] = { fg = c.blue },
  ["DapUIStepBack"] = { fg = c.blue },
  ["DapUIStepOut"] = { fg = c.blue },
  ["DapUIStop"] = { fg = c.pure_cyan },
  ["DapUIPlayPause"] = { fg = c.pure_green },
  ["DapUIRestart"] = { fg = c.pure_green },
  ["DapUIUnavailable"] = { fg = c.gray4 },
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
