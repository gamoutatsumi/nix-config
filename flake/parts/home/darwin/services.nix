{ pkgs, ... }: {
  services = {
    gpg-agent = {
      pinentry = pkgs.pinentry_mac;
    };
  };
}
