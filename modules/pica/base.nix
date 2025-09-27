{ pkgs, ... }:
{
  # Enable the `nix` command, and the flakes feature
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # pin the nixpkgs registry to the system nixpkgs, so we don't download
  # and evaluate nixpkgs when we `$ nix shell nixpkgs#hello -- hello`
  nix.registry = {
    nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
  };
}
