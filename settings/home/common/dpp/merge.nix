{
  plugins = [
    {
      repo = "bluz71/vim-nightfly-colors";
      hook_add = ''
        if !exists('g:nvui')
          let g:nightflyTransparent = 1
        endif
        colorscheme nightfly
      '';
    }
    {
      repo = "ryanoasis/vim-devicons";
      hook_add = ''
        let g:WebDevIconsNerdTreeBeforeGlyphPadding=""
        let g:WebDevIconsUnicodeDecorateFolderNodes=v:true
        if exists('g:loaded_webdevicons')
          webdevicons#refresh()
        endif
      '';
    }
    {
      repo = "itchyny/vim-parenmatch";
    }
    {
      repo = "lambdalisue/vim-nerdfont";
    }
    {
      repo = "vim-jp/vimdoc-ja";
      hook_add = ''
        set helplang=ja,en
      '';
    }
    {
      repo = "kana/vim-textobj-user";
    }
    {
      repo = "lambdalisue/vim-fern";
      hooks_file = "$BASE_DIR/dpp/fern.vim";
    }
    {
      repo = "lambdalisue/vim-fern-renderer-nerdfont";
    }
    {
      repo = "lambdalisue/vim-fern-git-status";
    }
    {
      repo = "lambdalisue/vim-mr";
    }
    {
      repo = "vimpostor/vim-tpipeline";
      hook_add = ''
        let g:tpipeline_autoembed = 0
        au FocusGained * ++once call tpipeline#initialize()
      '';
    }
    {
      repo = "embear/vim-localvimrc";
      hook_add = ''
        let g:localvimrc_persistent = 1
      '';
    }
    {
      repo = "rhysd/committia.vim";
    }
    {
      repo = "tpope/vim-dadbod";
    }
    {
      repo = "tani/vim-artemis";
      "if" = false;
    }
    {
      repo = "Shougo/cmdline.vim";
    }
    {
      repo = "hrsh7th/vim-searchx";
      hooks_file = "$BASE_DIR/dpp/searchx.vim";
    }
    {
      repo = "lambdalisue/vim-manpager";
    }
    {
      repo = "tani/dmacro.vim";
      hook_add = ''
        nnoremap <C-y> <Plug>(dmacro-play-macro)
        inoremap <C-y> <Plug>(dmacro-play-macro)
      '';
    }
  ];
}
