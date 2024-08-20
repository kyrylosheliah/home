return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    on_attach = function(buffer)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = "next hunk" })

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = "prev hunk" })

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "hunk stage" })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "hunk reset" })
      map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "hunk stage" })
      map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "hunk reset" })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "hunk Stage ... buffer" })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "hunk undo .. stage" })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "hunk reset ... buffer" })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "hunk preview" })
      map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { desc = "... blame line" })
      map('n', '<leader>htb', gitsigns.toggle_current_line_blame, { desc = "... toggle current line blame" })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = "... diff" })
      map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = "... diff ~" })
      map('n', '<leader>htd', gitsigns.toggle_deleted, { desc = "... toggle deleted" })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "inside hunk" })
    end,
  },
}
