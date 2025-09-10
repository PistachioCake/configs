{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.pica = {
    system.users = mkOption {
      type = types.listOf types.str;
    };
  };

  options.users.users = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          gender = {
            description = mkOption { type = types.string; };
            pronouns = mkOption { type = types.separatedString "/"; };
          };
        };
      }
    );
  };
}
