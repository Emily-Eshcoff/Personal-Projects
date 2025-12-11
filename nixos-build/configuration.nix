{ config, lib, pkgs, ... }:


{
  imports =
    [ 

      ./hardware-configuration.nix
    ];

  # Boot

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernel.sysctl = {
    	
	"net.ipv4.ip_forward" = 0;
	"net.ipv6.conf.all.forwarding" = 0; 

	"net.ipv4.conf.all.send_redirects" = 0;
	"net.ipv4.conf.all.accept_redirects" = 0;
	"net.ipv6.conf.all.accept_redirects" = 0;

	"kernel.dmesg_restrict" = 1;
	"ketnel.kptr_restrict" = 2;
	"kernel.unprivileged_bpf_disabeled" = 1;

    };


#   boot.loader.grub.enable = true;
#   boot.loader.grub.device = "/dev/sda";
#   boot.loader.grub.useOSProber = true;

 
  #enable networking
   networking.hostName = "Artemis"; 
    
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
   time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
  

  #allow unfree
	nixpkgs.config.allowUnfree = true;


  # Enable the X11 windowing system.
  services.xserver = {
	enable = true;
  	
  # Enable KDE Plasma Desktop
	
	desktopManager.plasma6.enable = true;
	displayManager.sddm.enable = true;
	
		
  # Configure keymap in X11
	xkb = {
	  layout = "us";
	  variant = ""; 
   	};
};

  services.displayManager.defaultSession = "plasma";

  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sound.
   services.pulseaudio.enable = false;

   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };


   hardware.bluetooth = { 
     enable = true;
     powerOnBoot = true;
     settings = { 
       General = {
         Experimental = true;
       };
     };  
   };
 
 #   services.blueman.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   
   security.sudo.wheelNeedsPassword = true;

   users.users.emily = {
     isNormalUser = true;
     description = "emily";

     extraGroups = [

	#Base
	"wheel"
	"networkmanager"
	"users"
	
	#Hardware control
	"audio"
	"video"
	"input"
	"plugdev"
	
	#Virtualization
	"Libvirtd"
	"kvm"
	"qemu-libvirtd"
	
	#dev
	"docker"
	
	#Remote
	"dialout"

    

	];

    };

    users.users.emergency = {
    	
	isNormalUser = true;
	extraGroups = [ "wheel" ];


    };
    
   # packages = with pkgs; [
       
   #  ];

 # Program Permissions

   programs.firefox.enable = true;
  
   programs.neovim = {
	enable = true;
	defaultEditor = true;
	viAlias = true;
	vimAlias = true;
   };
   
   programs.git = {
     enable = true;
   };

 # Virtualisation & SSH
	
   virtualisation.libvirtd.enable = true;
   virtualisation.docker.enable = true;

   services.openssh =  {
	enable = true;
	settings = {
	   PermitRootLogin = "no";
	   PasswordAuthentication = true;
	   KbdInteractiveAuthentication = true;
	
	   MaxAuthTries = 7;
	   ClientAliveInterval = 300;
	   ClientAliveCountMax =  2;

	   AllowUsers = [ "emily" ];

	};
};


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  
   environment.systemPackages = with pkgs; [

	# Dev

	neovim
	git
	vscode
	docker-compose
	docker


	# Sys

	vim 
	wget
	curl
	htop
	tree
	home-manager
	
	# KDE
	kdePackages.kate
	kdePackages.konsole
	kdePackages.dolphin


	# Code
	
	nil
	nixpkgs-fmt
	repgrep
	fd
	tree-sitter
	zsh
	lua
	python3


	# Remote Tools
	
	remmina
	freerdp
	openssh
	

	# Misc

	
	signal-desktop
	discord
	spotify
	firefox
	protonmail-desktop
	protonvpn-gui




		
	];




  #enables flakes and nix-command
	
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # SUID Wrappers
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # Firewall
	
    networking.firewall = {
	enable = true;
	allowedTCPPorts = [];
	allowedUDPPorts = [];
	

	allowPing = false;
	rejectPackets = true;


	logReversePathDrops = true;
	
    };
   

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
