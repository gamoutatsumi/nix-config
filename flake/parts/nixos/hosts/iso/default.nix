# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  networking = {
    hostName = "nixos";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    avahi = {
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
  isoImage = {
    squashfsCompression = "gzip -Xcompression-level 1";
  };

  users = {
    users = {
      root = {
        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFRrDiS89ueVv8c6AR9O5Css16oW0Tx/ufz9juokqPb gamoutatsumi@tat-nixos-desktop"
            ];
          };
        };
      };
    };
  };
}
