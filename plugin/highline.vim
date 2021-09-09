if !exists('*prop_type_add')
  finish
endif
let g:loaded_highline = 1


highlight default link Highline Visual

call prop_type_add('highline', {'highlight': 'Highline', 'combine': v:true})

" Toggles a highline highlight.
function! <SID>toggle()
  let mode = mode(1)
  if mode == 'n'
    let [line_start, column_start] = [line('.'), 1]
    let [line_end,   column_end]   = [line('.'), col('$')]
  elseif mode == 'v'
    let [line_cursor,   column_cursor]   = [line('.'), col('.')]
    let [line_opposite, column_opposite] = [line('v'), col('v')]

    if line_cursor < line_opposite
      let [line_start, column_start] = [line_cursor, column_cursor]
      let [line_end,   column_end]   = [line_opposite, column_opposite]
    elseif line_cursor == line_opposite
      let [line_start, line_end] = [line_cursor, line_cursor]
      if column_cursor < column_opposite
        let [column_start, column_end] = [column_cursor, column_opposite]
      else
        let [column_start, column_end] = [column_opposite, column_cursor]
      endif
    elseif line_cursor > line_opposite
      let [line_start, column_start] = [line_opposite, column_opposite]
      let [line_end,   column_end]   = [line_cursor, column_cursor]
    endif

    normal! v
  elseif mode == 'V'
    let [line_cursor,   column_cursor]   = [line('.'), col('.')]
    let [line_opposite, column_opposite] = [line('v'), col('v')]

    if line_cursor < line_opposite
      let [line_start, column_start] = [line_cursor, 1]
      let [line_end,   column_end]   = [line_opposite, strlen(getline(line_opposite))]
    elseif line_cursor == line_opposite
      let [line_start, column_start] = [line_cursor, 1]
      let [line_end,   column_end]   = [line_opposite, col('$')]
    elseif line_cursor > line_opposite
      let [line_start, column_start] = [line_opposite, 1]
      let [line_end,   column_end]   = [line_cursor, col('$')]
    endif

    normal! V
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
  call prop_remove({'type': 'highline'})
endfunction

nnoremap <silent> <Plug>(HighlineToggle) <Cmd>call <SID>toggle()<CR>
xnoremap <silent> <Plug>(HighlineToggle) <Cmd>call <SID>toggle()<CR>

nnoremap <silent> <Plug>(HighlineClear) <Cmd>call <SID>clear()<CR>
