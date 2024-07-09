{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
    url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, sops-nix, ...} @ inputs:
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = "/dev/nvme0n1"; })

	nixos-hardware.nixosModules.framework-13-7040-amd

        ./configuration.nix
              
        inputs.home-manager.nixosModules.default

	home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.tarkthloss = import ./nixosModules/home/main.nix;
	  home-manager.extraSpecialArgs = { inherit inputs; };
	}

        inputs.impermanence.nixosModules.impermanence

	#sops-nix.nixosModules.sops
      ];
    };
  };
}
