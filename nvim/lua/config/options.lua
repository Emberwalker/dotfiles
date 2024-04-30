-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local function expandEnsure(path)
	local expanded = vim.fn.expand(path)
	if not vim.fn.isdirectory(expanded) then
		vim.fn.mkdir(expanded, "p")
	end
	return expanded
end

local set = vim.opt

-- persistent undo
if vim.fn.has("+undofile") then
	set.undofile = true
	set.undodir = expandEnsure("~/.nvim/undo")
end

-- backups
set.backup = true
set.backupdir = expandEnsure("~/.nvim/backup")

-- swap files
set.directory = expandEnsure("~/.nvim/swap")
set.swapfile = false

set.modeline = false -- modelines have security risks associated with them
set.showmatch = true -- highlight matching pairs

if not vim.g.vscode then
	set.colorcolumn = "120" -- mark column 120 for a sensible guide for max line length
end

-- Make line numbers default and make relative
set.number = true
set.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
set.mouse = 'a'

-- Don't show the mode, since it's already in the status line
set.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
set.clipboard = 'unnamedplus'

-- Enable break indent
set.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set.ignorecase = true
set.smartcase = true

-- Keep signcolumn on by default
set.signcolumn = 'yes'

-- Decrease update time
set.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
set.timeoutlen = 300

-- Configure how new splits should be opened
set.splitright = true
set.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
set.list = true
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
set.inccommand = 'split'

-- Show which line your cursor is on
set.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
set.scrolloff = 10
