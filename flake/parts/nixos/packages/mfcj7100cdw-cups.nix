{
  # keep-sorted start
  lib,
  pkgs,
  # keep-sorted end
  ...
}:
let
  version = "3.5.0-1";
  name = "mfcj7100cdw-cups-${version}";
in
pkgs.stdenv.mkDerivation {
  inherit version name;

  src = pkgs.fetchurl {
    url = "https://download.brother.com/welcome/dlf105483/mfcj7100cdwpdrv-3.5.0-1.i386.deb";
    sha256 = "1l226v92yxkgzlll2ik4lgmffa8largy4q09jy2vsslz45jk5s32";
  };

  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  unpackPhase = ":";

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/mfcj7100cdw/cupswrapper/brother_mfcj7100cdw_printer_en.ppd \
      --replace '"Brother MFC-J7100CDW' '"Brother MFC-J7100CDW (modified)'

    substituteInPlace $out/opt/brother/Printers/mfcj7100cdw/lpd/filter_mfcj7100cdw \
      --replace /opt "$out/opt" \
      --replace /usr/bin/perl ${lib.getExe pkgs.perl} \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcj7100cdw\"; #"

    _PLAT=x86_64
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/mfcj7100cdw/lpd/$_PLAT/brprintconf_mfcj7100cdw
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/mfcj7100cdw/lpd/$_PLAT/brmfcj7100cdwfilter
    ln -s $out/opt/brother/Printers/mfcj7100cdw/lpd/$_PLAT/brprintconf_mfcj7100cdw $out/opt/brother/Printers/mfcj7100cdw/lpd/brprintconf_mfcj7100cdw
    ln -s $out/opt/brother/Printers/mfcj7100cdw/lpd/$_PLAT/brmfcj7100cdwfilter $out/opt/brother/Printers/mfcj7100cdw/lpd/brmfcj7100cdwfilter

    for f in \
      $out/opt/brother/Printers/mfcj7100cdw/cupswrapper/brother_lpdwrapper_mfcj7100cdw \
      $out/opt/brother/Printers/mfcj7100cdw/cupswrapper/cupswrappermfcj7100cdw \
    ; do
      #substituteInPlace $f \
      wrapProgram $f \
        --prefix PATH : ${
          lib.strings.makeBinPath (
            with pkgs;
            [
              coreutils
              ghostscript
              gnugrep
              gnused
            ]
          )
        }
    done

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj7100cdw/cupswrapper/brother_lpdwrapper_mfcj7100cdw $out/lib/cups/filter/brother_lpdwrapper_mfcj7100cdw

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/mfcj7100cdw/cupswrapper/brother_mfcj7100cdw_printer_en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/mfcj7100cdw/lpd/filter_mfcj7100cdw \
      --prefix PATH ":" ${
        lib.strings.makeBinPath (
          with pkgs;
          [
            ghostscript
            a2ps
            file
            gnused
            gnugrep
            coreutils
            which
          ]
        )
      }
  '';

  meta = {
    homepage = "https://www.brother.com/";
    description = "Brother MFC-J7100CDW combined print driver";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };
}
