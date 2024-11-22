local M = {}

local fn = vim.fn

local function send_rename(method, old_path, new_path)
	local old_uri = vim.uri_from_fname(old_path)
	local new_uri = vim.uri_from_fname(new_path)

	local params = {
		files = {
			{
				oldUri = old_uri,
				newUri = new_uri,
			},
		},
	}

	local clients = vim.lsp.get_active_clients()
	if #clients == 0 then
		vim.notify("No active LSP clients to handle WillRename.", vim.log.levels.ERROR)
		return
	end

	for _, client in ipairs(clients) do
		if not client.supports_method(method) then
			return
		end

		client.request(method, params, function(err, result)
			if err then
				vim.notify(method .. " failed: " .. err.message, vim.log.levels.ERROR)
				return
			end

			if result and result.changes then
				local confirm = fn.confirm("Do you want to update paths?", '&Yes\n&No')
				if confirm ~= 1 then
					print('Cancelled')
					return
				end
				vim.lsp.util.apply_workspace_edit(result)
			end
		end)
	end
end

function M.willRenameFiles(old_path, new_path)
	send_rename("workspace/willRenameFiles", old_path, new_path)
end

function M.didRenameFile(old_path, new_path)
	send_rename("workspace/didRenameFiles", old_path, new_path)
end

return M
