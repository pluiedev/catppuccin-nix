{
  description = "Soothing pastel theme for Nix";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nmd.url = "git+https://git.sr.ht/~rycee/nmd";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { nixpkgs, nmd, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      forEachSystem = fn:
        forAllSystems (system:
          fn {
            inherit system;
            pkgs = nixpkgsFor.${system};
          });
    in
    {
      nixosModules.catppuccin = import ./modules/nixos nixpkgs;
      homeManagerModules.catppuccin = import ./modules/home-manager nixpkgs;
      formatter = forEachSystem ({ pkgs, ... }: pkgs.nixpkgs-fmt);
      docs = forAllSystems (system:
        import ./docs nixpkgs {
          nmd = builtins.mapAttrs (_key: value: value.${system}) nmd;
        }
      );
    };
}
