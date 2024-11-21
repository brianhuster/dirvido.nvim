local M = {}

local fn = vim.fn

M.sep = fn.exists('+shellslash') and not vim.o.shellslash and '\\' or '/'

function M.rm(path)
	local isDir = path:sub(-1) == "/"
	if isDir then
		fn.delete(path, "rf")
	else
		fn.delete(path)
	end
end

return M
