{ username, lib, ... }:
{
  home.homeDirectory = lib.mkForce "/Users/${username}";
}
