{
  plugins = [
    {
      repo = "windwp/nvim-ts-autotag";
    }
    {
      repo = "nvim-treesitter/nvim-treesitter-textobjects";
      rev = "main";
      hooks_file = [ ./hooks/treesitter_textobjects.lua ];
    }
    {
      repo = "HiPhish/rainbow-delimiters.nvim";
      hooks_file = ./hooks/rainbow.lua;
    }
    {
      repo = "nvim-treesitter/nvim-treesitter-context";
      hooks_file = ./hooks/context.lua;
    }
  ];
}
