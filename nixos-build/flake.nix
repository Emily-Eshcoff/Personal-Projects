{

  description = "Flake Config";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }:

    let

      lib = nixpkgs.lib;
      system = "x86_64-linux";
      hostname = "Artemis";
      username = "emily";

    in {

    nixosConfigurations.${hostname} = lib.nixosSystem {


      inherit system;

	modules = [ 
	  ./configuration.nix
	  ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.${username} = import ./home.nix;
	    }

	  ];

      };

    };

}


