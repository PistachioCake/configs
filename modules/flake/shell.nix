{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "config";
        meta.description = "Devshell";
        packages = [
          config.formatter
          inputs.agenix.packages.${system}.default
        ];
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    };
}
