# nmcli device wifi connect <SSID> password <PASS>

{ hostName, ... }:

{

  networking.hostName = hostName;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}
