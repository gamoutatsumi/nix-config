{ pkgs, ... }: {
  services = {
    gpg-agent = {
      pinentry = {
        package = pkgs.pinentry_mac;
      };
    };
  };
}
