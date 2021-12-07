nnoremap <leader>hrr <cmd>execute 'source' g:nvim_init_file<cr>
nnoremap <leader>hpi <cmd>PackerInstall<cr>
nnoremap <leader>hpu <cmd>PackerUpdate<cr>

nnoremap <leader>oO <cmd>execute 'CHADopen' expand('%:p')<cr>
nnoremap <leader>oo <cmd>CHADopen<cr>

nnoremap <leader>tn <cmd>tabnew<cr>
nnoremap <leader>tc <cmd>tabclose<cr>

nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <C-space> <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

tnoremap <Esc> <C-\><C-n>
