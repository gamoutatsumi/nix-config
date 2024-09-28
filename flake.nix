{
  description = "Nix(OS) Configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.neovim-src = {
        url = "github:neovim/neovim";
        flake = false;
      };
    };
    scripts = {
      url = "path:./scripts";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      neovim-nightly-overlay,
      scripts,
      lanzaboote,
      disko,
      agenix,
      agenix-rekey,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        scripts.overlays.default
        agenix.overlays.default
        agenix-rekey.overlays.default
      ];
      username = "gamoutatsumi";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      nixosConfigurations."tat-nixos-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          username = username;
        };
        modules = [
          { nixpkgs.overlays = overlays; }
          lanzaboote.nixosModules.lanzaboote
          disko.nixosModules.disko
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
          ./secrets.nix
          (import ./disko-config.nix { device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_24116U400484"; })
          ./hosts/desktop
          ./settings/nixos.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              users = {
                "${username}" = ./settings/home/linux.nix;
              };
              extraSpecialArgs = {
                username = username;
                upkgs = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                  overlays = [ neovim-nightly-overlay.overlays.default ];
                };
              };
            };
          }
        ];
      };
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
      };
    };
}
