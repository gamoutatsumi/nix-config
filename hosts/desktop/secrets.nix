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
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI/TWXrTv5lopiI1gKKhs1CDnqvzumkDTDYgCDpZDSp";
      masterIdentities = [ ../../age-yubikey-identity-e3f27149.pub ];
      storageMode = "local";
      localStorageDir = ../../. + "/secrets/rekeyed/${config.networking.hostName}";
    };
  };
}
