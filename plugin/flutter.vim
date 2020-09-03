if exists('g:loaded_flutter')
  finish
else
  let g:loaded_flutter=1
endif

if !exists('g:flutter_command')
  let g:flutter_command='flutter'
endif

if !exists('g:flutter_hot_reload_on_save')
  let g:flutter_hot_reload_on_save=1
endif

if !exists('g:flutter_hot_restart_on_save')
  let g:flutter_hot_restart_on_save=0
endif

if !exists('g:flutter_use_last_run_option')
  let g:flutter_use_last_run_option=0
endif

if !exists('g:flutter_show_log_on_run')
  let g:flutter_show_log_on_run=1
elseif &hidden == 0 && g:flutter_show_log_on_run == 0
  echoerr "WARNING: Hidden buffers are disabled. Setting g:flutter_show_log_on_run to 1. Please add `set hidden` to your vimrc to keep the flutter log in the background."
  let g:flutter_show_log_on_run = 1
endif

command! FlutterDevices call flutter#devices()
command! FlutterEmulators call flutter#emulators()
command! -nargs=1 FlutterEmulatorsLaunch call flutter#emulators_launch(<f-args>)
command! FlutterHotReload call flutter#hot_reload()
command! -nargs=* -complete=file FlutterRun call flutter#run(<f-args>)
command! FlutterHotRestart call flutter#hot_restart()
command! FlutterQuit call flutter#quit()
command! FlutterVisualDebug call flutter#visual_debug()

if g:flutter_hot_reload_on_save
  autocmd! BufWritePost *.dart call flutter#hot_reload_quiet()
endif

if g:flutter_hot_restart_on_save
  autocmd! BufWritePost *.dart call flutter#hot_restart_quiet()
endif

command! FlutterSplit :split __Flutter_Output__
command! FlutterVSplit :vsplit __Flutter_Output__
command! FlutterTab :tabnew __Flutter_Output__

function! FlutterMenu() abort
  menu Flutter.Run :FlutterRun<CR>
  menu Flutter.Hot\ Reload :FlutterHotReload<CR>
  menu Flutter.Hot\ Restart :FlutterHotRestart<CR>
  menu Flutter.Open\ Output.In\ &Split :FlutterSplit<CR>
  menu Flutter.Open\ Output.In\ &VSplit :FlutterVSplit<CR>
  menu Flutter.Open\ Output.In\ &Tab :FlutterTab<CR>
  menu Flutter.Quit :FlutterQuit<CR>
  menu Flutter.View\ Devices :FlutterDevices<CR>
endfunction
