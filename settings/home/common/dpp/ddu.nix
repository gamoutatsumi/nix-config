{
  plugins = [
    {
      repo = "Shougo/ddu.vim";
      hooks_file = "$BASE_DIR/dpp/ddu.vim";
      build = "git update-index --skip-worktree denops/ddu/_mods.js";
    }
    {
      repo = "Shougo/ddu-ui-ff";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-ui-filer";
      on_source = "ddu.vim";
      hook_add = ''
        "nnoremap <silent> <C-e> <Cmd>call ddu#start({'ui': 'filer', 'sources': [{'name': 'file', 'params': {}}], 'sourceOptions': {'_': {'columns': ['icon_filename']}}, 'kindOptions': {'file': { 'defaultAction': 'open' }}})<CR>
      '';
    }
    {
      repo = "Shougo/ddu-column-filename";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-source-file";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-source-file_rec";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-kind-file";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-filter-matcher_substring";
      on_source = "ddu.vim";
    }
    {
      repo = "yuki-yano/ddu-filter-fzf";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-commands.vim";
      depends = [ "ddu.vim" ];
    }
    {
      repo = "uga-rosa/ddu-source-lsp";
      on_source = "ddu.vim";
    }
    {
      repo = "shun/ddu-source-buffer";
      on_source = "ddu.vim";
    }
    {
      repo = "shun/ddu-source-rg";
      on_source = "ddu.vim";
    }
    {
      repo = "kuuote/ddu-source-mr";
      on_source = "ddu.vim";
    }
    {
      repo = "matsui54/ddu-source-file_external";
      on_source = "ddu.vim";
    }
    {
      repo = "ryota2357/ddu-column-icon_filename";
      on_source = "ddu.vim";
    }
    {
      repo = "Milly/ddu-filter-kensaku";
      on_source = "ddu.vim";
      depends = [ "vim-kensaku" ];
    }
    {
      repo = "kuuote/ddu-filter-fuse";
      on_source = "ddu.vim";
    }
    {
      repo = "Milly/ddu-filter-merge";
      on_source = "ddu.vim";
    }
    {
      repo = "matsui54/ddu-vim-ui-select";
      lazy = false;
    }
    {
      repo = "matsui54/ddu-source-help";
      on_source = "ddu.vim";
    }
    {
      repo = "uga-rosa/ddu-filter-converter_devicon";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-source-action";
      on_source = "ddu.vim";
    }
    {
      repo = "kuuote/ddu-source-git_diff";
      on_source = "ddu.vim";
    }
    {
      repo = "kuuote/ddu-source-git_status";
      on_source = "ddu.vim";
    }
    {
      repo = "kyoh86/ddu-filter-converter_hl_dir";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-filter-matcher_relative";
      on_source = "ddu.vim";
    }
    {
      repo = "gamoutatsumi/ddu-filter-converter_relativepath";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-source-output";
      on_source = "ddu.vim";
    }
    {
      repo = "Shougo/ddu-kind-word";
      on_source = "ddu.vim";
    }
  ];
}
