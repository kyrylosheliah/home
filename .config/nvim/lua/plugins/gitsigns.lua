return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function(_, opts)
    local gitsigns = require('gitsigns')
    if opts ~= nil then
      gitsigns.setup(opts)
    end
    require("base.command").add_submenu_commands("git", {
      {
        name = "next git diff hunk", description = "Git Signs: jump to the next hunk",
        cmd = function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end,
      },
      {
        name = "previous git diff hunk", description = "Git Signs: jump to the previous hunk",
        cmd = function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end,
      },
      { name = "stage git diff hunk", cmd = gitsigns.stage_hunk, },
      { name = "reset git diff hunk", cmd = gitsigns.reset_hunk, },
      {
        name = "stage git diff hunk block",
        cmd = function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      {
        name = "reset git diff hunk block",
        cmd = function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      { name = "stage git buffer", cmd = gitsigns.stage_buffer, },
      { name = "undo git hunk staging", cmd = gitsigns.undo_stage_hunk, },
      { name = "reset git buffer", cmd = gitsigns.reset_buffer, },
      { name = "preview hunk", cmd = gitsigns.preview_hunk, },
      { name = "blame line", cmd = function() gitsigns.blame_line() end, },
      { name = "toggle line blame", cmd = gitsigns.toggle_current_line_blame, },
      --{ name = "diff line", cmd = gitsigns.diffthis, },
      --{ name = "diff file", cmd = function() gitsigns.diffthis('~') end, },
      { name = "toggle deleted diff", cmd = gitsigns.toggle_deleted, },
      { name = "select hunk", cmd = gitsigns.select_hunk, },
    })
  end,
}
