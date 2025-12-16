return {
  -- Katsushika Hokusai colorscheme
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = true,
      theme = "dragon", -- Load "wave" theme
      transparent = true,
      dimInactive = true,
      background = {     -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
      statementStyle = { bold = false },
      typeStyle = {},
    })
    -- setup must be called before loading
    vim.cmd("colorscheme kanagawa")
  end,
  build = function()
    vim.cmd("KanagawaCompile")
  end,
}
