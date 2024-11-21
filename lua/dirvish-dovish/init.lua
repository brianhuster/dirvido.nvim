local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local utils = require('dirvish-dovish.utils')

local M = {}

M.config = {}

local sep = utils.sep

local function reload()
	vim.cmd.Dirvish()
end

local function moveCursorTo(target)
	fn.search('\\V' .. fn.escape(target, '\\') .. '\\$')
end

local function getVisualSelection()
	local line_start, column_start, line_end, column_end
	if fn.mode() == "v" or fn.mode() == "V" then
		line_start, column_start = unpack(vim.fn.getpos("v"), 2, 3)
		line_end, column_end = unpack(vim.fn.getpos("."), 2, 3)
	else
		line_start, column_start = unpack(vim.fn.getpos("'<"), 2, 3)
		line_end, column_end = unpack(vim.fn.getpos("'>"), 2, 3)
	end

	if (vim.fn.line2byte(line_start) + column_start) > (vim.fn.line2byte(line_end) + column_end) then
		line_start, column_start, line_end, column_end = line_end, column_end, line_start, column_start
	end

	local lines = vim.fn.getline(line_start, line_end)
	if #lines == 0 then
		return ''
	end

	lines[#lines] = string.sub(lines[#lines], 1, column_end - 1)
	lines[1] = string.sub(lines[1], column_start - 1)
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
	vim.cmd.edit(filename)
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
		reload()
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
		reload()
		if isDir then
			moveCursorTo(newname .. sep)
		else
			moveCursorTo(newname)
		end
	end
end

function M.copyfile(file, newpath)
	local success, errname, errmsg = uv.fs_copyfile(file, newpath)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	else
		reload()
		moveCursorTo(fs.basename(newpath))
	end
end

-- Copy dir recursively
function M.copydir(dir, newpath)
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
			M.copydir(filepath, fs.joinpath(newpath, name))
		else
			M.copyfile(filepath, fs.joinpath(newpath, name))
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
		local newpath = fs.joinpath(new_dir, fs.basename(target))
		if isDir then
			M.copydir(target, newpath)
		else
			M.copyfile(target, newpath)
		end
	end
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
			reload()
			if isDir then
				moveCursorTo(fs.basename(newpath) .. sep)
			else
				moveCursorTo(fs.basename(newpath))
			end
		end
	end
end

M.vremove = function()
	if fn.mode() ~= 'v' or fn.mode() ~= 'V' then
		return
	end
	local lines = getVisualSelection()
	if #lines == 0 then
		return
	end
	local check = fn.confirm("Delete " .. #lines .. " files/directories", "&Yes\n&No", 2)
	if check ~= 1 then
		print("Cancelled")
		return
	end
	for _, line in ipairs(lines) do
		utils.rm(line)
	end
end

function M.nremove()
	if fn.mode ~= 'n' then
		return
	end
	local line = vim.trim(fn.getline('.'))
	local check = fn.confirm("Delete " .. line, "&Yes\n&No", 2)
	if check ~= 1 then
		print("Cancelled")
		return
	end
	utils.rm(line)
	reload()
end

function M.setup(opts)
	local default_opts = { del_all_keymap = false }
	M.config = vim.tbl_extend("force", default_opts, opts or {})
end

return M
