{
  format ? "json",
  flavor ? "claude",
  pkgs,
  config,
  lib,
  inputs,
}:
inputs.mcp-servers-nix.lib.mkConfig pkgs {
  inherit format flavor;
  programs = {
    fetch = {
      enable = true;
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
  };
  settings = {
    servers =
      {
        # yasunori = {
        #   command = lib.getExe pkgs.yasunori-mcp;
        # };
        astro = {
          url = "http://localhost:4321/__mcp/sse";
        };
      }
      // lib.optionalAttrs config.services.mpd.enable {
        mpd = {
          command = lib.getExe pkgs.mpd-mcp-server;
        };
      };
  };
}
