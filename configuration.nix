{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "x1c";
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  time.timeZone = "America/New_York";

  users.users.declan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  

  environment.systemPackages = with pkgs; [ git neovim curl ];
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  system.stateVersion = "26.05";
}
