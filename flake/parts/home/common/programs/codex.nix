{
  inputs',
  ...
}:
{
  programs = {
    codex = {
      enable = true;
      package = inputs'.llm-agents.packages.codex;
    };
  };
}
