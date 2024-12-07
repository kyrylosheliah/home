
-- thanks to "mellow-theme/mellow.nvim" and "datsfilipe/nvim-colorscheme-template"

vim.g.transparent = false

-- default hl table and colors
local def = require(vim.g.username .. ".base.highlight_defaults")

M = {}

-- shade color (hex string, number, base) -> string (hex) @params color, value, base
local function shade(color, value, base)

  -- mix color (hex string, hex string, number) -> string (hex) @params fg, bg, alpha
  local function mix(fg, bg, alpha)

    -- hex_to_rgb (hex string) -> table (rgb) @params hex
    local function hex_to_rgb(hex)
      local hex_type = '[abcdef0-9][abcdef0-9]'
      local pat = '^#(' .. hex_type .. ')(' .. hex_type .. ')(' .. hex_type .. ')$'
      hex = string.lower(hex)
      assert(string.find(hex, pat) ~= nil, 'hex_to_rgb: invalid hex: ' .. tostring(hex))
      local red, green, blue = string.match(hex, pat)
      return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
    end

    bg = hex_to_rgb(bg)
    fg = hex_to_rgb(fg)
    local blendChannel = function(i)
      local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
      return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format('#%02X%02X%02X', blendChannel(1), blendChannel(2), blendChannel(3))
  end

  if vim.o.background == 'light' then
    if base == nil then
      base = '#000000'
    end
    return mix(color, base, math.abs(value))
  else
    if base == nil then
      base = '#ffffff'
    end
    return mix(color, base, math.abs(value))
  end
end


local c = {}
-- Saturation
c.sat = 0.7
-- Subtleness
c.sub = 0.25
-- Basic
c.bg = shade(def.c.Magenta, 0.1, def.c.Gray5)
c.fg = "LightYellow"
c.bg_dark = "Gray5"
-- Normal
c.black = "Black"
c.red = "LightCoral"
c.green = "LightGreen" --"SpringGreen" --"PaleGreen2"
c.blue = "DeepSkyBlue" --"DodgerBlue" --"LightSkyBlue"
c.yellow = "LightGoldenrod" --"Khaki" --"Wheat"
c.purple = "Violet" --"LightMagenta"
c.cyan = "Peru" --"Turquoise" --""
c.white = c.fg
-- Bright
c.bright_black = "Gray20"
c.bright_red = "Red"
c.bright_green = "X11Green"
c.bright_blue = "Blue"
c.bright_yellow = "Yellow"
c.bright_purple = "Magenta"
c.bright_cyan = "Cyan" -- "Aqua"
c.bright_white = "White"
-- Subtle
c.sub_black = "Gray5"
c.sub_red = shade(def.c[c.red], c.sub, c.bg)
c.sub_green = shade(def.c[c.green], c.sub, c.bg)
c.sub_blue = shade(def.c[c.blue], c.sub, c.bg)
c.sub_yellow = shade(def.c[c.yellow], c.sub, c.bg)
c.sub_purple = shade(def.c[c.purple], c.sub, c.bg)
c.sub_cyan = shade(def.c[c.cyan], c.sub, c.bg)
c.sub_white = shade(def.c[c.white], c.sub, c.bg)
-- Override saturation
c.black = "Gray5"
c.red = shade(def.c[c.red], c.sat, def.c[c.fg])
c.green = shade(def.c[c.green], c.sat, def.c[c.fg])
c.blue = shade(def.c[c.blue], c.sat, def.c[c.fg])
c.yellow = shade(def.c[c.yellow], c.sat, def.c[c.fg])
c.purple = shade(def.c[c.purple], c.sat, def.c[c.fg])
c.cyan = shade(def.c[c.cyan], c.sat, def.c[c.fg])
c.white = shade(def.c[c.white], c.sat, def.c[c.fg])
-- Gray
c.gray0 = "Gray15"
c.gray1 = "Gray20"
c.gray2 = "Gray25"
c.gray3 = "Gray30"
c.gray4 = "Gray35"
c.gray5 = "Gray40"
c.gray6 = "Gray45"
c.gray7 = "Gray50"
-- Special
c.none = "NONE"

