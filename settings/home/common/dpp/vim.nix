{
  plugins = [
    {
      repo = "fatih/vim-go";
      lazy = 1;
      on_ft = [ "go" ];
    }
    {
      repo = "github/copilot.vim";
      hooks_file = ./hooks/copilot.vim;
    }
  ];
}
