if (has('nvim') && !exists('*nvim_buf_set_extmark')) || (!has('nvim') && !exists('*prop_type_add'))
  finish
endif
let g:loaded_highline = 1


highlight default link Highline Visual

if has('nvim')
  let s:namespace = nvim_create_namespace('highline')
else
  call prop_type_add('highline', {'highlight': 'Highline', 'combine': v:true})
endif


function! s:region(mode)
  if a:mode == 'n'
    let [line_start, column_start] = [line('.'), 1]
    let [line_end,   column_end]   = [line('.'), col('$')]
  else
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end,   column_end]   = getpos("'>")[1:2]
    " linewise visual mode: column of '> is very large
    let column_end = min([column_end, col([line_end, '$'])])
    if has('nvim')
      if column_end < col([line_end, '$'])
        let column_end += 1
      endif
    endif
  endif
  return [line_start, column_start, line_end, column_end]
endfunction


function! s:remove(line_start, line_end)
  if has('nvim')
    let hit = v:false
    " It is not possible to remove part of a multi-line extended mark.
    " E.g. you cannot mark three lines with a single extmark and then remove
    " the middle line from the extmark.  It's all or nothing.
    "
    " nvim_buf_get_extmarks does not detect extmarks which start before the
    " {start} argument, even if they extend into the {start}-{end} region.
    " Therefore iterate over all extmarks in buffer looking for the right
    " one(s).
    for extmark in nvim_buf_get_extmarks(0, s:namespace, 0, -1, {'details': v:true})
      let [mark_line_start, mark_line_end] = [extmark[1] + 1, extmark[3].end_row + 1]
      if (mark_line_start <= a:line_start && mark_line_end >= a:line_start) ||
            \ (mark_line_start <= a:line_end && mark_line_end >= a:line_end)
        call nvim_buf_del_extmark(0, s:namespace, extmark[0])
        let hit = v:true
      endif
    endfor
    return hit
  else
    if prop_remove({'type': 'highline'}, a:line_start, a:line_end)
      return v:true
    endif
    return v:false
  endif
endfunction


function! s:add(line_start, column_start, line_end, column_end)
  if has('nvim')
    " hl_mode does not affect hl_group but hopefully it will in future.
    call nvim_buf_set_extmark(0, s:namespace, a:line_start-1, a:column_start-1,
          \ {'end_line': a:line_end-1, 'end_col': a:column_end-1, 'hl_group': 'Highline', 'hl_mode': 'combine'})
  else
    call prop_add(a:line_start, a:column_start, {'type': 'highline', 'end_lnum': a:line_end, 'end_col': (a:column_end+1)})
  endif
endfunction


" Toggles a highline highlight.
function! <SID>toggle(mode)
  let [line_start, column_start, line_end, column_end] = s:region(a:mode)

  if s:remove(line_start, line_end)
    return
  endif

  call s:add(line_start, column_start, line_end, column_end)
endfunction


" Removes all highline highlights from the current buffer.
function! <SID>clear()
  if has('nvim')
    call nvim_buf_clear_namespace(0, s:namespace, 0, -1)
  else
    call prop_remove({'type': 'highline'})
  endif
endfunction


nnoremap <silent> <Plug>(HighlineToggle) :call <SID>toggle('n')<CR>
xnoremap <silent> <Plug>(HighlineToggle) :<C-U>call <SID>toggle('x')<CR>

nnoremap <silent> <Plug>(HighlineClear) :call <SID>clear()<CR>
