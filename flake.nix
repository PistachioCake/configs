{
  description = "PistachioCake's system configurations";

  inputs = {
    # flake-parts and modules
    flake-parts.url = "github:hercules-ci/flake-parts";
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

    # dev utilities for this flake
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix.url = "github:ryantm/agenix";

    # nixpkgs and other packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/flake
        ./systems
      ];
    };
}
