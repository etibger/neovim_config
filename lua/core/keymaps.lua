-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- For conciseness
local opts = { noremap = true, silent = true }

-- remap jk to leave insert mode
vim.api.nvim_set_keymap("i", "jk", "<Esc>", opts)
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {})

vim.keymap.set("n", "<leader>pp", ":setlocal paste!<cr>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Diagnostic keymaps
vim.keymap.set("n", "\\d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", ";d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { desc = "Cleare highlight" })
vim.keymap.set(
  "n",
  "<leader>se",
  ":VenvSelect fd 'python$' /opt/homebrew/anaconda3/envs/ --full-path -IH -a",
  { desc = "set python venv" }
)

--open zsh term split
vim.keymap.set("n", "<leader>ot", ":split term://zsh<CR>", opts)

-- toggle number relativeness
vim.keymap.set("n", "<leader>nt", function()
  if vim.o.relativenumber then
    vim.o.relativenumber = false
  else
    vim.o.relativenumber = true
  end
end, { desc = "Toggle relative number" })

-- spellcheck toggle
vim.keymap.set("n", "<leader>sc", ":setlocal spell<CR>", { desc = "Enable spellcheck" })
vim.keymap.set("n", "<leader>nsc", ":set nospell<CR>", { desc = "Disable spellcheck" })

-- signcolumn toggle
vim.api.nvim_set_keymap(
  "n",
  "<Leader>tsc",
  ':lua vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"<CR>',
  { noremap = true, silent = true }
)

-- undotree
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle UndotreeToggle" })
-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Spell check
vim.keymap.set("n", ";s", "]s", { desc = "Move to next misspelled word" })
vim.keymap.set("n", "\\s", "[s", { desc = "Move to previous misspelled word" })

--
vim.g.transparent = false

local function toggle_transparent()
  vim.g.transparent = not vim.g.transparent
  if vim.g.transparent then
    vim.cmd([[hi Normal guibg=none]])
    vim.cmd([[hi NormalFloat guibg=none]])
  else
    vim.cmd([[hi Normal guifg=#c5c9c5 guibg=#181616]])
    vim.cmd([[hi NormalFloat guifg=#c5c9c5 guibg=#181616]])
  end
end

vim.keymap.set("n", "<leader>tt", toggle_transparent, { desc = "Toggle transparency setting" })
