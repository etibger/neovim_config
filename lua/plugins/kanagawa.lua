return {
  -- Katsushika Hokusai colorscheme
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      compile = true,
      theme = "dragon", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    })
    -- setup must be called before loading
    vim.cmd("colorscheme kanagawa")
  end,
  build = function()
    vim.cmd("KanagawaCompile")
  end,
}
