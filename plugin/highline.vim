if !exists('*prop_type_add')
  finish
endif
let g:loaded_highline = 1


highlight default link Highline Visual

call prop_type_add('highline', {'highlight': 'Highline', 'combine': v:true})

" Toggles a highline highlight.
function! <SID>toggle(mode)
  if a:mode == 'n'
    let [line_start, column_start] = [line('.'), 1]
    let [line_end,   column_end]   = [line('.'), col('$')]
  else
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end,   column_end]   = getpos("'>")[1:2]
    let column_end = min([column_end, col([line_end, '$'])])
  endif

  " Remove highline highlight if detected and return.
  for line in range(line_start, line_end)
    if match(prop_list(line), 'highline') != -1
      call prop_remove({'type': 'highline'}, line, line_end)
      return
    endif
  endfor

  " Add highline highlight.
  call prop_add(line_start, column_start, {'type': 'highline', 'end_lnum': line_end, 'end_col': (column_end+1)})
endfunction

" Removes highline highlights from the current buffer.
function! <SID>clear()
  let p = prop_find({'type': 'highline', 'lnum': 1})
  while !empty(p)
    call prop_remove({'type': 'highline'}, p.lnum)
    let p = prop_find({'type': 'highline', 'lnum': p.lnum})
  endwhile
endfunction

nnoremap <silent> <Plug>(HighlineToggle) :call <SID>toggle('n')<CR>
xnoremap <silent> <Plug>(HighlineToggle) :<C-U>call <SID>toggle('x')<CR>

nnoremap <silent> <Plug>(HighlineClear) :call <SID>clear()<CR>
