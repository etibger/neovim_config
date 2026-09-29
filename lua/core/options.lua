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
vim.opt.signcolumn = "yes"
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
vim.opt.tagrelative = false
if require("core.workspace").work then
  vim.opt.tags = { "tags/gpu_design", "tags/gpu_verif" }
end
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

vim.g.transparent = true

local trailing_whitespace_group = "TrailingWhitespace"
local trailing_whitespace_match_var = "trailing_whitespace_match_id"

local function set_trailing_whitespace_highlight()
  vim.api.nvim_set_hl(0, trailing_whitespace_group, {
    bg = "#ff005f",
    fg = "#ffffff",
    bold = true,
  })
end

local function highlight_trailing_whitespace()
  local win = vim.api.nvim_get_current_win()
  local match_id = vim.w[trailing_whitespace_match_var]

  if match_id then
    for _, match in ipairs(vim.fn.getmatches(win)) do
      if match.id == match_id then
        return
      end
    end
  end

  vim.w[trailing_whitespace_match_var] =
    vim.fn.matchadd(trailing_whitespace_group, [[\s\+$]], 100, -1, { window = win })
end

local trailing_whitespace_group_id = vim.api.nvim_create_augroup("trailing-whitespace", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = trailing_whitespace_group_id,
  callback = set_trailing_whitespace_highlight,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = trailing_whitespace_group_id,
  callback = highlight_trailing_whitespace,
})

set_trailing_whitespace_highlight()
highlight_trailing_whitespace()

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
