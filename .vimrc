" Coc is crying
let g:coc_node_path = substitute(system('which node'), '\n', '', '')

"---- For Neovim ----
"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath=&runtimepath
"source ~/.vimrc
"---- For Neovim ----

"---- Vim settings ----
syntax on
set scrolloff=8
set ignorecase " Case insensitive seartch
set smartcase " ^ except for if i use a capital letter
set tabstop=4 softtabstop=4
set shiftwidth=4 " tab space for when shifting across
set smartindent " try to auto indent when it can
set noswapfile
set undodir=~/.vim/undodir " Save the undos
set undofile
set incsearch
set encoding=utf-8
set number " line numbers
let NERDTreeShowHidden=1
let $FZF_DEFAULT_COMMAND="find -L"
"---- Vim settings ----

"---- Key Bindings ----
noremap <silent> <C-e> :call ToggleNetrw()<CR>
"---- Key Bindings ----

"---- Netrw functions ----
let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
"---- Netrw functions ----

