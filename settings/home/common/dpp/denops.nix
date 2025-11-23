{ pkgs }:
{
  plugins = [
    {
      repo = "vim-denops/denops.vim";
      lazy = false;
    }
    {
      repo = "vim-denops/denops-shared-server.vim";
    }
    {
      repo = "gamoutatsumi/dps-ghosttext.vim";
      depends = "denops.vim";
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
      depends = "denops.vim";
      on_cmd = "GyazoUpload";
      hook_add = ''
        let g:gyazo#token=$GYAZO_TOKEN
      '';
    }
    {
      repo = "kat0h/bufpreview.vim";
      build = "deno task prepare";
      depends = "denops.vim";
    }
    {
      repo = "yuki-yano/fuzzy-motion.vim";
      depends = "denops.vim";
      hook_add = ''
        nnoremap gfs <Cmd>FuzzyMotion<CR>
      '';
    }
    {
      repo = "lambdalisue/vim-gin";
      depends = "denops.vim";
    }
    {
      repo = "lambdalisue/vim-kensaku";
      depends = "denops.vim";
      denops_wait = false;
      hook_add = ''
        let g:kensaku_disable_v3_migration_warning = 1
      '';
    }
    {
      repo = "lambdalisue/vim-guise";
      lazy = 0;
    }
    {
      repo = "yuki-yano/resonator.vim";
      depends = "denops.vim";
    }
  ];
}
