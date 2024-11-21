local M = {}

local fs = vim.fs
local fn = vim.fn

M.sep = fn.exists('+shellslash') and not vim.o.shellslash and '\\' or '/'

function M.rm(path)
	local isDir = path:sub(-1) == "/"
	if isDir then
		if fs.rm then
			fs.rm(path, { recursive = true })
		else
			fn.delete(path, 'rf')
		end
	else
		if fs.rm then
			fs.rm(path)
		else
			fn.delete(path)
		end
	end
end

return M
