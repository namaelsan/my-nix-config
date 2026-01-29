{ ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/namael/.config/sops/age/keys.txt";

  # example stuff you can do with sops-nix
  # sops.secrets."myservice/mysubdir/mysecret" = {
  #   owner = "username"
  # };

  # systemd.services."sometestservice" = {
  #   script = ''
  #       echo "
  #       Hey bro! I'm a service, and imma send this secure password:
  #       $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
  #       located in:
  #       ${config.sops.secrets."myservice/my_subdir/my_secret".path}
  #       to database and hack the mainframe
  #       " > /var/lib/sometestservice/testfile
  #     '';
  #   serviceConfig = {
  #     User = "sometestservice";
  #     WorkingDirectory = "/var/lib/sometestservice";
  #   };
  # };

}