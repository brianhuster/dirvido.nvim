local M = {}

local fs = vim.fs
local fn = vim.fn

M.sep = fn.exists('+shellslash') and not vim.o.shellslash and '\\' or '/'

function M.rm(path)
	local isDir = path:sub(-1) == "/"
	if isDir then
		fs.rm(path, { recursive = true })
	else
		fs.rm(path)
	end
end

return M
