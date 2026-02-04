{
  upkgs,
  ...
}:
{
  programs = {
    codex = {
      enable = true;
      package = upkgs.llm-agents.codex;
    };
  };
}
