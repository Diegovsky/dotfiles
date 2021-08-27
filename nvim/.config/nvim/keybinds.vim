nnoremap <leader>hrr <cmd>execute 'source' g:nvim_init_file<cr><cr>
nnoremap <leader>hpi <cmd>PlugInstall<cr>
nnoremap <leader>hpu <cmd>PlugUpdate<cr>

nnoremap <leader>oo <cmd>execute 'CHADopen' expand('%:p')<cr>
nnoremap <leader>oO <cmd>CHADopen<cr>
        
nnoremap - <cmd>resize -1<cr>
nnoremap = <cmd>resize +1<cr>
nnoremap 0 ^^

nnoremap <leader>pe <cmd>AsyncTaskEdit<cr>
nnoremap <leader>pr <cmd>AsyncTask run<cr>
nnoremap <leader>pb <cmd>AsyncTask build<cr>

nnoremap <leader>tn <cmd>tabnew<cr>
nnoremap <leader>tc <cmd>tabclose<cr>

nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

tnoremap <Esc> <C-\><C-n>

nnoremap <leader>cdc <cmd>cd ~/.config/nvim/<cr>
nnoremap <leader>cdb <cmd>cd -<cr>

nnoremap <leader>bd <cmd>bd<cr>
nnoremap <leader>bn <cmd>bn<cr>
nnoremap <leader>bp <cmd>bprevious<cr>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-k>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-j>     compe#scroll({ 'delta': -4 })