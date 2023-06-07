if exists('g:loaded_flutter')
  finish
else
  let g:loaded_flutter=1
endif

if !exists('g:flutter_command')
  let g:flutter_command='flutter'
endif

if !exists('g:flutter_split_height')
    let g:flutter_split_height=''
endif

if !exists('g:flutter_autoscroll')
  let g:flutter_autoscroll=0
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

if !exists('g:flutter_use_last_attach_option')
  let g:flutter_use_last_attach_option=0
endif

if !exists('g:flutter_show_log_on_run') || g:flutter_show_log_on_run == 1
  let g:flutter_show_log_on_run="split"
elseif type(g:flutter_show_log_on_run) == v:t_number && g:flutter_show_log_on_run == 0
  let g:flutter_show_log_on_run="hidden"
endif

if !exists('g:flutter_show_log_on_attach') || g:flutter_show_log_on_attach == 1
  let g:flutter_show_log_on_attach="split"
elseif type(g:flutter_show_log_on_attach) == v:t_number && g:flutter_show_log_on_attach == 0
  let g:flutter_show_log_on_attach="hidden"
endif

if !exists('g:flutter_close_on_quit')
    let g:flutter_close_on_quit=0
endif

command! FlutterDevices call flutter#devices()
command! FlutterEmulators call flutter#emulators()
command! -nargs=1 FlutterEmulatorsLaunch call flutter#emulators_launch(<f-args>)
command! FlutterHotReload call flutter#hot_reload()
command! -nargs=* -complete=file FlutterRun call flutter#run(<f-args>)
command! -nargs=* -complete=file FlutterAttach call flutter#attach(<f-args>)
command! FlutterHotRestart call flutter#hot_restart()
command! FlutterScreenshot call flutter#screenshot()
command! FlutterQuit call flutter#quit()
command! FlutterVisualDebug call flutter#visual_debug()

if g:flutter_hot_reload_on_save
  autocmd! BufWritePost *.dart call flutter#hot_reload_quiet()
endif

if g:flutter_hot_restart_on_save
  autocmd! BufWritePost *.dart call flutter#hot_restart_quiet()
endif

command! FlutterSplit :execute g:flutter_split_height."split" "__Flutter_Output__" | call flutter#scroll_to_bottom()
command! FlutterVSplit :vsplit __Flutter_Output__ | call flutter#scroll_to_bottom()
command! FlutterTab :tabnew __Flutter_Output__ | call flutter#scroll_to_bottom()

function! FlutterMenu() abort
  menu Flutter.Run :FlutterRun<CR>
  menu Flutter.Attach :FlutterAttach<CR>
  menu Flutter.Hot\ Reload :FlutterHotReload<CR>
  menu Flutter.Hot\ Restart :FlutterHotRestart<CR>
  menu Flutter.Screenshot :FlutterScreenshot<CR>
  menu Flutter.Open\ Output.In\ &Split :FlutterSplit<CR>
  menu Flutter.Open\ Output.In\ &VSplit :FlutterVSplit<CR>
  menu Flutter.Open\ Output.In\ &Tab :FlutterTab<CR>
  menu Flutter.Quit :FlutterQuit<CR>
  menu Flutter.View\ Devices :FlutterDevices<CR>
endfunction
