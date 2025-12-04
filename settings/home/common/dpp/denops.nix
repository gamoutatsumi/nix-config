_: {
  plugins = [
    {
      repo = "gamoutatsumi/dps-ghosttext.vim";
      on_cmd = "GhostStart";
    }
    {
      repo = "vim-skk/skkeleton";
      hooks_file = "$BASE_DIR/dpp/skkeleton.vim";
      on_map = {
        ict = "<Plug>(skkeleton-toggle)";
      };
      on_event = "CursorHold";
    }
    {
      repo = "gamoutatsumi/gyazoupload.vim";
      on_cmd = "GyazoUpload";
      hook_add = ''
        let g:gyazo#token=$GYAZO_TOKEN
      '';
    }
    {
      repo = "kat0h/bufpreview.vim";
      build = "deno task prepare";
    }
    {
      repo = "yuki-yano/fuzzy-motion.vim";
      hook_add = ''
        nnoremap gfs <Cmd>FuzzyMotion<CR>
      '';
    }
    {
      repo = "lambdalisue/vim-gin";
    }
    {
      repo = "lambdalisue/vim-kensaku";
      hook_add = ''
        let g:kensaku_disable_v3_migration_warning = 1
      '';
    }
    {
      repo = "lambdalisue/vim-guise";
    }
    {
      repo = "yuki-yano/resonator.vim";
    }
  ];
}
