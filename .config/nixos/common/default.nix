{ pkgs, stateVersion, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./console.nix
    ./firefox.nix
    ./hyprland.nix
    ./locale.nix
    ./network.nix
    ./power.nix
    ./time.nix
    ./touchpad.nix
    ./user.nix
    ./vscode.nix
  ];

  environment.systemPackages = with pkgs; [
    # the Nano editor is installed by default
    #pkgs.home-manager
    wget
    neovim
    git
    zig
  ];

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  #system.stateVersion = stateVersion; # Did you read the comment?
  system = { inherit stateVersion; }; # Did you read the comment?
}
