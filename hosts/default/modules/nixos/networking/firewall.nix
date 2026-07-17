{ ... }:

{
  networking.firewall = {
    enable = true;
    # for spotify
    allowedTCPPorts = [ 57621 ];
    allowedUDPPorts = [ 5353 1900 ]; # mDNS and SSDP for discovery

    # Trust traffic from ZeroTier interfaces
    extraCommands = ''
      iptables -A INPUT -i zt+ -j ACCEPT
    '';
  };
}
