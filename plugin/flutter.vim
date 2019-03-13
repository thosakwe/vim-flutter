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

command FlutterDevices call flutter#devices()
command -nargs=* FlutterRun call flutter#run(<f-args>)
command FlutterHotReload call flutter#hot_reload()
command FlutterHotRestart call flutter#hot_restart()
command FlutterQuit call flutter#quit()

if g:flutter_hot_reload_on_save
  autocmd FileType dart autocmd BufWritePre <buffer> call flutter#hot_reload_quiet()
endif

command FlutterSplit :split __Flutter_Output__
command FlutterVSplit :vsplit __Flutter_Output__
command FlutterTab :tabnew __Flutter_Output__
