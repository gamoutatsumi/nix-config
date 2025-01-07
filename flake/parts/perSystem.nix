{
  upkgsConf,
  denoVersion,
  localFlake,
}:
{
  system,
  pkgs,
  config,
  inputs',
  ...
}:
let
  upkgs = upkgsConf {
    inherit system;
    inherit (pkgs) stdenv lib;
  };
  treefmtBuild = config.treefmt.build;
  deno = if pkgs.stdenv.isLinux then upkgs.deno."${denoVersion}" else upkgs.deno;
in
{
  # keep-sorted start block=yes
  agenix-rekey = {
    inherit (localFlake) nixosConfigurations;
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
        ])
        ++ [ inputs'.dagger.packages.dagger ];
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
          package = deno;
        };
        flake-checker = {
          enable = true;
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
        package = deno;
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
}
