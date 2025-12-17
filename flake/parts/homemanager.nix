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
        inputs
        inputs'
        ;
    };
  };
}
