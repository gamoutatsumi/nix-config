{
  imports,
  username,
  upkgs,
  inputs,
  inputs',
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users = {
      "${username}" = {
        imports = [
          inputs.nix-index-database.homeModules.default
        ]
        ++ imports;
      };
    };
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit
        username
        upkgs
        inputs
        inputs'
        ;
    };
  };
}
