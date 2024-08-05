require("ibl").setup({
  debounce = 0,
  indent = {
    highlight = {"VertSplit"},
    char = "▎",
  },
  whitespace = {
    --highlight = { "@markup.link.label" },
    --remove_blankline_trail = true,
  },
  scope = {
    --highlight = {"Identifier"},
    highlight = {"VertSplit"},
    include = { node_type = { ["*"] = {"*"} } },
    char = "▌",
    show_end = false,
    show_start = false,
  },
})
