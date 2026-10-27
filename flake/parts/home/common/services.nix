_: {
  services = {
    # Let Home Manager install and manage itself.
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
}
