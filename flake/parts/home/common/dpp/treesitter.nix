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
      repo = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      hooks_file = ./hooks/rainbow.lua;
      build = "git update-index --skip-worktree test && /bin/rm -rf test";
    }
    {
      repo = "JoosepAlviste/nvim-ts-context-commentstring";
      on_ft = [
        "typescript"
        "javascript"
        "javascriptreact"
        "typescriptreact"
      ];
    }
    {
      repo = "nvim-treesitter/nvim-treesitter-context";
      hooks_file = ./hooks/context.lua;
    }
  ];
}
