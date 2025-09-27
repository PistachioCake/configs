{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.pica.profiles;
in
{
  options.pica.profiles = {
    graphical.enable = mkEnableOption "A graphical desktop environment";
  };

  config = mkIf cfg.graphical.enable {
    # ACTUALLY the below config (as of 24-06-14) runs wayland, not X11
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    programs.sway.enable = true;
    # services.displayManager.sessionPackages = [ pkgs.sway ];
    programs.hyprland.enable = true;
  };
}
