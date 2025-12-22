{
  plugins = [
    {
      repo = "neovim/nvim-lspconfig";
      hooks_file = [ ./hooks/nvim_lsp.lua ];
    }
    {
      repo = "hrsh7th/nvim-gtd";
      lua_add = ''
        require('gtd').setup({})
      '';
    }
    {
      repo = "b0o/schemastore.nvim";
    }
    {
      repo = "ray-x/lsp_signature.nvim";
      hooks_file = [ ./hooks/lsp_signature.lua ];
    }
    {
      repo = "creativenull/efmls-configs-nvim";
    }
    {
      repo = "uga-rosa/ddc-source-lsp-setup";
    }
  ];
}
