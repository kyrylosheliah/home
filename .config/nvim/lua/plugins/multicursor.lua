return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({"n", "x"}, "<leader>k", function() mc.lineAddCursor(-1) end, { desc = "Add cursor here and one line above" })
    set({"n", "x"}, "<leader>j", function() mc.lineAddCursor(1) end, { desc = "Add cursor here and one line below" })
    set({"n", "x"}, "<leader>K", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor here and add one above" })
    set({"n", "x"}, "<leader>J", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor here and add one below" })

    -- Add or skip adding a new cursor by matching word/selection
    set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add cursor here and at the start of the next match" })
    set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Add cursor here and at the start of the previous match" })
    set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip current cursor match and add one for the next" })
    set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "Skip current cursor match and add one for the previous" })

    -- Disable and enable cursors.
    set({"n", "x"}, "<leader>m", mc.toggleCursor, { desc = "Toggle multicursor here" })

    -- (prefer toggling on text cursor)
    -- Add and remove cursors with control + left click.
    --set("n", "<a-leftmouse>", mc.handleMouse)
    --set("n", "<a-leftdrag>", mc.handleMouseDrag)
    --set("n", "<a-leftrelease>", mc.handleMouseRelease)

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)

      -- Select a different cursor as the main one.
      layerSet({"n", "x"}, "n", mc.nextCursor, { desc = "Make next cursor the main one" })
      layerSet({"n", "x"}, "N", mc.prevCursor, { desc = "Make previous cursor the main one" })

      -- Delete the main cursor.
      layerSet({"n", "x"}, "m", mc.deleteCursor, { desc = "Delete main cursor" })

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Enable or clear multicursors" })
    end)

    -- Customize how cursors look.
    --local hl = vim.api.nvim_set_hl
    --hl(0, "MultiCursorCursor", { reverse = true })
    --hl(0, "MultiCursorVisual", { link = "Visual" })
    --hl(0, "MultiCursorSign", { link = "SignColumn"})
    --hl(0, "MultiCursorMatchPreview", { link = "Search" })
    --hl(0, "MultiCursorDisabledCursor", { reverse = true })
    --hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    --hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
  end,
}
