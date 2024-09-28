{
  imports = [
    ./programs.nix
  ];
  home.file = {
    ".p10k.zsh".source = ./config/p10k.zsh;
  };
  xdg = {
    configFile = {
      "zeno".source = ./config/zeno;
      "ov/config.yaml".source = ./config/ov/config.yaml;
      "tmux".source = ./config/tmux;
      "sheldon".source = ./config/sheldon;
      "nvim".source = ./config/nvim;
      "alacritty/nightfly.toml".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
        sha256 = "03wks6pa3smsc9zgf5nlyyi9wxa9f5zjl1x57gsmcw4gdyxj6szv";
      };
      "bat/themes/fly16.tmTheme".source = builtins.fetchurl {
        url = "https://raw.githubuser.content.com/bluz71/fly16-bat/master/fly16.tmTheme";
        sha256 = "0xp10xdcsnfpwzhwpjj4jsgwjkzpaln2d2gc9iznfzkq95a9njs8";
      };
      "git/tempalte/hooks/pre-push".source = builtins.fetchurl {
        url = "https://gist.githubusercontent.com/quintok/815396509ff79d886656b2855e1a8a46/raw/e6770add98e7db57177c16d33be31bfdf2c23042/pre-push";

        sha256 = "0lynwihky1b6r8ssjzzw99p38vya39x204gknpi2fdg720jj87yj";
      };
      "git/config".source = ./config/git/config;
      "git/ignore".source = ./config/git/ignore;
    };
    dataFile = {
      "tmux/plugins/tpm".source = builtins.fetchTarball {
        url = "https://github.com/tmux-plugins/tpm/archive/refs/heads/master.zip";
        sha256 = "01ribl326n6n0qcq68a8pllbrz6mgw55kxhf9mjdc5vw01zjcvw5";
      };
    };
    enable = true;
  };
}
