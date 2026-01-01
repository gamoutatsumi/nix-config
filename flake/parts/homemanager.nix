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
          inputs.matugen.nixosModules.default
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
