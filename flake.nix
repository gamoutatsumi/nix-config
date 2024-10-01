{
  description = "Nix(OS) Configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # keep-sorted start block=yes
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    dagger = {
      url = "github:dagger/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.neovim-src = {
        url = "github:neovim/neovim";
        flake = false;
      };
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    oreore = {
      url = "github:gamoutatsumi/oreore-flake";
    };
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    # keep-sorted end
  };

  outputs =
    {
      self,
      # keep-sorted start
      agenix,
      agenix-rekey,
      dagger,
      disko,
      flake-utils,
      home-manager,
      lanzaboote,
      neovim-nightly-overlay,
      nixpkgs,
      nixpkgs-unstable,
      oreore,
      pre-commit-hooks,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hooks = pre-commit-hooks.lib.${system};
        treefmtEval = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      in
      {
        formatter = (treefmtEval.config.build.wrapper);
        checks = {
          pre-commit-check = hooks.run {
            src = ./.;
            hooks = {
              treefmt = {
                packageOverrides.treefmt = (treefmtEval.config.build.wrapper);
                enable = true;
              };
            };
          };
        };
        devShells = {
          default = pkgs.mkShell {
            packages =
              (with pkgs; [
                nixd
                nixfmt-rfc-style
                lua-language-server
                efm-langserver
                stylua
              ])
              ++ [ dagger.packages.${system}.dagger ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          };
        };
      }
    ))
    // (
      let
        username = "gamoutatsumi";
        system = "x86_64-linux";
        overlays = [
          oreore.overlays.default
          agenix.overlays.default
          agenix-rekey.overlays.default
        ];
        upkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };
      in
      {
        nixosConfigurations."tat-nixos-desktop" = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
            username = username;
            upkgs = upkgs;
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
                  "${username}" = {
                    imports = [ ./settings/home/linux.nix ];
                  };
                };
                extraSpecialArgs = {
                  username = username;
                  upkgs = upkgs;
                };
              };
            }
          ];
        };
      }
    )
    // {
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
      };
    };
}
