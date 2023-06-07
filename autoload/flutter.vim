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

function! flutter#emulators() abort
  new
  setlocal buftype=nofile
  execute "read !" . g:flutter_command ."  emulators"
  setlocal nomodifiable
endfunction

function! flutter#emulators_launch(emulator) abort
  let cmd = g:flutter_command . " emulators --launch ". a:emulator
  execute "!". cmd
endfunction

function! flutter#send(msg) abort
  if !exists('g:flutter_job')
    echoerr 'Flutter is not running.'
  else
    if has('nvim')
      call chansend(g:flutter_job, a:msg)
    else
      let chan = job_getchannel(g:flutter_job)
      call ch_sendraw(chan, a:msg)
    endif
  endif
endfunction

function! flutter#visual_debug() abort
  return flutter#send('p')
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

function! flutter#hot_restart_quiet() abort
  if exists('g:flutter_job')
    return flutter#send('R')
  endif
endfunction

function! flutter#quit() abort
  let l:ret = flutter#send('q')
  if g:flutter_close_on_quit
    let l:bufinfo = getbufinfo('__Flutter_Output__')
    if len(l:bufinfo) > 0
      for l:win_id in l:bufinfo[0].windows
        call win_execute(l:win_id, 'close')
      endfor
    endif
  endif
  return l:ret
endfunction

function! flutter#screenshot() abort
  return flutter#send('s')
endfunction

function! flutter#_exit_cb(job, status) abort
  if exists('g:flutter_job')
    unlet g:flutter_job
  endif
  call job_stop(a:job)
endfunction

if has('nvim')
function! flutter#_on_exit_nvim(job_id, data, event) abort dict
  if exists('g:flutter_job')
    unlet g:flutter_job
  endif
endfunction

let g:flutter_partial_line_nvim = ''
function! flutter#_on_output_nvim(job_id, data, event) abort dict
  let str = join(a:data, '')
  if str =~ '\.\.\.'
    let g:flutter_partial_line_nvim = str
  else
    if and(g:flutter_partial_line_nvim != '', str !~ 'Reloaded')
    let str = g:flutter_partial_line_nvim . str
      let b = bufnr('__Flutter_Output__')
      call nvim_buf_set_lines(b, -2, -1, v:true, [str])
      let g:flutter_partial_line_nvim = ''
    return
    endif
  endif
  let b = bufnr('__Flutter_Output__')
  call nvim_buf_set_lines(b, -1, -1, v:true, a:data)

  call flutter#scroll_to_bottom()
endfunction
endif

function! flutter#scroll_to_bottom()
  if has('nvim') && g:flutter_autoscroll
    let l:bufinfo = getbufinfo('__Flutter_Output__')[0]
    let l:lnum = l:bufinfo['linecount']
    let l:windows = l:bufinfo['windows']
    if len(l:windows) > 0
      call nvim_win_set_cursor(l:windows[0], [l:lnum, 0])
    end
  endif
endfunction

let s:last_options = {}

function! flutter#run_or_attach(type, show, use_last_option, args) abort
  if exists('g:flutter_job')
    echoerr 'Another Flutter process is running.'
    return 0
  endif

  let l:bufinfo = getbufinfo('__Flutter_Output__')
  if len(l:bufinfo) == 0 || len(l:bufinfo[0].windows) == 0
    if a:show == 'tab' || a:show == 'hidden'
      " open new tab and move it before the current tab
      tabnew __Flutter_Output__
      tabm -1
    else
      execute g:flutter_split_height."split" "__Flutter_Output__"
    endif
    normal! ggdG
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    if a:show == 'hidden'
      tabclose
    endif
  endif

  let cmd = []
  if has("win32") || has("win64")
    let cmd += [&shell, &shellcmdflag]
  endif
  let cmd += split(g:flutter_command) + [a:type]
  if !empty(a:args)
    let cmd += a:args
    if a:use_last_option
      let s:last_options[a:type] = a:args
    endif
  else
    if a:use_last_option
      let last_option = get(s:last_options, a:type, [])
      let cmd += last_option
    endif
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

    if job_status(g:flutter_job) == 'fail'
      echo 'Could not start flutter job'
      unlet g:flutter_job
    endif
  else
    echoerr 'This vim does not support async jobs needed for running Flutter.'
  endif
endfunction

function! flutter#run(...) abort
  call flutter#run_or_attach('run', g:flutter_show_log_on_run, g:flutter_use_last_run_option, a:000)
endfunction

function! flutter#attach(...) abort
  call flutter#run_or_attach('attach', g:flutter_show_log_on_attach, g:flutter_use_last_attach_option, a:000)
endfunction
