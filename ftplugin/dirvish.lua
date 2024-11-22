if vim.fn.has('nvim-0.8') == 0 then
	vim.notify('dirvish-dovish.nvim only supports Nvim 0.8 and later', vim.log.levels.ERROR)
	return
end

local map = vim.keymap.set
local hasmapto = function(...)
	local check = vim.fn.hasmapto(...)
	return check and check ~= 0
end
local dirvido = require('dirvish-dovish')

map({ 'n' }, '<Plug>(dovish_copy)', dirvido.copy, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_move)', dirvido.move, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_rename)', dirvido.rename, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_nremove)', dirvido.nremove, { buffer = true, silent = true })
map({ 'x' }, '<Plug>(dovish_vremove)', dirvido.vremove, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_mkfile)', dirvido.mkfile, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_mkdir)', dirvido.mkdir, { buffer = true, silent = true })

if not dirvido.config.disable_all_keymaps then
	if not hasmapto('<Plug>(dovish_copy)', 'n') then
		map({ 'n' }, 'cp', '<Plug>(dovish_copy)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_move)', 'n') then
		map({ 'n' }, 'mv', '<Plug>(dovish_move)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_rename)', 'n') then
		map({ 'n' }, 'r', '<Plug>(dovish_rename)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_nremove)', 'n') then
		map({ 'n' }, '<Del>', '<Plug>(dovish_nremove)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_vremove)', 'x') then
		map({ 'x' }, '<Del>', '<Plug>(dovish_vremove)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_mkfile)', 'n') then
		map({ 'n' }, 'mf', '<Plug>(dovish_mkfile)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_mkdir)', 'n') then
		map({ 'n' }, 'md', '<Plug>(dovish_mkdir)', { buffer = true, silent = true })
	end
end
