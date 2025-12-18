{
  plugins = [
    {
      repo = "Shougo/deol.nvim";
      on_cmd = [ "Deol" ];
      hook_add = ''
        nnoremap <silent> <C-o> <Cmd>Deol -split=otherwise -toggle -winheight=10<CR>
        tnoremap <Esc> <C-\><C-n>
      '';
    }
    {
      repo = "whatyouhide/vim-textobj-xmlattr";
      on_ft = [
        "typescriptreact"
        "javascriptreact"
        "html"
        "xml"
      ];
    }
    {
      repo = "AndrewRadev/switch.vim";
      on_map = [ "<Plug>(Switch)" ];
      hook_add = ''
        let g:switch_mapping = ""
        nmap gsf <Plug>(Switch)
      '';
    }
    {
      repo = "tweekmonster/helpful.vim";
      on_cmd = [ "HelpfulVersion" ];
    }
    {
      repo = "thinca/vim-quickrun";
      on_cmd = [ "QuickRun" ];
      hooks_file = ./hooks/quickrun.vim;
    }
    {
      repo = "lambdalisue/vim-glyph-palette";
      on_func = [ "glyph_palette#apply" ];
    }
    {
      repo = "mbbill/undotree";
      on_cmd = [ "UndotreeToggle" ];
      hook_add = ''
        nnoremap <Leader>u <cmd>UndotreeToggle<CR>
      '';
    }
    {
      repo = "lambdalisue/vim-suda";
      on_event = "BufRead";
      hook_add = ''
        let g:suda_smart_edit=v:true
      '';
    }
    {
      repo = "previm/previm";
      on_ft = [ "markdown" ];
      hook_add = ''
        let g:previm_open_cmd='open'
      '';
    }
    {
      repo = "machakann/vim-sandwich";
      on_map = [
        "<Plug>(operator-sandwich"
        "<Plug>(textobj-sandwich"
      ];
      hooks_file = ./hooks/sandwich.vim;
    }
    {
      repo = "arthurxavierx/vim-caser";
      on_map = "<Plug>Caser";
      hook_add = ''
        let g:caser_no_mappings = 1
        nmap gs_ <Plug>CaserSnakeCase
        nmap gsc <Plug>CaserCamelCase
        nmap gsm <Plug>CaserMixedCase
      '';
    }
  ];
}
