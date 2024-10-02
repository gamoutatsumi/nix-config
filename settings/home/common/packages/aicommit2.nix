{ pkgs, ... }:
let
  nodejs = pkgs.nodejs_18;
  pnpm = pkgs.pnpm_8;
in
{
  home.packages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "aicommit2";
      version = "2.1.4";
      src = pkgs.fetchFromGitHub {
        owner = "tak-bro";
        repo = "aicommit2";
        rev = "v${version}";
        hash = "sha256-r8H+b/oC4Et/7LvO3jiLOZ2eLBhCAFZbkJW+0TA41yE=";
      };
      buildInputs = [ nodejs ];
      nativeBuildInputs = [
        pnpm.configHook
        pkgs.makeWrapper
      ];
      pnpmDeps = pnpm.fetchDeps {
        inherit pname version src;
        hash = "sha256-DiEmhDXdjDHTkOq5iISQLEYohFcAmJ7hXGDO+cY4PhI=";
      };
      buildPhase = ''
        runHook preBuild

        pnpm build

        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall

        mkdir -p $out/{lib,bin}
        cp -r {node_modules,dist} $out/lib

        makeWrapper $out/lib/dist/cli.mjs $out/bin/aicommit2

        runHook postInstall
      '';
    })
  ];
}
