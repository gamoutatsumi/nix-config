{
  upkgs,
  inputs,
  config,
  ...
}:
let
  mcpConfig = inputs.mcp-servers-nix.lib.mkConfig upkgs {
    format = "toml-inline";
    fileName = ".mcp.toml";
    flavor = "codex";
    programs = {
      sequential-thinking = {
        enable = true;
      };
      github = {
        enable = true;
        passwordCommand = {
          GITHUB_PERSONAL_ACCESS_TOKEN = [
            (upkgs.lib.getExe config.programs.gh.package)
            "auth"
            "token"
          ];
        };
      };
      filesystem = {
        enable = true;
      };
      context7 = {
        enable = true;
      };
      serena = {
        enable = true;
        context = "codex";
        enableWebDashboard = false;
      };
    };
  };
in
{
  programs = {
    codex = {
      enable = true;
      package = upkgs.symlinkJoin {
        name = "codex";
        paths = [ upkgs.codex ];
        nativeBuildInputs = [ upkgs.makeWrapper ];
        meta = {
          inherit (upkgs.codex.meta) mainProgram;
        };
        postBuild = ''
          wrapProgram $out/bin/codex "--add-flags" "-c '$(cat ${mcpConfig})'"
        '';
      };
    };
  };
}
