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
set.smartcase = true -- case-sensitive if there's a capital letter
set.showmatch = true -- highlight matching pairs

if not vim.g.vscode then
	set.colorcolumn = "120" -- mark column 120 for a sensible guide for max line length
end
