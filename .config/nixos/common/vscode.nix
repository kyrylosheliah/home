{ lib, pkgs, userName, ... }:

{
  users.users.${userName}.packages = with pkgs; [
    vscode
    vscode-fhs
  ];
}
