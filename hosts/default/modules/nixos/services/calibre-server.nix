{ ... }:
{
  services.calibre-server = {
    enable = true;
    port = 8725;

    # Run the service as your own user
    user = "namael";
    group = "users";

    libraries = [ "/home/namael/calibre-library/" ];
    openFirewall = true;
    extraFlags = [ "--enable-local-write" ];
  };
  
    # Tell systemd to let this service see your /home folder
    # Without this, systemd "hides" /home from the service for security
    systemd.services.calibre-server.serviceConfig.ProtectHome = false;

}
