local map = vim.keymap.set
local hasmapto = vim.fn.hasmapto

map({ 'n' }, '<Plug>(dovish_copy)', require('dirvish-dovish').copy, { buffer = true, silent = true })
map({ 'n' }, '<Plug>(dovish_move)', require('dirvish-dovish').move)
map({ 'n' }, '<Plug>(dovish_rename)', require('dirvish-dovish').rename)
map({ 'n' }, '<Plug>(dovish_nremove)', require('dirvish-dovish').nremove)
map({ 'x' }, '<Plug>(dovish_vremove)', require('dirvish-dovish').vremove)
map({ 'n' }, '<Plug>(dovish_mkfile)', require('dirvish-dovish').mkfile)
map({ 'n' }, '<Plug>(dovish_mkdir)', require('dirvish-dovish').mkdir)

if not require('dirvish-dovish').config.del_all_keymap then
	if not hasmapto('<Plug>(dovish_copy)', 'n') then
		map({ 'n' }, 'p', '<Plug>(dovish_copy)', { buffer = true, silent = true })
	end
	if not hasmapto('<Plug>(dovish_move)', 'n') then
		map({ 'n' }, 'mv', '<Plug>(dovish_move)')
	end
	if not hasmapto('<Plug>(dovish_rename)', 'n') then
		map({ 'n' }, 'r', '<Plug>(dovish_rename)')
	end
	if not hasmapto('<Plug>(dovish_nremove)', 'n') then
		map({ 'n' }, '<Del>', '<Plug>(dovish_nremove)')
	end
	if not hasmapto('<Plug>(dovish_vremove)', 'x') then
		map({ 'x' }, '<Del>', '<Plug>(dovish_vremove)')
	end
	if not hasmapto('<Plug>(dovish_mkfile)', 'n') then
		map({ 'n' }, 'a', '<Plug>(dovish_mkfile)')
	end
	if not hasmapto('<Plug>(dovish_mkdir)', 'n') then
		map({ 'n' }, 'A', '<Plug>(dovish_mkdir)')
	end
end
