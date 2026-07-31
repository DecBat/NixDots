{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  ##############################################################
  # Boot — legacy BIOS + GRUB on GPT (bios_grub partition)
  ##############################################################
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # Ivy Bridge framebuffer compression saves a little power.
  # Leave PSR off — it causes flicker on this panel generation.
  boot.kernelParams = [ "i915.enable_fbc=1" ];

  # Compresses cold pages in RAM. Worth it on a soldered-RAM machine.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  ##############################################################
  # Locale / time
  ##############################################################
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  ##############################################################
  # Networking
  ##############################################################
  networking.hostName = "x1c";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  ##############################################################
  # Hardware — Ivy Bridge / HD 4000
  ##############################################################
  hardware.enableRedistributableFirmware = true;   # iwlwifi for the 6205
  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver     # i965 — correct for HD 4000, NOT intel-media-driver
      libvdpau-va-gl
    ];
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  # Battery / thermals. Do not also enable power-profiles-daemon.
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      # Uncomment to cap charging and extend pack life. Note this
      # prevents full cycles, which the fuel gauge needs occasionally.
      # START_CHARGE_THRESH_BAT0 = 75;
      # STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };
  services.power-profiles-daemon.enable = false;

  ##############################################################
  # Audio
  ##############################################################
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ##############################################################
  # Desktop — Hyprland on greetd (no display-manager weight)
  ##############################################################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };

  security.polkit.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";      # Electron/Chromium native Wayland
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  ##############################################################
  # Users
  ##############################################################
  users.users.declan = {
    isNormalUser = true;
    description = "Declan";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "wireshark" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  ##############################################################
  # Containers — Podman, Red Hat-flavored
  ##############################################################
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;              # provides `docker` as an alias
    defaultNetwork.settings.dns_enabled = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  ##############################################################
  # Packages
  ##############################################################
  environment.systemPackages = with pkgs; [
    # --- Hyprland session ---
    waybar
    wofi
    foot                    # lightweight terminal; kitty is heavier on HD 4000
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent
    mako                    # notifications
    wl-clipboard
    grim slurp              # screenshots
    brightnessctl           # LVDS backlight keys
    playerctl
    pavucontrol
    networkmanagerapplet

    # --- Core CLI ---
    git
    stow                    # your dotfiles workflow
    neovim
    tmux
    ripgrep fd fzf
    curl wget
    htop btop
    tree unzip jq yq
    file lsof
    man-pages man-pages-posix

    # --- Dev ---
    gcc gnumake
    go gopls
    python3
    python3Packages.pip

    # --- Nix tooling ---
    nixpkgs-fmt
    nix-tree
    nh                      # nicer nixos-rebuild wrapper
  ];

  ##############################################################
  # Nix daemon — tuned for a 2c/4t Ivy Bridge with little RAM
  ##############################################################
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    max-jobs = 2;
    cores = 2;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "26.05";
}
