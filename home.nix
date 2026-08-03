{ config, pkgs, ... }:
{
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}