{ config, pkgs, ... }:


{

  home.packages = [ pkgs.atool pkgs.httpie ];


  # Programs
  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = "emily";
    userEmail = "em.eshcoff@pm.me";
    };

   

  home.stateVersion = "25.05";  # Match your NixOS version
}
