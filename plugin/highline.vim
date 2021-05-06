if !exists('*prop_type_add')
  finish
endif
let g:loaded_highline = 1


highlight default link Highline Visual

call prop_type_add('highline', {'highlight': 'Highline', 'combine': v:true})

function! <SID>toggle()
  let line = line('.')
  if match(prop_list(line), 'highline') == -1
    call prop_add(line, 1, {'type': 'highline', 'end_col': col('$')+1})
  else
    call prop_remove({'type': 'highline'}, line)
  endif
endfunction

nnoremap <silent> <Plug>(HighlineToggle) :call <SID>toggle()<CR>