local highlight = {
  ["Comment"] = { fg = c.gray7 }, -- any comment
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
  ["Operator"] = { fg = c.cyan }, -- sizeof", "+", "*", etc.
  ["Keyword"] = { fg = c.red }, -- any other keyword
  ["Exception"] = { fg = c.red }, -- try, catch, throw
  ["PreProc"] = { fg = c.red }, -- generic Preprocessor
  ["Include"] = { fg = c.red }, -- preprocessor #include
  ["Define"] = { fg = c.red }, -- preprocessor #define
  ["Macro"] = { fg = c.red }, -- same as Define
  ["PreCondit"] = { fg = c.red }, -- preprocessor #if, #else, #endif, etc.
  ["Type"] = { fg = c.blue }, -- int, long, char, etc.
  ["StorageClass"] = { fg = c.red }, -- static, register, volatile, etc.
  ["Structure"] = { fg = c.blue }, -- struct, union, enum, etc.
  ["Typedef"] = { fg = c.blue }, -- A typedef
  ["Special"] = { fg = c.red }, -- any special symbol
  ["SpecialChar"] = { fg = c.red }, -- special character in a constant
  ["Tag"] = { fg = c.bright_yellow }, -- you can use CTRL-] on this
  ["SpecialComment"] = { fg = c.bright_yellow }, -- special things inside a comment
  ["Debug"] = { fg = c.bright_green }, -- debugging statements
  ["Underlined"] = { underline = true }, -- text that stands out, HTML links
  ["Error"] = { fg = c.bright_red }, -- any erroneous construct
  ["Todo"] = { fg = c.bright_yellow }, -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX

  -- Highlighting Groups (descriptions and ordering from ` =h highlight-groups`) {{{
  ["ColorColumn"] = { bg = c.gray0 }, -- used for the columns set with 'colorcolumn'
  ["Conceal"] = { fg = c.gray4 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  ["Cursor"] = { fg = c.black, bg = c.fg }, -- the character under the cursor
  ["lCursor"] = { fg = c.black, bg = c.fg }, -- the character under the cursor
  ["CursorIM"] = { fg = c.black, bg = c.fg }, -- the character under the cursor
  ["CursorLine"] = { bg = c.gray0 }, -- the screen line that the cursor is in when 'cursorline' is set
  ["Directory"] = { fg = c.blue }, -- directory names (and other special names in listings)
  ["DiffAdd"] = { bg = c.green, fg = c.black }, -- diff mode: Added line
  ["DiffChange"] = { fg = c.yellow, underline = true }, -- diff mode: Changed line
  ["DiffDelete"] = { bg = c.red, fg = c.black }, -- diff mode: Deleted line
  ["DiffText"] = { bg = c.yellow, fg = c.black }, -- diff mode: Changed text within a changed line
  ["EndOfBuffer"] = { fg = c.gray0 }, -- '~' and '@' at the end of the window
  ["ErrorMsg"] = { fg = c.red }, -- error messages on the command line
  ["VertSplit"] = { fg = c.gray2 }, -- the column separating vertically split windows
  ["WinSeparator"] = { fg = c.gray2 }, -- the column separating vertically split windows
  ["Folded"] = { fg = c.gray4 }, -- line used for closed folds
  ["FoldColumn"] = { bg = vim.g.transparent and c.none or c.bg, fg = c.gray5 }, -- column where folds are displayed
  ["SignColumn"] = { fg = c.gray5 }, -- column where signs are displayed
  ["IncSearch"] = { fg = c.black, bg = c.bright_purple }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  ["CurSearch"] = { fg = c.bg, bg = c.bright_green }, -- 'cursearch' highlighting; also used for the text replaced with ":s///c"
  ["LineNr"] = { fg = c.gray2 }, -- Line number for " =number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  ["CursorLineNr"] = { fg = c.gray7, bg = c.gray0 }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
  ["MatchParen"] = { bg = c.bright_purple, fg = c.black, strikethrough = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match.
  ["ModeMsg"] = { fg = c.gray3, bold = true }, --' showmode' message (e.g., "-- INSERT --")
  ["MoreMsg"] = { fg = c.bright_purple }, -- more-prompt
  ["NonText"] = { fg = c.gray3 }, -- characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
  ["Normal"] = { fg = c.fg, bg = vim.g.transparent and c.none or c.bg }, -- normal text
  ["NormalNC"] = { fg = c.fg, bg = vim.g.transparent and c.none or c.bg_dark }, -- normal text
  ["NormalFloat"] = { fg = c.white, bg = c.gray0 }, -- Normal text in floating windows.
  ["FloatBorder"] = { fg = c.gray3, bg = c.bg }, -- Border of floating windows.
  ["Pmenu"] = { fg = c.white, bg = c.black }, -- Popup menu: normal item.
  ["PmenuSel"] = { fg = c.bright_white, bg = c.gray3 }, -- Popup menu: selected item.
  ["PmenuSbar"] = { bg = c.gray2 }, -- Popup menu: scrollbar.
  ["PmenuThumb"] = { bg = c.gray3 }, -- Popup menu: Thumb of the scrollbar.
  ["Question"] = { fg = c.blue }, -- hit-enter prompt and yes/no questions
  ["QuickFixLine"] = { fg = c.cyan, bg = c.gray2 }, -- Current quickfix item in the quickfix window.
  ["Search"] = { fg = c.bg, bg = c.bright_purple}, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
  ["SpecialKey"] = { fg = c.special_grey }, -- Meta and special keys listed with " =map", also for text used to show unprintable characters in the text, 'listchars'. Generally: text that is displayed differently from what it really is.
  ["SpellBad"] = { fg = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker. This will be combined with the highlighting used otherwise.
  ["SpellCap"] = { fg = c.yellow }, -- Word that should start with a capital. This will be combined with the highlighting used otherwise.
  ["SpellLocal"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is used in another region. This will be combined with the highlighting used otherwise.
  ["SpellRare"] = { fg = c.yellow }, -- Word that is recognized by the spellchecker as one that is hardly ever used. spell This will be combined with the highlighting used otherwise.
  ["StatusLine"] = { fg = c.bg, bg = c.fg }, -- status line of current window
  ["StatusLineNC"] = { fg = c.fg, bg = c.gray0 }, -- status lines of not-current windows Note = if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  ["StatusLineTerm"] = { fg = c.blue, bg = c.gray2 }, -- status line of current :terminal window
  ["StatusLineTermNC"] = { fg = c.black, bg = c.gray2 }, -- status line of non-current  =terminal window
  ["TabLine"] = { fg = c.gray5 }, -- tab pages line, not active tab page label
  ["TabLineFill"] = { bg = c.black }, -- tab pages line, where there are no labels
  ["TabLineSel"] = { fg = c.white }, -- tab pages line, active tab page label
  ["Terminal"] = { fg = c.fg, bg = c.black }, -- terminal window (see terminal-size-color)
  ["Title"] = { fg = c.green }, -- titles for output from " =set all", ":autocmd" etc.
  ["Visual"] = { bg = c.sub_blue }, -- Visual mode selection
  ["VisualNOS"] = { bg = c.sub_blue }, -- Visual mode selection when vim is "Not Owning the Selection". Only X11 Gui's gui-x11 and xterm-clipboard supports this.
  ["WarningMsg"] = { fg = c.bright_yellow }, -- warning messages
  ["WildMenu"] = { fg = c.black, bg = c.blue }, -- current match in 'wildmenu' completion
  ["Winbar"] = { fg = c.white, bg = c.gray1 }, -- Winbar
  ["WinbarNC"] = { fg = c.gray5, bg = c.bg_dark }, -- Winbar non-current windows.

  -- HTML
  ["htmlArg"] = { fg = c.bright_blue, italic = true }, -- attributes
  ["htmlEndTag"] = { fg = c.gray6 }, -- end tag />
  ["htmlTitle"] = { fg = c.gray7 }, -- title tag text
  ["htmlTag"] = { fg = c.gray6 }, -- tag delimiters
  ["htmlTagN"] = { fg = c.gray6 },
  ["htmlTagName"] = { fg = c.cyan }, -- tag text

  -- Markdown
  ["markdownH1"] = { fg = c.bright_blue, bold = true },
  ["markdownH2"] = { fg = c.bright_blue, bold = true },
  ["markdownH3"] = { fg = c.bright_blue, bold = true },
  ["markdownH4"] = { fg = c.bright_blue, bold = true },
  ["markdownH5"] = { fg = c.bright_blue, bold = true },
  ["markdownH6"] = { fg = c.bright_blue, bold = true },
  ["markdownHeadingDelimiter"] = { fg = c.gray5 },
  ["markdownHeadingRule"] = { fg = c.gray5 },
  ["markdownId"] = { fg = c.cyan },
  ["markdownIdDeclaration"] = { fg = c.blue },
  ["markdownIdDelimiter"] = { fg = c.cyan },
  ["markdownLinkDelimiter"] = { fg = c.gray5 },
  ["markdownLinkText"] = { fg = c.blue, italic = true },
  ["markdownListMarker"] = { fg = c.gray5 },
  ["markdownOrderedListMarker"] = { fg = c.gray5 },
  ["markdownRule"] = { fg = c.gray5 },
  ["markdownUrl"] = { fg = c.green, bg = c.none },
  ["markdownBlockquote"] = { fg = c.gray7 },
  ["markdownBold"] = { fg = c.fg, bg = c.none, bold = true },
  ["markdownItalic"] = { fg = c.fg, bg = c.none, italic = true },
  ["markdownCode"] = { fg = c.yellow },
  ["markdownCodeBlock"] = { fg = c.yellow },
  ["markdownCodeDelimiter"] = { fg = c.gray5 },

  -- Tree sitter
  ["@boolean"] = { fg = c.blue },
  ["@constructor"] = { fg = c.blue },
  ["@constant.builtin"] = { fg = c.blue },
  ["@keyword.function"] = { fg = c.red },
  ["@namespace"] = { fg = c.white },
  ["@parameter"] = { fg = c.white },
  ["@property"] = { fg = c.white },
  ["@punctuation"] = { fg = c.yellow },
  ["@punctuation.delimiter"] = { fg = c.yellow },
  ["@punctuation.bracket"] = { fg = c.yellow },
  ["@punctuation.special"] = { fg = c.yellow },
  ["@string.documentation"] = { fg = c.green },
  ["@string.regex"] = { fg = c.blue },
  ["@string.escape"] = { fg = c.red },
  ["@symbol"] = { fg = c.white },
  ["@tag"] = { fg = c.white },
  ["@tag.attribute"] = { fg = c.white },
  ["@tag.delimiter"] = { fg = c.yellow },
  ["@type.builtin"] = { fg = c.blue },
  ["@variable"] = { fg = c.white },
  ["@variable.builtin"] = { fg = c.white },
  ["@variable.parameter"] = { fg = c.white },
  -- Tree sitter language specific overrides
  ["@constructor.javascript"] = { fg = c.blue },
  ["@keyword.clojure"] = { fg = c.red },

  -- LSP Semantic Token Groups
  ["@lsp.type.boolean"] = { link = "@boolean" },
  ["@lsp.type.builtinType"] = { link = "@type.builtin" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
  ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
  ["@lsp.type.interface"] = { fg = c.blue },
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

  ["@markup.heading"] = { fg = c.gray6, bold = true },
  ["@markup.heading.1"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.1.marker"] = { link = "@comment" },
  ["@markup.heading.2"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.2.marker"] = { link = "@comment" },
  ["@markup.heading.3"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.3.marker"] = { link = "@comment" },
  ["@markup.heading.4"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.4.marker"] = { link = "@comment" },
  ["@markup.heading.5"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.5.marker"] = { link = "@comment" },
  ["@markup.heading.6"] = { fg = c.gray6, bold = true, italic = true },
  ["@markup.heading.6.marker"] = { link = "@comment" },
  ["@markup.link"] = { fg = c.gray6 },
  ["@markup.link.label"] = { fg = c.cyan },
  ["@markup.link.url"] = { fg = c.blue },
  ["@markup.list"] = { fg = c.gray5, bold = true },
  ["@markup.list.checked"] = { fg = c.gray5 },
  ["@markup.list.unchecked"] = { fg = c.gray5 },
  ["@markup.raw.block"] = { fg = c.gray5 },
  ["@markup.raw.delimiter"] = { fg = c.gray5 },
  ["@markup.quote"] = { fg = c.gray6 },
  ["@markup.strikethrough"] = { fg = c.gray4, strikethrough = true },

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
  ["GitSignsAdd"] = { fg = c.bright_green },
  ["GitSignsChange"] = { fg = c.bright_yellow },
  ["GitSignsDelete"] = { fg = c.bright_red },

  -- Diff
  ["diffAdded"] = { fg = c.bright_green },
  ["diffRemoved"] = { fg = c.bright_red },
  ["diffChanged"] = { fg = c.bright_yellow },
  ["diffOldFile"] = { fg = c.gray4 },
  ["diffNewFile"] = { fg = c.white },
  ["diffFile"] = { fg = c.gray5 },
  ["diffLine"] = { fg = c.cyan },
  ["diffIndexLine"] = { fg = c.purple },

  -- Hop
  ["HopNextKey"] = { fg = c.bright_yellow },
  ["HopNextKey1"] = { fg = c.bright_blue },
  ["HopNextKey2"] = { fg = c.bright_cyan },
  ["HopUnmatched"] = { fg = c.gray4 },
  ["HopCursor"] = { fg = c.bright_cyan },
  ["HopPreview"] = { fg = c.bright_blue },

  -- Cmp
  ["CmpItemAbbrDeprecated"] = { fg = c.gray7, strikethrough = true },
  ["CmpItemAbbrMatch"] = { fg = c.blue, bold = true },
  ["CmpItemAbbrMatchFuzzy"] = { fg = c.blue, bold = true },
  ["CmpItemMenu"] = { fg = c.gray5 },
  ["CmpItemKindText"] = { fg = c.bright_white },
  ["CmpItemKindFunction"] = { fg = c.white },
  ["CmpItemKindVariable"] = { fg = c.white },
  ["CmpItemKindEnum"] = { fg = c.white },
  ["CmpItemKindSnippet"] = { fg = c.yellow },

  -- Navic
  ["NavicIconsFile"] = { fg = c.fg, bg = c.none },
  ["NavicIconsModule"] = { fg = c.yellow, bg = c.none },
  ["NavicIconsNamespace"] = { fg = c.fg, bg = c.none },
  ["NavicIconsPackage"] = { fg = c.fg, bg = c.none },
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
  ["NavicIconsArray"] = { fg = c.gray6, bg = c.none },
  ["NavicIconsObject"] = { fg = c.gray6, bg = c.none },
  ["NavicIconsKey"] = { fg = c.blue, bg = c.none },
  ["NavicIconsKeyword"] = { fg = c.blue, bg = c.none },
  ["NavicIconsNull"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEnumMember"] = { fg = c.green, bg = c.none },
  ["NavicIconsStruct"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsEvent"] = { fg = c.cyan, bg = c.none },
  ["NavicIconsOperator"] = { fg = c.fg, bg = c.none },
  ["NavicIconsTypeParameter"] = { fg = c.green, bg = c.none },
  ["NavicText"] = { fg = c.white, bg = c.none },
  ["NavicSeparator"] = { fg = c.gray6, bg = c.none },

  -- Notify
  ["NotifyBackground"] = { fg = c.white, bg = c.bg },
  ["NotifyERRORBorder"] = { fg = c.red, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBorder"] = { fg = c.yellow, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBorder"] = { fg = c.blue, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBorder"] = { fg = c.gray6, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBorder"] = { fg = c.cyan, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyERRORIcon"] = { fg = c.bright_red },
  ["NotifyWARNIcon"] = { fg = c.bright_yellow },
  ["NotifyINFOIcon"] = { fg = c.bright_blue },
  ["NotifyDEBUGIcon"] = { fg = c.gray5 },
  ["NotifyTRACEIcon"] = { fg = c.bright_cyan },
  ["NotifyERRORTitle"] = { fg = c.bright_red },
  ["NotifyWARNTitle"] = { fg = c.bright_yellow },
  ["NotifyINFOTitle"] = { fg = c.bright_blue },
  ["NotifyDEBUGTitle"] = { fg = c.gray5 },
  ["NotifyTRACETitle"] = { fg = c.bright_cyan },
  ["NotifyERRORBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyWARNBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyINFOBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyDEBUGBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },
  ["NotifyTRACEBody"] = { fg = c.white, bg = vim.g.transparent and c.none or c.bg },

  -- NeoTree
  ["NeoTreeFloatBorder"] = { fg = c.gray3, bg = c.bg },
  ["NeoTreeFloatTitle"] = { fg = c.gray5, bg = c.gray7 },
  ["NeoTreeTitleBar"] = { fg = c.gray5, bg = c.gray1 },

  -- Telescope
  ["TelescopeBorder"] = { fg = c.bg, bg = c.bg },
  ["TelescopeNormal"] = { fg = c.fg, bg = c.bg },
  ["TelescopePreviewTitle"] = { fg = c.black, bg = c.green, bold = true },
  ["TelescopeResultsTitle"] = { fg = c.black, bg = c.blue },
  ["TelescopePromptTitle"] = { fg = c.black, bg = c.red, bold = true },
  ["TelescopePromptBorder"] = { fg = c.gray0, bg = c.gray0 },
  ["TelescopePromptNormal"] = { fg = c.white, bg = c.gray0 },
  ["TelescopePromptCounter"] = { fg = c.blue, bg = c.gray0 },
  ["TelescopeMatching"] = { fg = c.blue },

  -- Dap UI
  ["DapUINormal"] = { link = "Normal" },
  ["DapUIVariable"] = { link = "Normal" },
  ["DapUIScope"] = { fg = c.blue },
  ["DapUIType"] = { fg = c.purple },
  ["DapUIValue"] = { link = "Normal" },
  ["DapUIModifiedValue"] = { fg = c.blue, bold = true },
  ["DapUIDecoration"] = { fg = c.blue },
  ["DapUIThread"] = { fg = c.bright_green },
  ["DapUIStoppedThread"] = { fg = c.blue },
  ["DapUIFrameName"] = { link = "Normal" },
  ["DapUISource"] = { fg = c.purple },
  ["DapUILineNumber"] = { fg = c.blue },
  ["DapUIFloatNormal"] = { link = "NormalFloat" },
  ["DapUIFloatBorder"] = { fg = c.blue },
  ["DapUIWatchesEmpty"] = { fg = c.bright_cyan },
  ["DapUIWatchesValue"] = { fg = c.bright_green },
  ["DapUIWatchesError"] = { fg = c.bright_cyan },
  ["DapUIBreakpointsPath"] = { fg = c.blue },
  ["DapUIBreakpointsInfo"] = { fg = c.bright_green },
  ["DapUIBreakpointsCurrentLine"] = { fg = c.bright_green, bold = true },
  ["DapUIBreakpointsLine"] = { link = "DapUILineNumber" },
  ["DapUIBreakpointsDisabledLine"] = { fg = c.gray3 },
  ["DapUICurrentFrameName"] = { link = "DapUIBreakpointsCurrentLine" },
  ["DapUIStepOver"] = { fg = c.blue },
  ["DapUIStepInto"] = { fg = c.blue },
  ["DapUIStepBack"] = { fg = c.blue },
  ["DapUIStepOut"] = { fg = c.blue },
  ["DapUIStop"] = { fg = c.bright_cyan },
  ["DapUIPlayPause"] = { fg = c.bright_green },
  ["DapUIRestart"] = { fg = c.bright_green },
  ["DapUIUnavailable"] = { fg = c.gray3 },
  ["DapUIWinSelect"] = { fg = c.cyan, bold = true },
  ["DapUIEndofBuffer"] = { link = "EndofBuffer" },

  -- Flash
  ["FlashBackdrop"] = { link = "Comment" },
  ["FlashCurrent"] = { link = "IncSearch" },
  ["FlashCursor"] = { bg = c.bright_blue, fg = c.bg_dark, bold = true },
  ["FlashLabel"] = { bg = c.cyan, bold = true, fg = c.bg_dark },
  ["FlashMatch"] = { link = "Search" },
  ["FlashPrompt"] = { link = "MsgArea" },
  ["FlashPromptIcon"] = { link = "Special" },

}

return highlight
