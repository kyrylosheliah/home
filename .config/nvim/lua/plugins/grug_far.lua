return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = function(_, opts)
    -- TODO:
    --Launch with the current word under the cursor as the search string
    --:lua require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } })
    --Launch with ast-grep engine
    --:lua require('grug-far').open({ engine = 'astgrep' })
    --Launch as a transient buffer which is both unlisted and fully deletes itself when not in use
    --:lua require('grug-far').open({ transient = true })
    --Launch, limiting search/replace to current file
    --:lua require('grug-far').open({ prefills = { paths = vim.fn.expand("%") } })
    --Launch with the current visual selection, searching only current file
    --:<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
    --Launch, limiting search to the current buffer visual selection range
    --:GrugFarWithin
    --or as a keymap if you want to go fully lua:
    --vim.keymap.set({ 'n', 'x' }, '<leader>si', function()
    --  require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
    --end, { desc = 'grug-far: Search within range' })

    -- TODO: figure out binding commands for lazily unloaded plugins
    local grug_far = require('grug-far')
    vim.g.add_commands({
      { name = "grug far", cmd = grug_far.open, },
    })

    return { headerMaxWidth = 80 }
  end,
}
