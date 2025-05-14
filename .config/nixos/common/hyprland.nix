{ pkgs, ... }:

{
  environment.systemPackages = (with pkgs; [
    kitty
  ]);

  programs.hyprland = {
    enable = true;
	withUWSM = true;
  };

  # hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.hyprlock = {};
}
