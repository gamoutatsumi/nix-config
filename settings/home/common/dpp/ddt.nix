{
  plugins = [
    {
      repo = "Shougo/ddt.vim";
      depends = [ "denops.vim" ];
    }
    {
      repo = "Shougo/ddt-ui-terminal";
      on_source = "ddt.vim";

    }
  ];
}
