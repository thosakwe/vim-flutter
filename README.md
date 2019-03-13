# vim-flutter
Vim commands for Flutter, including hot-reload-on-save and more.

## Installation
`vim-flutter` is a Vimscript-only plugin, and makes heavy
use of Vim8's async jobs. It can be installed with a
package manager like `vim-plug`, for example.

```vim
Plug 'thosakwe/vim-flutter'

" Run :PlugInstall to install the plugin.
```

Ultimately, installation is up to you.

## Options
* `g:flutter_command` - The Flutter executable path/name; defaults to `'flutter'`.
* `g:flutter_hot_reload_on_save` - Whether to auto hot-reload when `dart` files
are saved; defaults to `1`.

## Provided Commands
* `:FlutterRun <args>` - calls `flutter run <args>`
* `:FlutterHotReload` - triggers a hot reload on the current Flutter process
* `:FlutterHotRestart` - triggers a hot restart on the current Flutter process
* `:FlutterQuit` - quits the current Flutter process
* `:FlutterDevices` - opens a new buffer, and writes the output of `flutter devices` to it
* `:FlutterSplit` - opens Flutter output in a horizontal split

The following are self-explanatory:
* `:FlutterVSplit`
* `:FlutterTab`

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

" Some of these key choices were arbitrary;
" it's just an example.
nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
```