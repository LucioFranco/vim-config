{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-github-actions,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          pkgs,
          system,
          self',
          ...
        }:
        let
          nixvimPkgs = inputs.nixvim.legacyPackages.${system};
          nixvimLib = inputs.nixvim.lib.${system};
          nixvimModule = {
            inherit pkgs;
            module = import ./config;
          };
        in
        {
          checks.nixvim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;

          packages = {
            default = self'.packages.neovim;
            neovim = nixvimPkgs.makeNixvimWithModule nixvimModule;
          };

          overlayAttrs = {
            inherit (config.packages) neovim;
          };

          devShells.default = pkgs.mkShell {
            name = "vim-config";

            nativeBuildInputs =
              with pkgs;
              [
                nixd
                statix
                config.treefmt.build.wrapper
              ]
              ++ (lib.attrValues config.treefmt.build.programs);

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          pre-commit = {
            check.enable = true;
            settings.hooks = {
              actionlint.enable = true;
              statix.enable = true;
              treefmt.enable = true;
            };
          };

          treefmt = {
            projectRootFile = "flake.nix";
            flakeCheck = false; # Covered by git-hooks check
            programs = {
              nixfmt.enable = true;
            };
          };
        };
      flake = {
        githubActions = nix-github-actions.lib.mkGithubMatrix {
          checks = self.packages;
        };
      };
    };
}
