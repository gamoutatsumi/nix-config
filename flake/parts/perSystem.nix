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
      config,
      inputs',
      ...
    }:
    let
      upkgs = import ../../upkgs.nix {
        inherit system inputs;
        inherit (pkgs) stdenv lib;
      };
      treefmtBuild = config.treefmt.build;
    in
    {
      _module = {
        args = {
          pkgs = import inputs.nixpkgs {
            overlays = [ (_final: _prev: { nodejs = upkgs.nodejs_20; }) ];
            inherit system;
          };
        };
      };
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
          packages = with pkgs; [
            lua-language-server
            nvfetcher
            (pkgs.haskell.packages.ghc98.ghcWithPackages (
              haskellPackages:
              with haskellPackages;
              [
                containers
                unix
                directory
                haskell-language-server
              ]
              ++ lib.optionals pkgs.stdenv.isLinux [
                xmonad
                xmonad-extras
                xmonad-contrib
              ]
            ))
          ];
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
            # keep-sorted end
          };
        };
      };
      treefmt = {
        projectRootFile = "flake.nix";
        flakeCheck = false;
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
      # keep-sorted end
    };
}
