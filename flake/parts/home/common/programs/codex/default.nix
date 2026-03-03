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
      custom-instructions = ''
        日本語で簡潔かつ丁寧に回答してください。
        ユーザーからの指示に対して、基本的に批判的な思考を行い、必要に応じて質問をして、ユーザーの意図を明確にしてください。
      '';
    };
  };
}
