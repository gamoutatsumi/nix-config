{ pkgs }:
{
  plugins = [
    {
      repo = "Shougo/ddc.vim";
      hooks_file = pkgs.replaceVars ./hooks/ddc.vim {
        ddc_ts = "${
          pkgs.linkFarm "ddc-hooks" [
            {
              name = "ddc.ts";
              path = ./hooks/ddc.ts;
            }
            {
              name = "deno.json";
              path = ./hooks/deno.json;
            }
          ]
        }/ddc.ts";
      };
    }
    {
      repo = "Shougo/ddc-ui-pum";
    }
    {
      repo = "Shougo/ddc-sorter_rank";
    }
    {
      repo = "Shougo/ddc-matcher_head";
    }
    {
      repo = "tani/ddc-fuzzy";
    }
    {
      repo = "Shougo/ddc-around";
    }
    {
      repo = "LumaKernel/ddc-source-file";
    }
    {
      repo = "Shougo/pum.vim";
      hooks_file = ./hooks/pum.vim;
    }
    {
      repo = "hrsh7th/completion-snippet";
      merged = 0;
    }
    {
      repo = "Shougo/ddc-source-omni";
    }
    {
      repo = "kristijanhusak/vim-dadbod-completion";
    }
    {
      repo = "gamoutatsumi/ddc-sorter_ascii";
    }
    {
      repo = "Shougo/ddc-source-cmdline";
    }
    {
      repo = "Shougo/ddc-source-cmdline_history";
    }
    {
      repo = "Shougo/ddc-filter-converter_truncate_abbr";
    }
    {
      repo = "Shougo/ddc-filter-converter_remove_overlap";
    }
    {
      repo = "Shougo/ddc-source-copilot";
    }
    {
      repo = "uga-rosa/denippet.vim";
      hooks_file = ./hooks/denippet.lua;
    }
    {
      repo = "Shougo/ddc-source-lsp";
    }
    {
      repo = "Shougo/ddc-filter-sorter_lsp_kind";
    }
    {
      repo = "Shougo/ddc-filter-converter_kind_labels";
    }
  ];
}
