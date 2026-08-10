-- ========================================================================== --
--                           MINIMAL REMOTE SERVER CONFIG                     --
-- ========================================================================== --

-- Change leader key to Space
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ========================================================================== --
--                                   OPTIONS                                  --
-- ========================================================================== --
local opt = vim.opt

-- Line numbers
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Use relative line numbers for easier jumping

-- Tabs & Indentation
opt.tabstop = 4            -- Number of spaces a tab counts for
opt.softtabstop = 4        -- Number of spaces a tab counts for while editing
opt.shiftwidth = 4         -- Size of an indent
opt.expandtab = true       -- Turn tabs into spaces
opt.smartindent = true     -- Insert indents automatically

-- Search UI
opt.ignorecase = true      -- Ignore case in search patterns
opt.smartcase = true       -- Override ignorecase if search contains capitals
opt.incsearch = true       -- Show match while typing search pattern
opt.hlsearch = false       -- Clear highlight after search finishes

-- Performance & Reliability (Crucial for remote servers)
opt.swapfile = false       -- Disable swap files (prevents annoying prompt drops)
opt.backup = false         -- Disable backup files
opt.undofile = true        -- Enable persistent undo history across sessions

-- Visual Comfort
opt.termguicolors = true   -- Enable 24-bit RGB colors
opt.signcolumn = "yes"     -- Always show the sign column to prevent shifting text
opt.scrolloff = 8          -- Keep at least 8 lines visible above/below cursor
opt.splitright = true      -- Vertical splits open to the right
opt.splitbelow = true      -- Horizontal splits open below

vim.wo.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.mouse = "a"
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
vim.o.cursorline = true -- Highlight the current line
vim.opt.cursorcolumn = true -- Highlight the current column
vim.o.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.o.splitright = true -- Force all vertical splits to go to the right of current window (default: false)
vim.o.hlsearch = true -- Set highlight on search (default: true)
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore (default: true)
vim.opt.termguicolors = true -- Set termguicolors to enable highlight groups (default: false)
vim.o.whichwrap = "bs<>[]hl" -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
vim.o.numberwidth = 4 -- Set number column width to 2 {default 4} (default: 4)
vim.o.swapfile = false -- Creates a swapfile (default: true)
vim.o.smartindent = true -- Make indenting smarter again (default: false)
vim.o.showtabline = 2 -- Always show tabs (default: 1)
vim.o.backspace = "indent,eol,start" -- Allow backspace on (default: 'indent,eol,start')
vim.o.pumheight = 10 -- Pop up menu height (default: 0)
vim.o.conceallevel = 0 -- So that `` is visible in markdown files (default: 1)
vim.wo.signcolumn = "no" -- Keep signcolumn on by default (default: 'auto')
vim.o.fileencoding = "utf-8" -- The encoding written to a file (default: 'utf-8')
vim.o.cmdheight = 1 -- More space in the Neovim command line for displaying messages (default: 1)
vim.o.breakindent = true -- Enable break indent (default: false)
vim.o.updatetime = 250 -- Decrease update time (default: 4000)
vim.o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.backup = false -- Creates a backup file (default: false)
vim.o.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile = true -- Save undo history (default: false)
vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience (default: 'menu,preview')
vim.opt.shortmess:append("c") -- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.iskeyword:append("-") -- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)
vim.opt.ignorecase = false
vim.opt.tagrelative = false
vim.opt.tags = { "tags/gpu_design", "tags/gpu_verif" }

-- Remove '-' character from keywords for preventing included in tag lookups
local api = vim.api
local fileTypeSettings = api.nvim_create_augroup("FileTypeSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "systemverilog", "sv" },
  callback = function()
    vim.opt_local.iskeyword = vim.opt_local.iskeyword - "-"
  end,
  group = fileTypeSettings,
})
-- Use spelling for markdown files ‘]s’ to find next, ‘[s’ for previous, 'z=‘ for suggestions when on one.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
-- Disable commandline until it is needed. This gives us a cleaner look and an extra line ;)
vim.opt.cmdheight = 0

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Whether transparency is enabled
vim.g.transparent_enabled = true

-- ========================================================================== --
--                                 KEYMAPS                                    --
-- ========================================================================== --
local key = vim.keymap

-- Quick buffer navigation (No tabline plugin needed)
key.set("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
key.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })

-- Keep cursor centered during large jumps
key.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
key.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- File Explorer (Netrw)
key.set("n", "<leader>e", ":Lex 30<CR>", { desc = "Toggle netrw file explorer" })

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

-- copy full file path into + register and notify
vim.keymap.set("n", "<leader>yp", function()
  local fullpath = vim.fn.expand("%:p")
  vim.fn.setreg("+", fullpath)
  vim.notify("Copied path: " .. fullpath, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Copy full file path" })

-- copy path relative to nvim's start directory into + register and notify
vim.keymap.set("n", "<leader>yr", function()
  local rel = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  vim.fn.setreg("+", rel)
  vim.notify("Copied relative path: " .. rel, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Copy file path relative to cwd" })

-- ========================================================================== --
--                                AUTOCOMMANDS                                --
-- ========================================================================== --
-- Briefly highlight yanked text (Great visual feedback over high-latency SSH)
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Netrw Explorer Customization (Built-in file explorer)
vim.g.netrw_banner = 0       -- Hide the massive, useless banner
vim.g.netrw_liststyle = 3    -- Use tree-style view
vim.g.netrw_winsize = 25     -- Limit initial window width

