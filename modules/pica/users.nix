{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.pica = {
    system.users = mkOption {
      type = types.listOf types.str;
    };

    system.mainUser = mkOption {
      type = types.enum config.pica.system.users;
      description = "The main user of this system";
      default = lib.elemAt config.pica.system.users 0;
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
