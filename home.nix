{ config, pkgs, lib, ... }:

let
  dots = "${config.home.homeDirectory}/NixDots/config";
  link = name: {
    inherit name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dots}/${name}";
  };
in
{
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # ── Dotfiles: symlinked out of the repo, edits apply without a rebuild ──
  xdg.configFile = lib.listToAttrs (map link [
    "hypr"
    "kitty"
    "waybar"
  ]);

  # ── Things better declared than dotfiled ──
  programs.git = {
    enable = true;
    userName = "Declan";
    userEmail = "you@example.com";
  };

  # ── User-scoped packages ──
  home.packages = with pkgs; [
    fastfetch
    imv
    mpv
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    shellAliases = { nrs = "..."; };
  };
}