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

function! flutter#run(...) abort
 if exists('g:flutter_job')
   echoerr 'Another Flutter process is running.'
   return 0
 endif
 split __Flutter_Output__
 normal! ggdG
 setlocal buftype=nofile
 setlocal bufhidden=hide
 setlocal noswapfile
 setlocal hidden

  let cmd = g:flutter_command.' run'
  if !empty(a:000)
    let cmd .= ' '.join(a:000)
  endif

  let g:flutter_job = job_start(cmd, {
    \ 'out_io': 'buffer',
    \ 'out_name': '__Flutter_Output__',
    \ 'err_io': 'buffer',
    \ 'err_name': '__Flutter_Output__',
    \ 'exit_cb': 'flutter#_exit_cb',
    \ })
endfunction
