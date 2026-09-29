-- No plugin manager, installs, LSP servers, Git watchers or project indexing.
-- Netrw and native completion/tags remain available, with work tools on demand.
vim.opt.loadplugins = false
vim.opt.clipboard = ""
vim.opt.cursorcolumn = false
vim.opt.showtabline = 1
vim.opt.showmode = true
vim.opt.cmdheight = 1
vim.opt.signcolumn = "no"
vim.opt.updatetime = 1000
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
-- loadplugins=false also skips bundled netrw's commands.
vim.cmd("runtime! plugin/netrwPlugin.vim")
local map = vim.keymap.set
map("n", "<leader>e", "<cmd>Lex 30<cr>", { desc = "Explore files (netrw)" })
map("n", "-", "<cmd>Explore %:p:h<cr>", { desc = "Explore parent directory" })
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<leader>b", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
