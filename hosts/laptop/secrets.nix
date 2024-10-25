{ config, ... }:
{
  age = {
    secrets = {
      gamoutatsumi = {
        rekeyFile = ../../secrets/gamoutatsumi.age;
      };
      nixos = {
        rekeyFile = ../../secrets/nixos.age;
      };
    };
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICuK9+clVTBeksFwirY7KhnWnCeOuGrVHcCQ/EYsQmiE";
      masterIdentities = [ ../../age-yubikey-identity-e3f27149.pub ];
      storageMode = "local";
      localStorageDir = ../../. + "/secrets/rekeyed/${config.networking.hostName}";
    };
  };
}
