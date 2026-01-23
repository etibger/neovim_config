return {
  "github/copilot.vim",
  lazy = false, -- load immediately
  config = function()
    -- Optional: disable Copilot's default <Tab> mapping
    vim.g.copilot_no_tab_map = true

    -- Optional: custom accept key
    vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })

    -- Optional: filetypes control (default is all)
    -- vim.g.copilot_filetypes = {
    --   markdown = true,
    --   lua = true,
    --   ["*"] = true,
    -- }
  end,
}
