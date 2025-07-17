" ddt.vim configuration for Claude Code integration
" Initialize ddt.vim with proper configuration

" Load ddt.vim configuration
call ddt#custom#load_config(g:dpp_base_dir .. '/ddt.ts')

" Key mappings for terminal operations
nnoremap <silent> <Leader>to <Cmd>call ddt#start({'name': 'claudecode'})<CR>
nnoremap <silent> <Leader>tt <Cmd>call ddt#ui#do_action('toggle')<CR>
nnoremap <silent> <Leader>tc <Cmd>call ddt#ui#do_action('quit')<CR>
nnoremap <silent> <Leader>tf <Cmd>call ddt#ui#do_action('focus')<CR>

" Commands for Claude Code integration
command! -nargs=? ClaudeTerminalOpen call ddt#start({'name': 'claudecode', 'command': <q-args>})
command! ClaudeTerminalClose call ddt#ui#do_action('quit')
command! ClaudeTerminalToggle call ddt#ui#do_action('toggle')
command! ClaudeTerminalFocus call ddt#ui#do_action('focus')
command! -nargs=1 ClaudeTerminalSend call ddt#ui#do_action('sendText', {'text': <q-args>})
command! -nargs=1 ClaudeTerminalCommand call ddt#ui#do_action('sendCommand', {'command': <q-args>})

" Auto-start ddt.vim when needed
augroup ddt_claudecode
  autocmd!
  autocmd User ClaudeCodeTerminalRequest call ddt#start({'name': 'claudecode'})
augroup END