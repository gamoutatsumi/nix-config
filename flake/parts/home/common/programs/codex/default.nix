{
  inputs',
  ...
}:
{
  programs = {
    codex = {
      enable = true;
      package = inputs'.llm-agents.packages.codex;
      settings = {
        model_reasoning_effort = "high";
        network_access = true;
        tools = {
          web_search = true;
        };
      };
      context = builtins.readFile ../../agents/AGENTS.md;
    };
  };
}
