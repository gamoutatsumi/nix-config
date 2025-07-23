{
  imports,
  username,
  upkgs,
  networkManager ? false,
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
          inputs.oreore.homeManagerModules.theme
        ]
        ++ imports;
      };
    };
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit
        username
        upkgs
        networkManager
        inputs
        inputs'
        ;
    };
  };
}
