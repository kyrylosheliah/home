{ pkgs, userName, ... }:

{
  # [create beforehand and] set a password with ‘passwd’.
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "input"
      "networkmanager"
    ];
    packages = with pkgs; [
      #tree
    ];
  };
}
