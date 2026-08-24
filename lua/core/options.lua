vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.whichwrap = "bs<>[]hl"
vim.opt.swapfile = false
vim.opt.smartindent = true
vim.opt.showtabline = 2
vim.opt.pumheight = 10
vim.opt.signcolumn = "no"
vim.opt.breakindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.cmdheight = 0
vim.opt.scrolloff = 5
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.tags = { "tags/gpu_design", "tags/gpu_verif" }
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

vim.g.transparent = true

local filetype_group = vim.api.nvim_create_augroup("filetype-settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = { "systemverilog", "sv" },
  callback = function()
    vim.opt_local.iskeyword:remove("-")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = { "html", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
