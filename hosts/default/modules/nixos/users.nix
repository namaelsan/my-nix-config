{ pkgs, ... }:

{
  # Define groups
  users.groups.i2c = { };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.namael = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Namael";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "input"
      "docker"
      "video"
      "i2c" # for brightness control
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Trusted users for nix
  nix.settings.trusted-users = [
    "root"
    "namael"
  ];
}
