{ pkgs, config, ... }:
{
  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 200;
          origin = "top-right";
          offset = "30x40";
          scale = 0;
          notification_limit = 0;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          indicate_hidden = true;
          transparency = 0;
          seperator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 3;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          sort = true;
          idle_threshold = 120;
          font = "IBMPlexSansJP-Regular 10";
          line_height = 0;
          markup = "full";
          format = ''<b>%a</b>\n<b>%s</b>\n%b'';
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;
          sticky_history = true;
          history_length = 20;
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 0;
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };
        experimental = {
          per_monitor_dpi = false;
        };
        urgency_low = {
          background = "$222D32";
          foreground = "#CFD8DC";
          timeout = 10;
        };
        urgency_normal = {
          background = "#222D32";
          foreground = "#CFD8DC";
          timeout = 10;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
        volume = {
          appname = "changeVolume";
          format = ''%s\n%b'';
          history_ignore = true;
          markup = "full";
        };
        slack = {
          appname = "Slack";
          markup = false;
        };
      };
      iconTheme = {
        inherit (config.gtk.iconTheme) package;
        name = "Vimix-Doder-dark";
      };
    };
  };
}
