return {
  'laytan/cloak.nvim',
  opts = {
    cloak_character = "*",
    highlight_group = "Comment",
    patterns = {
      {
        file_pattern = {
          ".env*",
          "wrangler.toml",
          ".dev.vars"
        },
        -- This can also be a table of patterns to cloak,
        -- example: cloak_pattern = { ":.+", "-.+", } for yaml files.
        cloak_pattern = "=.+"
      },
    },
  }
}
