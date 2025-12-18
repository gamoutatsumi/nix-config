{ pkgs }:
{
  plugins = [
    {
      repo = "tversteeg/registers.nvim";
      lua_add = ''
        require('registers').setup {}
      '';
    }
    {
      repo = "lewis6991/gitsigns.nvim";
      hooks_file = ./hooks/gitsigns.lua;
    }
    {
      repo = "nvim-lualine/lualine.nvim";
      hooks_file = ./hooks/lualine.lua;
    }
    {
      repo = "kyazdani42/nvim-web-devicons";
    }
    {
      repo = "romgrk/barbar.nvim";
      hooks_file = [
        ./hooks/barbar.vim
        ./hooks/barbar.lua
      ];
    }
    {
      repo = "folke/flash.nvim";
      hooks_file = ./hooks/flash.lua;
    }
    {
      repo = "kwkarlwang/bufresize.nvim";
    }
    {
      repo = "aserowy/tmux.nvim";
      lua_add = ''
        require('tmux').setup({
          navigation = {
            enable_default_keybindings = true,
          },
          copy_sync = {
            enable = false,
          },
        })
      '';
    }
    {
      repo = "MunifTanjim/nui.nvim";
    }
    {
      repo = "zah/nim.vim";
    }
    {
      repo = "levouh/tint.nvim";
      lua_add = ''
        require('tint').setup {}
      '';
    }
    {
      repo = "uga-rosa/ccc.nvim";
      lua_add = ''
        require('ccc').setup {}
      '';
    }
    {
      repo = "rcarriga/nvim-notify";
      lua_add = ''
        require('notify').setup {
          background_colour = "#000000",
        }
      '';
    }
    {
      repo = "monaqa/dial.nvim";
      hooks_file = [ ./hooks/dial.vim ];
    }
    {
      repo = "ray-x/guihua.lua";
    }
    {
      repo = "linrongbin16/gitlinker.nvim";
      lua_add = ''
        require('gitlinker').setup()
      '';
    }
    {
      repo = "stevearc/aerial.nvim";
      hooks_file = ./hooks/aerial.lua;
    }
    {
      repo = "tani/podium";
      lua_add = ''
        vim.api.nvim_create_user_command("Podium", function()
          local podium = require("podium")
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
          local output = podium.process(podium.html, table.concat(lines, "\n"))
          vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(output, "\n"))
          vim.api.nvim_set_option_value("modified", false, { buf = 0 })
          vim.api.nvim_set_option_value("filetype", "html", { buf = 0 })
        end, {})
      '';
    }
    {
      repo = "uga-rosa/translate.nvim";
      lua_add = ''
        require("translate").setup {
           default = {
              command = "google",
              output = "floating",
              parse_after = "head"
           }
        }
      '';
    }
    {
      repo = "lukas-reineke/indent-blankline.nvim";
      hooks_file = [ ./hooks/indent_blankline.lua ];
    }
    {
      repo = "numToStr/Comment.nvim";
      hooks_file = [ ./hooks/comment.lua ];
    }
    {
      repo = "bakpakin/Fennel";
      rev = "1.3.1";
      rtp = "nvim";
      extAttrs = {
        installerBuild = ''make LUA="nvim -ll" fennel.lua && mv fennel.lua nvim/lua/fennel.lua'';
      };
    }
    {
      repo = "j-hui/fidget.nvim";
      rev = "v1.6.1";
      hooks_file = [ ./hooks/fidget.lua ];
    }
    {
      repo = "stevearc/dressing.nvim";
      hooks_file = [ ./hooks/dressing.lua ];
    }
    {
      repo = "stevearc/oil.nvim";
      lua_add = ''
        require('oil').setup()
      '';
    }
    {
      repo = "liangxianzhe/floating-input.nvim";
      lua_add = ''
        vim.ui.input = function(opts, on_confirm)
          require('floating-input').input(opts, on_confirm, { border = 'double' })
        end
      '';
    }
    {
      repo = "zbirenbaum/copilot.lua";
      on_event = [ "InsertEnter" ];
      hooks_file = [
        (pkgs.replaceVarsWith {
          src = ./hooks/copilot.lua;
          replacements = {
            copilot_ls = pkgs.lib.getExe pkgs.copilot-language-server;
          };
        })
      ];
    }
    {
      repo = "h3pei/trace-pr.nvim";
    }
    {
      repo = "hrsh7th/nvim-insx";
      hooks_file = [ ./hooks/insx.lua ];
    }
    {
      repo = "lambdalisue/nvim-aibo";
      hooks_file = [ ./hooks/aibo.lua ];
    }
  ];
}
