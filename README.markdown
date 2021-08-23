# vim-highline

This tiny Vim plugin lets you toggle a highlight.  In normal mode and linewise visual mode the highlights are toggled linewise.  In characterwise visual mode the highlights are characterwise.

Highights will stay with their text if lines earlier in the buffer are inserted or deleted.

Requires Vim 8.1.0579+.


## Installation

Install using your favourite package manager, or use Vim's built-in package support:

```
mkdir -p ~/.vim/pack/airblade/start
cd ~/.vim/pack/airblade/start
git clone https://github.com/airblade/vim-highline.git
vim -u NONE -c "helptags vim-highline/doc" -c q
```


## Configuration

Map a key sequence, for example `<Leader>h`, to the toggle and clear functions:

```viml
nmap <Leader>h <Plug>(HighlineToggle)
xmap <Leader>h <Plug>(HighlineToggle)
nmap <Leader>h <Plug>(HighlineClear)
```

The highlight used is defined by the `Highline` group which by default links to `Visual`.  Feel free to link it to a different group or define your own colours, in your vimrc / init.vim.  For example:

```viml
highlight link Highline Pmenu
highlight Highline guibg=#444444
```


## Intellectual Property

Copyright 2021 Andrew Stewart. Released under the MIT licence.
