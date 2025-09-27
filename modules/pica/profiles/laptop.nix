{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.pica.profiles;
in
{
  options.pica.profiles = {
    laptop.enable = mkEnableOption "A laptop";
  };

  config = mkIf cfg.laptop.enable {
    # TODO move these out into purpose-built modules in modules/nixos/system

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:nocaps";
    };

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
