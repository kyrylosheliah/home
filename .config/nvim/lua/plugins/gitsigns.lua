return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function(_, opts)
    local gitsigns = require('gitsigns')
    if opts ~= nil then
      gitsigns.setup(opts)
    end
    require("base.command").add_menu_commands("git", {
      {
        name = "next hunk", description = "Git Signs: jump to the next hunk",
        cmd = function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end,
      },
      {
        name = "previous hunk", description = "Git Signs: jump to the previous hunk",
        cmd = function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end,
      },
      { name = "stage hunk", cmd = gitsigns.stage_hunk, },
      { name = "reset hunk", cmd = gitsigns.reset_hunk, },
      {
        name = "stage hunk",
        cmd = function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      {
        name = "reset hunk",
        cmd = function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      { name = "stage buffer", cmd = gitsigns.stage_buffer, },
      { name = "undo hunk staging", cmd = gitsigns.reset_hunk, },
      { name = "reset buffer", cmd = gitsigns.reset_buffer, },
      { name = "preview hunk", cmd = gitsigns.preview_hunk, },
      { name = "blame line", cmd = gitsigns.blame_line, },
      { name = "toggle line blame", cmd = gitsigns.toggle_current_line_blame, },
      { name = "diff line", cmd = gitsigns.diffthis, },
      --{ name = "diff file", cmd = function() gitsigns.diffthis('~') end, },
      { name = "toggle hunk", cmd = gitsigns.preview_hunk_inline, },
      { name = "select hunk", cmd = gitsigns.select_hunk, },
    })
  end,
}
