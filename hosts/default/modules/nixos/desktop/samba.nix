{ config, pkgs, ... }:

{
  # Enable Samba with Winbind support
  services.samba = {
    enable = true;
    winbindd.enable = true;   # This starts the winbindd daemon[reference:0]
  };

  # # Optional: Enable WINS resolution in NSS
  # services.samba.nsswins = true; # Allows resolving Windows machine names[reference:1]

  # # Optional: Configure PAM for Winbind authentication
  # security.pam.services = {
  #   # This integrates Winbind with the system's PAM stack
  #   # for services like login, su, etc.
  #   login = { ... };
  #   # You can add more services as needed.
  # };
}