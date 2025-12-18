{
  plugins = [
    {
      repo = "Shougo/dpp.vim";
      rtp = "";
    }
    {
      repo = "Shougo/dpp-ext-installer";
      on_source = "dpp.vim";
      rtp = "";
    }
    {
      repo = "Shougo/dpp-ext-local";
    }
    {
      repo = "Shougo/dpp-ext-toml";
      on_source = "dpp.vim";
    }
    {
      repo = "Shougo/dpp-protocol-git";
      on_source = "dpp.vim";
    }
    {
      repo = "Shougo/dpp-ext-lazy";
      on_source = "dpp.vim";
    }
    {
      repo = "Shougo/dpp-ext-packspec";
      on_source = "dpp.vim";
    }
  ];
}
