{ ... }:

{
  networking.firewall = {
    # enable = true;
    # specific ports generally not needed if you use the trust rule below,
    # but good to have if the trust rule fails or specific binding is required.
    # allowedUDPPorts = [ <hytale_port> ];
    # allowedTCPPorts = [
    #   80 # nginx
    # ];

    # Trust traffic from ZeroTier interfaces
    extraCommands = ''
      iptables -A INPUT -i zt+ -j ACCEPT
    '';

    # If you are using nftables (NixOS 24.11+ defaults to nftables usually,
    # but check your `networking.nftables.enable` setting):
    # extraInputRules = ''
    #   iifname "zt*" accept
    # '';
  };
}
