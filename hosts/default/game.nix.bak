{ pkgs, ...}:

{
    # Install steam
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;


    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;

    hardware.nvidia = {
        # required
        modesetting.enable = true;

        # dont use the open source drivers
        open = false;

        # laptop has 2 gpu and igpu so prime has to be configured
        prime = {

            sync.enable = true; ## both devices active at the same time

            # integrated
            intelBusId = "PCI:0:2:0";

            # dedicated
            nvidiaBusId = "PCI:1:0:0";

        };
    };
}
