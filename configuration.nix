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
    hyprpolkitagent 
    wl-clip-persist
    firefox
    nautilus          # or kdePackages.dolphin — dolphin drags in a lot of KDE
    wireplumber
  ];


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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-vaapi-driver libvdpau-va-gl ];
  };
  services.fstrim.enable = true;
  services.tlp.enable = true;

  system.stateVersion = "26.05";
}
