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
    shell = pkgs.zsh;
  };

  

  environment.systemPackages = with pkgs; [ 
    git
    neovim
    curl
    kitty
    waybar
    rofi
    mako
    libnotify
    wl-clipboard
    cliphist
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent ];


  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.zsh.enable = true;


  system.stateVersion = "26.05";
}
