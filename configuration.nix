{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];


  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persist/keep/keys.txt";
    secrets = {
      "user/passwordHash" = {
	neededForUsers = true;
      };
      "wifi/ssid" = {};
      "wifi/password" = {};
      github_ssh_key = {
	format = "json";
	sopsFile = ./secrets/ssh_keys.json;
	owner = "tarkthloss";
	mode = "0600";
	path = "/home/tarkthloss/.ssh/github_id_ecdsa";
	group = "tarkthloss";
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  users.users."tarkthloss" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."user/passwordHash".path;
    #initialPassword = "tmp_password";
    extraGroups = [ "networkmanager" "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
	vim
	eza
	viu
	obs-studio
	cmatrix
	openvpn
	cowsay
	ranger
	fastfetch
	ripgrep
	burpsuite
	python312
	python312Packages.pip
	python312Packages.tqdm
	python312Packages.pycryptodome
    ];
  };

  nixpkgs.config.allowUnfree = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

 fileSystems."/persist".neededForBoot = true;
 environment.persistence."/persist/system" = {
   hideMounts = true;
   directories = [
     "/docker"
     "/etc/nixos"
     "/var/log"
     "/var/lib/bluetooth"
     "/var/lib/nixos"
     "/var/lib/systemd/coredump"
     "/etc/NetworkManager/system-connections"
     { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
   ];
   files = [
     "/etc/machine-id"
     { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
   ];
 };

 systemd.tmpfiles.rules = [
  "d /persist/home 1777 root root -"
  "d /persist/home/tarkthloss 0770 tarkthloss users -"
  ];

 programs.fuse.userAllowOther = true;

 services.hardware.bolt.enable = true;

 environment.systemPackages = with pkgs; [
   pkgs.waybar
   (pkgs.waybar.overrideAttrs (oldAttrs: {mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))
   cifs-utils
   nvd
   vim
   zsh
   git
   lsd
   eza
   bat
   ripgrep
   fastfetch
   imlib2Full
   feh
   mplayer
   kmplayer
   nixd
   swww
   kitty
   #rofi
   libnotify
   pkgs.dunst
   pkgs.clipse
   wl-clipboard
   wine-staging
 ];

 systemd.sleep.extraConfig = ''
 	HibernateDelaySec=30m
	SuspendState=mem
 '';

 networking.hostName = "tarkthloss";

 networking.firewall = {
	enable = true;
	allowedTCPPorts = [ 80 443 8000 8080 4242 4444 ];
	allowedUDPPorts = [ 80 443 8000 8080 4242 4444 ];
	interfaces."tun0".allowedUDPPortRanges = [{ from = 1; to = 40000; }];
	interfaces."tun0".allowedTCPPortRanges = [{ from = 1; to = 40000; }];
 };

 services.fstrim.enable = true;

 networking.networkmanager.enable = true;
 
 programs.nh = {
   enable = true;
   clean.enable = true;
   clean.extraArgs = "--keep-since 4d --keep 8";
   flake = "/home/tarkthloss/nixos-config";
 };

 time.timeZone = "Europe/Paris";
 i18n.defaultLocale = "en_US.UTF-8";

 i18n.extraLocaleSettings = {
   LC_ADDRESS = "en_US.UTF-8";
   LC_IDENTIFICATION = "en_US.UTF-8";
   LC_ALL= "en_US.UTF-8";
   LC_MEASUREMENT= "en_US.UTF-8";
   LC_MONETARY= "en_US.UTF-8";
   LC_NAME= "en_US.UTF-8";
   LC_NUMERIC= "en_US.UTF-8";
   LC_PAPER= "en_US.UTF-8";
   LC_TELEPHONE= "en_US.UTF-8";
   LC_TIME= "en_US.UTF-8";
 };

 programs.hyprland = {
   enable = true;
   xwayland.enable = true;
 };

 console.keyMap = "us";

 fonts.packages = with pkgs; [
 	(nerdfonts.override { fonts = [ "FiraCode" ]; })
 ];

 services.printing.enable = true;

 sound.enable = true;
 hardware.pulseaudio.enable = false;
 security.rtkit.enable = true;
 services.pipewire = {
 	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
 };

 programs.zsh.enable = true;

 nix.settings.experimental-features = [ "nix-command" "flakes" ];

 programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
 };

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.daemon.settings = {
    data-root = "/docker";
  };

}
