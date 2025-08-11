return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --opts = {
  --  on_attach = function(buffer)
  --    local gitsigns = require('gitsigns')
  --    local function map(mode, l, r, opts)
  --      opts = opts or {}
  --      opts.buffer = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  --      vim.keymap.set(mode, l, r, opts)
  --    end
  --    -- ...
  --  end,
  --},
  config = function(_, opts)
    local gitsigns = require('gitsigns')
    vim.g.add_commands({
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
        name = "prev git diff hunk", description = "Git Signs: jump to the previous hunk",
        cmd = function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end,
      },
      { name = "stage git diff hunk", description = "", cmd = gitsigns.stage_hunk, },
      { name = "reset git diff hunk", description = "", cmd = gitsigns.reset_hunk, },
      {
        name = "stage git diff hunk block", description = "",
        cmd = function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      {
        name = "reset git diff hunk block", description = "",
        cmd = function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
      },
      { name = "stage git buffer", description = "", cmd = gitsigns.stage_buffer, },
      { name = "undo git hunk staging", description = "", cmd = gitsigns.undo_stage_hunk, },
      { name = "reset git buffer", description = "", cmd = gitsigns.reset_buffer, },
      { name = "preview hunk", description = "", cmd = gitsigns.preview_hunk, },
      { name = "blame line", description = "", cmd = function() gitsigns.blame_line() end, },
      { name = "toggle line blame", description = "", cmd = gitsigns.toggle_current_line_blame, },
      { name = "diff line", description = "", cmd = gitsigns.diffthis, },
      { name = "diff file", description = "", cmd = function() gitsigns.diffthis('~') end, },
      { name = "toggle deleted diff", description = "", cmd = gitsigns.toggle_deleted, },
      { name = "select hunk", description = "", cmd = gitsigns.select_hunk, },
    })
  end,
}
