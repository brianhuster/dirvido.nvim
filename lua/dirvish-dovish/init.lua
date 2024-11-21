local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local utils = require('dirvish-dovish.utils')
local api = vim.api

local M = {}

M.config = {}

local sep = utils.sep

local function Dirvish()
	vim.cmd.Dirvish()
end

local function moveCursorTo(target)
	fn.search('\\V' .. fn.escape(target, '\\') .. '\\$')
end

local function getVisualSelectedLines()
	local line_start = api.nvim_buf_get_mark(0, "<")[1]
	local line_end = api.nvim_buf_get_mark(0, ">")[1]

	if line_start > line_end then
		line_start, line_end = line_end, line_start
	end

	--- Nvim API indexing is zero-based, end-exclusive
	local lines = api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

	return lines
end


local function get_register()
	local reg = vim.fn.getreg()
	return vim.split(reg, '\n', { trimempty = true })
end

M.mkfile = function()
	local filename = fn.input('Enter filename: ')
	filename = vim.trim(filename)
	if #filename == 0 then
		return
	end
	vim.cmd.edit("%" .. filename)
	vim.cmd.write()
	Dirvish()
end

M.mkdir = function()
	local dirname = fn.input('Directory name : ')
	dirname = vim.trim(dirname)
	if #dirname == 0 then
		return
	end
	local dirpath = fs.joinpath(fn.expand("%"), dirname)
	local success, errname, errmsg = uv.fs_mkdir(dirpath, 493)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	else
		Dirvish()
		moveCursorTo(dirname .. sep)
	end
end

function M.rename()
	local target = vim.trim(fn.getline('.'))
	local isDir = target:sub(-1) == sep
	local filename = fs.basename(target)
	local newname = fn.input('Enter new name: ', filename)
	if not newname or #newname == 0 or vim.trim(newname) == target then
		return
	end
	local newpath = fs.joinpath(fn.expand('%'), newname)
	local success, errname, errmsg = uv.fs_rename(target, newpath)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	else
		Dirvish()
		if isDir then
			moveCursorTo(newname .. sep)
		else
			moveCursorTo(newname)
		end
	end
end

local function copyfile(file, newpath)
	local success, errname, errmsg = uv.fs_copyfile(file, newpath)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	else
		Dirvish()
		moveCursorTo(fs.basename(newpath))
	end
end

-- Copy dir recursively
local function copydir(dir, newpath)
	local handle = uv.fs_scandir(dir)
	if not handle then
		return
	end
	local success, errname, errmsg = uv.fs_mkdir(newpath, 493)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		local filepath = fs.joinpath(dir, name)
		if type == "directory" then
			copydir(filepath, fs.joinpath(newpath, name))
		else
			copyfile(filepath, fs.joinpath(newpath, name))
		end
	end
end

M.copy = function()
	local targets = get_register()
	if #targets == 0 then
		return
	end
	local new_dir = fn.expand("%")
	for _, target in ipairs(targets) do
		local isDir = target:sub(-1) == sep
		local newpath = fs.joinpath(new_dir, fs.basename(target:sub(1, #target - 1)))
		print('target', target)
		print('new_dir', new_dir)
		print('newpath', newpath)
		if isDir then
			copydir(target, newpath)
		else
			copyfile(target, newpath)
		end
	end
	Dirvish()
end

M.move = function()
	local targets = get_register()
	if #targets == 0 then
		return
	end
	local new_dir = fn.expand("%")
	for _, target in ipairs(targets) do
		local isDir = target:sub(-1) == sep
		local newpath = fs.joinpath(new_dir, fs.basename(target))
		local success, errname, errmsg = uv.fs_rename(target, newpath)
		if not success then
			vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
		else
			Dirvish()
			if isDir then
				moveCursorTo(fs.basename(newpath) .. sep)
			else
				moveCursorTo(fs.basename(newpath))
			end
		end
	end
end

M.vremove = function()
	local lines = getVisualSelectedLines()
	if #lines == 0 then
		return
	end
	local check = fn.confirm("Delete " .. vim.inspect(lines), "&Yes\n&No", 2)
	if check ~= 1 then
		print("Cancelled")
		return
	end
	for _, line in ipairs(lines) do
		utils.rm(line)
	end
	Dirvish()
end

function M.nremove()
	local line = vim.trim(fn.getline('.'))
	local check = fn.confirm("Delete " .. line, "&Yes\n&No", 2)
	if check ~= 1 then
		print("Cancelled")
		return
	end
	utils.rm(line)
	Dirvish()
end

function M.setup(opts)
	local default_opts = { disable_default_keymaps = false }
	M.config = vim.tbl_extend("force", default_opts, opts or {})
end

return M
