function! s:flutter_run_handler(job_id, data, event_type)
  echo a:job_id
  echo a:event_type
  echo join(a:data, '\n')
endfunction

function! flutter#devices() abort
  new
  setlocal buftype=nofile
  execute "read ! flutter devices"
  setlocal nomodifiable
endfunction

function! flutter#send(msg) abort
  if !exists('g:flutter_job')
    echoerr 'Flutter is not running.'
  else
    let chan = job_getchannel(g:flutter_job)
    call ch_sendraw(chan, a:msg)
  endif
endfunction

function! flutter#hot_reload() abort
  return flutter#send('r')
endfunction

function! flutter#hot_reload_quiet() abort
  if exists('g:flutter_job')
    return flutter#send('r')
  endif
endfunction

function! flutter#hot_restart() abort
  return flutter#send('R')
endfunction

function! flutter#quit() abort
  return flutter#send('q')
endfunction

function! flutter#_exit_cb(job, status) abort
  if exists('g:flutter_job')
    unlet g:flutter_job
  endif
  call job_stop(a:job)
endfunction

function! flutter#_on_exit_nvim(job_id, data, event) abort dict
  if exists('g:flutter_job')
    unlet g:flutter_job
  endif
  call jobstop(a:job_id)
endfunction

function! flutter#_on_output_nvim(job_id, data, event) abort dict
  if !empty(a:data)
    let lines = filter(a:data, '!empty(v:val)')
    call nvim_buf_set_lines(bufnr('__Flutter_Output__'), -1, -1, v:true, lines)
  endif
endfunction

function! flutter#run(...) abort
 if exists('g:flutter_job')
   echoerr 'Another Flutter process is running.'
   return 0
 endif
 split __Flutter_Output__
 normal! ggdG
 setlocal buftype=nofile
 setlocal bufhidden=hide
 setlocal showcmd
 setlocal noruler
 setlocal noswapfile
 setlocal hidden
 setlocal noshowmode
 setlocal laststatus=0

  let cmd = g:flutter_command.' run'
  if !empty(a:000)
    let cmd .= ' '.join(a:000)
  endif

  if has('nvim')
    let g:flutter_job = jobstart(cmd, {
      \ 'on_stdout' : function('flutter#_on_output_nvim'),
      \ 'on_stderr' : function('flutter#_on_output_nvim'),
      \ 'on_exit' : function('flutter#_on_exit_nvim'),
      \ })
  elseif v:version >= 800
    let g:flutter_job = job_start(cmd, {
      \ 'out_io': 'buffer',
      \ 'out_name': '__Flutter_Output__',
      \ 'err_io': 'buffer',
      \ 'err_name': '__Flutter_Output__',
      \ 'exit_cb': 'flutter#_exit_cb',
      \ })
  else
    echoerr 'This vim does not support async jobs needed for running Flutter.'
  endif

endfunction
