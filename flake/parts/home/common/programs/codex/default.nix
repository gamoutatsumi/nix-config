{
  upkgs,
  ...
}:
{
  programs = {
    codex = {
      enable = true;
      package = upkgs.llm-agents.codex;
      settings = {
        model_reasoning_effort = "high";
        network_access = true;
        tools = {
          web_search = true;
        };
      };
      custom-instructions = builtins.readFile ../AGENTS.md;
    };
  };
}
