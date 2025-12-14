{
  format ? "json",
  flavor ? "claude",
  pkgs,
  config,
  inputs,
}:
inputs.mcp-servers-nix.lib.mkConfig pkgs {
  inherit format flavor;
  programs = {
    fetch = {
      enable = false;
    };
    time = {
      enable = true;
      args = [
        "--local-timezone"
        "Asia/Tokyo"
      ];
    };
    git = {
      enable = true;
    };
    sequential-thinking = {
      enable = true;
    };
    github = {
      enable = true;
      passwordCommand = {
        GITHUB_PERSONAL_ACCESS_TOKEN = [
          (pkgs.lib.getExe config.programs.gh.package)
          "auth"
          "token"
        ];
      };
    };
    filesystem = {
      enable = false;
    };
    playwright = {
      enable = true;
    };
    context7 = {
      enable = true;
    };
  };
  settings = {
    servers = {
      astro = {
        url = "http://localhost:4321/__mcp/sse";
      };
    };
  };
}
