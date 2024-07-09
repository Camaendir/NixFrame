{ pkgs, inputs, config, lib, ... }:
{ 
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nixvim.homeManagerModules.nixvim
    ./vscode.nix
    ./shell.nix
    ./hyprland.nix
    ./firefox.nix
    ./nixvim.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.persistence."/persist/home/tarkthloss" = {
    directories = [
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      "hackthebox"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
    ];
    allowOther = true;
  };

  home.username = "tarkthloss";
  home.homeDirectory = "/home/tarkthloss";

  home.packages = [
  ];

  programs.firefox.enable = true;

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.git.enable = true;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;
}
