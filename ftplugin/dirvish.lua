local map = vim.keymap.set
local hasmapto = function(...)
	local check = vim.fn.hasmapto(...)
	return check and check ~= 0
end
local dirvido = require('dirvido')

map({ 'n' }, '<Plug>(dirvido_copy)', dirvido.copy, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dirvido_move)', dirvido.move, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dirvido_rename)', dirvido.rename, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dirvido_nremove)', dirvido.nremove, { buffer = true, silent = true })
map({ 'x' }, '<Plug>(dirvido_vremove)', dirvido.vremove, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dirvido_mkfile)', dirvido.mkfile, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dirvido_mkdir)', dirvido.mkdir, { buffer = true, silent = true })

if not dirvido.config.del_all_keymap then
	if not hasmapto('<Plug>(dirvido_copy)', 'n') then
		map({ 'n' }, 'p', '<Plug>(dirvido_copy)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_move)', 'n') then
		map({ 'n' }, 'mv', '<Plug>(dirvido_move)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_rename)', 'n') then
		map({ 'n' }, 'r', '<Plug>(dirvido_rename)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_nremove)', 'n') then
		map({ 'n' }, '<Del>', '<Plug>(dirvido_nremove)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_vremove)', 'x') then
		map({ 'x' }, '<Del>', '<Plug>(dirvido_vremove)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_mkfile)', 'n') then
		map({ 'n' }, 'a', '<Plug>(dirvido_mkfile)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dirvido_mkdir)', 'n') then
		map({ 'n' }, 'A', '<Plug>(dirvido_mkdir)', { buffer = true, silent = true })
	end
end
