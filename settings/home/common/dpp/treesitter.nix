{
  plugins = [
    {
      repo = "nvim-treesitter/nvim-treesitter";
      rev = "main";
      hooks_file = "$BASE_DIR/dpp/treesitter.lua";
    }
    {
      repo = "windwp/nvim-ts-autotag";
    }
    {
      repo = "nvim-treesitter/nvim-treesitter-textobjects";
      rev = "main";
    }
    {
      repo = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      hooks_file = "$BASE_DIR/dpp/rainbow.lua";
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
      hooks_file = "$BASE_DIR/dpp/context.lua";
    }
  ];
}
