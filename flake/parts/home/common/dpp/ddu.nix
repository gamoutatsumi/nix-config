{ pkgs }:
{
  plugins = [
    {
      repo = "Shougo/ddu.vim";
      hooks_file = pkgs.replaceVars ./hooks/ddu.vim {
        ddu_ts = "${
          pkgs.linkFarm "ddu-hooks" [
            {
              name = "ddu.ts";
              path = ./hooks/ddu.ts;
            }
            {
              name = "deno.json";
              path = ./hooks/deno.json;
            }
          ]
        }/ddu.ts";
      };
    }
    {
      repo = "Shougo/ddu-ui-ff";
    }
    {
      repo = "Shougo/ddu-ui-filer";
      hook_add = ''
        "nnoremap <silent> <C-e> <Cmd>call ddu#start({'ui': 'filer', 'sources': [{'name': 'file', 'params': {}}], 'sourceOptions': {'_': {'columns': ['icon_filename']}}, 'kindOptions': {'file': { 'defaultAction': 'open' }}})<CR>
      '';
    }
    {
      repo = "Shougo/ddu-column-filename";
    }
    {
      repo = "Shougo/ddu-source-file";
    }
    {
      repo = "Shougo/ddu-source-file_rec";
    }
    {
      repo = "Shougo/ddu-kind-file";
    }
    {
      repo = "Shougo/ddu-filter-matcher_substring";
    }
    {
      repo = "yuki-yano/ddu-filter-fzf";
    }
    {
      repo = "Shougo/ddu-commands.vim";
    }
    {
      repo = "uga-rosa/ddu-source-lsp";
    }
    {
      repo = "shun/ddu-source-buffer";
    }
    {
      repo = "shun/ddu-source-rg";
    }
    {
      repo = "kuuote/ddu-source-mr";
    }
    {
      repo = "matsui54/ddu-source-file_external";
    }
    {
      repo = "ryota2357/ddu-column-icon_filename";
    }
    {
      repo = "Milly/ddu-filter-kensaku";
    }
    {
      repo = "kuuote/ddu-filter-fuse";
    }
    {
      repo = "Milly/ddu-filter-merge";
    }
    {
      repo = "matsui54/ddu-vim-ui-select";
    }
    {
      repo = "matsui54/ddu-source-help";
    }
    {
      repo = "uga-rosa/ddu-filter-converter_devicon";
    }
    {
      repo = "Shougo/ddu-source-action";
    }
    {
      repo = "kuuote/ddu-source-git_diff";
    }
    {
      repo = "kuuote/ddu-source-git_status";
    }
    {
      repo = "kyoh86/ddu-filter-converter_hl_dir";
    }
    {
      repo = "Shougo/ddu-filter-matcher_relative";
    }
    {
      repo = "gamoutatsumi/ddu-filter-converter_relativepath";
    }
    {
      repo = "Shougo/ddu-source-output";
    }
    {
      repo = "Shougo/ddu-kind-word";
    }
  ];
}
