# vim-flutter
Vim commands for Flutter, including hot-reload-on-save and more.

![Demo usage GIF](demo.gif)

## Usage
Usage documentation can be found both in this README, as well
as via calling `:h flutter`.

## Installation
`vim-flutter` is a Vimscript-only plugin, and makes heavy
use of Vim8's async jobs. It can be installed with a
package manager like
[`vim-plug`](https://github.com/junegunn/vim-plug)
, for example.

Though this package doesn't depend on it, having
[`dart-vim-plugin`](https://github.com/dart-lang/dart-vim-plugin)
available is recommended, for a better experience.

You may also consider combining
[`package:dart_language_server`](https://github.com/natebosch/dart_language_server)
with a Language Server Protocol client, like
[`ale`](https://github.com/w0rp/ale).

```vim
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" Run :PlugInstall to install the plugin.
```

Ultimately, installation is up to you.

## Options
* `g:flutter_command` - The Flutter executable path/name; defaults to `'flutter'`.
* `g:flutter_hot_reload_on_save` - Whether to auto hot-reload when `dart` files
are saved; defaults to `1`.
* `g:flutter_hot_restart_on_save` - Whether to auto hot-restart when `dart` files
are saved; defaults to `0`.
* `g:flutter_show_log_on_run` - Automatically open `__Flutter_Output__` when starting
flutter; defaults to `1`. Setting this to 0 requires `set hidden` in your vimrc.
* `g:flutter_show_log_on_attach` - Automatically open `__Flutter_Output__` when starting
flutter; defaults to `1`. Setting this to 0 requires `set hidden` in your vimrc.

## Provided Commands
* `:FlutterRun <args>` - calls `flutter run <args>`
* `:FlutterAttach <args>` - calls `flutter attach <args>`
* `:FlutterHotReload` - triggers a hot reload on the current Flutter process
* `:FlutterHotRestart` - triggers a hot restart on the current Flutter process
* `:FlutterQuit` - quits the current Flutter process
* `:FlutterDevices` - opens a new buffer, and writes the output of `flutter devices` to it
* `:FlutterSplit` - opens Flutter output in a horizontal split
* `:FlutterEmulators` - Executes a `flutter emulators` process.
* `:FlutterEmulatorsLaunch` - Executes a `flutter emulators --launch` process, with any provided
arguments.
* `:FlutterVisualDebug` - Toggles visual debugging in the running Flutter process.

The following are self-explanatory:
* `:FlutterVSplit`
* `:FlutterTab`

## Menu Support
If you are using a GUI Vim Variant, you can add a `Flutter` menu by calling `call FlutterMenu()`.

## Hot Reload on Save
A convenient feature to have when working with Flutter is
to automatically hot-reload an app once a file is saved.
By default, whenever a `dart` file is saved, *if and only if*
a Flutter process is running, it will be hot-reloaded.

You can disable this by setting `g:hot_reload_on_save=0`,
*before* `vim-flutter` is loaded.

## Example `.vimrc`
```vim
Plug 'thosakwe/vim-flutter'
call plug#end()

" Enable Flutter menu
call FlutterMenu()

" Some of these key choices were arbitrary;
" it's just an example.
nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fA :FlutterAttach<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>
```
