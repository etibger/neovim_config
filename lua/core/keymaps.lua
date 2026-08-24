vim.g.mapleader = ","
vim.g.maplocalleader = ","

local map = vim.keymap.set
local opts = { silent = true }

map("i", "jk", "<Esc>", opts)
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
map("n", "<leader>pp", "<cmd>setlocal paste!<cr>", opts)
map("n", "<leader>sn", "<cmd>noautocmd write<cr>", { desc = "Save without autocommands" })

map("n", "<Up>", "<cmd>resize -2<cr>", opts)
map("n", "<Down>", "<cmd>resize +2<cr>", opts)
map("n", "<Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<Right>", "<cmd>vertical resize +2<cr>", opts)

map("n", "<Tab>", "<cmd>bnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>x", "<cmd>bdelete!<cr>", { desc = "Delete buffer" })

map("n", "<leader>v", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>h", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>xs", "<cmd>close<cr>", { desc = "Close window" })

map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

map("n", "<leader>lw", "<cmd>setlocal wrap!<cr>", { desc = "Toggle line wrapping" })
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map("n", "\\d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", ";d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics location list" })
map("n", "<leader><CR>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<leader>ot", "<cmd>split term://zsh<cr>", { desc = "Open terminal" })
map("n", "<leader>nt", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative numbers" })
map("n", "<leader>sc", "<cmd>setlocal spell<cr>", { desc = "Enable spell checking" })
map("n", "<leader>nsc", "<cmd>setlocal nospell<cr>", { desc = "Disable spell checking" })
map("n", "<leader>tsc", function()
  vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
end, { desc = "Toggle sign column" })

map("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
map("n", ";s", "]s", { desc = "Next misspelling" })
map("n", "\\s", "[s", { desc = "Previous misspelling" })

local function toggle_transparency()
  vim.g.transparent = not vim.g.transparent
  if vim.g.transparent then
    vim.cmd([[highlight Normal guibg=none]])
    vim.cmd([[highlight NormalFloat guibg=none]])
  else
    vim.cmd([[highlight Normal guifg=#c5c9c5 guibg=#181616]])
    vim.cmd([[highlight NormalFloat guifg=#c5c9c5 guibg=#181616]])
  end
end

map("n", "<leader>tt", toggle_transparency, { desc = "Toggle transparency" })
map("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end, { desc = "Copy absolute file path" })
map("n", "<leader>yr", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative path: " .. path)
end, { desc = "Copy relative file path" })
