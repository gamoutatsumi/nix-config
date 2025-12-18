{ pkgs }:
{
  plugins = [
    {
      repo = "gamoutatsumi/dps-ghosttext.vim";
    }
    {
      repo = "vim-skk/skkeleton";
      hooks_file = pkgs.replaceVarsWith {
        src = ./hooks/skkeleton.vim;
        replacements = {
          skk_dict = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
        };
      };
    }
    {
      repo = "gamoutatsumi/gyazoupload.vim";
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
