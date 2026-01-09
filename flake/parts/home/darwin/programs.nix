{
  pkgs,
  upkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with upkgs; [
      # keep-sorted start block=yes
      arto
      colima
      container
      docker-client
      podman
      # keep-sorted end
    ];
  };
  services = {
    jankyborders = {
      enable = true;
    };
  };
  programs = {
    # keep-sorted start block=yes
    aerospace =
      let
        sketchybar = lib.getExe config.programs.sketchybar.package;
      in
      {
        enable = true;
        launchd = {
          enable = true;
        };
        extraConfig = ''
          [[on-window-detected]]
          if.app-id = "com.tinyspeck.slackmacgap"
          run = "move-node-to-workspace 10"
          [[on-window-detected]]
          if.app-id = "org.alacritty"
          run = "move-node-to-workspace 3"
          [[on-window-detected]]
          if.app-id = "com.vivaldi.Vivaldi"
          run = "move-node-to-workspace 1"
          [[on-window-detected]]
          if.app-id = "com.google.Chrome"
          run = "move-node-to-workspace 2"
          [[on-window-detected]]
          if.app-id = "com.hnc.Discord"
          run = "move-node-to-workspace 9"
        '';
        userSettings = {
          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];
          on-focus-changed = [ "move-mouse window-lazy-center" ];
          gaps = {
            inner = {
              horizontal = 10;
              vertical = 10;
            };
            outer = {
              left = 10;
              bottom = 10;
              top = 10;
              right = 10;
            };
          };
          mode = {
            main = {
              binding = {
                alt-shift-h = "focus-monitor left";
                alt-shift-l = "focus-monitor right";
                alt-shift-ctrl-h = "move-workspace-to-monitor left";
                alt-shift-ctrl-l = "move-workspace-to-monitor right";
                alt-slash = "layout tiles horizontal vertical";
                alt-comma = "layout accordion horizontal vertical";
                alt-1 = "workspace 1";
                alt-2 = "workspace 2";
                alt-3 = "workspace 3";
                alt-4 = "workspace 4";
                alt-5 = "workspace 5";
                alt-6 = "workspace 6";
                alt-7 = "workspace 7";
                alt-8 = "workspace 8";
                alt-9 = "workspace 9";
                alt-0 = "workspace 10";
                alt-ctrl-1 = "move-node-to-workspace 1";
                alt-ctrl-2 = "move-node-to-workspace 2";
                alt-ctrl-3 = "move-node-to-workspace 3";
                alt-ctrl-4 = "move-node-to-workspace 4";
                alt-ctrl-5 = "move-node-to-workspace 5";
                alt-ctrl-6 = "move-node-to-workspace 6";
                alt-ctrl-7 = "move-node-to-workspace 7";
                alt-ctrl-8 = "move-node-to-workspace 8";
                alt-ctrl-9 = "move-node-to-workspace 9";
                alt-ctrl-0 = "move-node-to-workspace 10";
                alt-ctrl-h = "move left";
                alt-ctrl-l = "move right";
              };
            };
          };
        };
      };
    alacritty = {
      settings = {
        font = {
          size = 15;
        };
      };
    };
    ghostty = {
      package = upkgs.ghostty-bin;
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry_mac;
      };
    };
    ssh = {
      package = pkgs.openssh;
    };
    # keep-sorted end
  };
}
