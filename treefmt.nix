{
  projectRootFile = "flake.nix";
  programs = {
    # keep-sorted start block=yes
    deno = {
      enable = true;
    };
    keep-sorted = {
      enable = true;
    };
    nixfmt = {
      enable = true;
    };
    stylua = {
      enable = true;
    };
    taplo = {
      enable = true;
    };
    # keep-sorted end
  };
}
