{ inputs, ... }:
{
  imports = [
    ./locale.nix
    ./metrics.nix
    ./minecraft-server.nix
    ./nginx.nix
    ./pocket-id.nix
    ./system
  ];

  config = {
    nixpkgs.overlays = [
      (final: prev: { unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system}; })
    ];
  };
}
