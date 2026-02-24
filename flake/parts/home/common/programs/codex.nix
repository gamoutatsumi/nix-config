{
  upkgs,
  ...
}:
{
  programs = {
    codex = {
      enable = false;
      package = upkgs.llm-agents.codex;
    };
  };
}
