{
  upkgs,
  ...
}:
{
  programs = {
    codex = {
      enable = true;
      package = upkgs.codex;
    };
  };
}
