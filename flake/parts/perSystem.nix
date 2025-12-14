{
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      system,
      pkgs,
      lib,
      config,
      inputs',
      ...
    }:
    let
      upkgs = import ../../upkgs.nix {
        inherit system inputs;
      };
      treefmtBuild = config.treefmt.build;
    in
    {
      # keep-sorted start block=yes
      agenix-rekey = {
        inherit (self') nixosConfigurations;
        pkgs = upkgs;
      };
      devShells = {
        default = pkgs.mkShellNoCC {
          PFPATH = "${
            pkgs.buildEnv {
              name = "zsh-comp";
              paths = config.devShells.default.nativeBuildInputs;
              pathsToLink = [ "/share/zsh" ];
            }
          }/share/zsh/site-functions";
          packages =
            (with pkgs; [
              lua-language-server
              docker-language-server
              bash-language-server
              nvfetcher
              nodePackages_latest.vscode-json-languageserver
              # (pkgs.haskell.packages.ghc98.ghcWithPackages (
              #   haskellPackages:
              #   with haskellPackages;
              #   [
              #     containers
              #     unix
              #     directory
              #     haskell-language-server
              #   ]
              #   ++ lib.optionals pkgs.stdenv.isLinux [
              #     xmonad
              #     xmonad-extras
              #     xmonad-contrib
              #   ]
              # ))
            ])
            ++ (with upkgs; [ tombi ]);
          inputsFrom = [
            config.pre-commit.devShell
            treefmtBuild.devShell
          ];
        };
      };
      formatter = treefmtBuild.wrapper;
      pre-commit = {
        check = {
          enable = true;
        };
        settings = {
          src = ./.;
          hooks = {
            # keep-sorted start block=yes
            check-json = {
              enable = true;
            };
            check-toml = {
              enable = true;
            };
            denolint = {
              enable = true;
              package = upkgs.deno;
            };
            flake-checker = {
              enable = false;
              package = inputs'.flake-checker.packages.flake-checker;
            };
            treefmt = {
              enable = true;
              packageOverrides.treefmt = treefmtBuild.wrapper;
            };
            yamllint = {
              enable = true;
            };
            actionlint = {
              enable = true;
            };
            # keep-sorted end
          };
        };
      };
      treefmt = {
        projectRootFile = "flake.nix";
        flakeCheck = false;
        settings = {
          formatter = {
            # keep-sorted start block=yes
            deadnix = {
              excludes = [ "_sources/*" ];
            };
            deno = {
              excludes = [ "_sources/*" ];
            };
            jsonfmt = {
              excludes = [ "_sources/*" ];
            };
            nixfmt = {
              excludes = [ "_sources/*" ];
            };
            prettier = {
              includes = lib.mkForce [ "*.md" ];
            };
            statix = {
              excludes = [
                ".direnv/*"
                "_sources/*"
              ];
            };
            tombi = {
              command = lib.getExe upkgs.tombi;
              options = [
                "format"
                "--offline"
              ];
              includes = [ "*.toml" ];
            };
            # keep-sorted end
          };
        };
        programs = {
          # keep-sorted start block=yes
          cue = {
            enable = true;
          };
          deadnix = {
            enable = true;
          };
          deno = {
            enable = true;
            package = upkgs.deno;
          };
          hlint = {
            enable = true;
          };
          jsonfmt = {
            enable = true;
          };
          keep-sorted = {
            enable = true;
          };
          nixfmt = {
            enable = true;
          };
          prettier = {
            enable = true;
          };
          shfmt = {
            enable = true;
          };
          statix = {
            enable = true;
          };
          stylish-haskell = {
            enable = true;
          };
          stylua = {
            enable = true;
            package = upkgs.stylua;
          };
          taplo = {
            enable = true;
          };
          yamlfmt = {
            enable = true;
          };
          # keep-sorted end
        };
      };
      checks = {
        inherit (upkgs) neovim;
      };
      # keep-sorted end
    };
}
