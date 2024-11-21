# 🧰 vim-dirvish-dovish

> The file manipulation commands for [vim-dirvish][dirvish] that you've always wanted

## Installation & Requirements

You'll need:

- [dirvish.vim](https://github.com/justinmk/vim-dirvish)

Then install with your favorite package manager:

```vim
Plug 'brianhuster/dirvish-dovish.nvim'
```

## Mappings

| Function                                | Default | Key                               |
| --------------------------------------- | ------- | --------------------------------- |
| Create file                             | `a`     | `<Plug>(dovish_create_file)`      |
| Create directory                        | `A`     | `<Plug>(dovish_create_directory)` |
| Delete under cursor                     | `<Del>` | `<Plug>(dovish_ndelete)`          |
| Rename under cursor                     | `r`     | `<Plug>(dovish_rename)`           |
| Yank under cursor (or visual selection) | `yy`    | `<Plug>(dovish_yank)`             |
| Copy file to current directory          | `p`     | `<Plug>(dovish_copy)`             |
| Move file to current directory          | `mv`    | `<Plug>(dovish_move)`             |

You can unmap all of the maps above and set your own (mine are below). Add this to `ftplugin/dirvish.vim`:



## Credit

This is a fork of [vim-dirvish-dovish](https://github.com/roginfarrer/vim-dirvish-dovish) that has been refactored for better cross-platform support out of the box.

Big shout out to [Melandel](https://github.com/Melandel) for laying the [foundation](https://github.com/Melandel/desktop/blob/c323969e4bd48dda6dbceada3a7afe8bacdda0f5/setup/my_vimrc.vim#L976-L1147) for this plugin!
