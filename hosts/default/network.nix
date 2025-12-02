{ config, pkgs, ... }:

{
  networking.hostName = "nixos-laptop"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
  };

  networking.firewall.allowedTCPPorts = [
    29549
    57621
  ]; # Replace PORT_NUMBER with qBittorrent's port.
  ## doesnt change anything

  # DPI blocker
  zapret = {
    enable = true;
    params = [ "--dpi-desync=fake --dpi-desync-ttl=3" ]; # can depend on the network/isp
  };

  # Enable dnscrypt-proxy
  services.dnscrypt-proxy2.enable = true;

  # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
  services.dnscrypt-proxy2.settings = {
    listen_addresses = [ "127.0.0.1:53" ];
    server_names = [ "cloudflare", "google", "opendns" ]; # or "google", "quad9", etc.
    # anonymize the connection to cloudflare aswell
    routes = {
      "cloudflare" = {
        via = [ "anon-*" ]; # Using anon-* lets the proxy choose from many relays. Manually specifying one distant relay (e.g., anon-sg) could hurt performance.
      };
      "google" = {
        via = [ "anon-*" ];
      };
      "opendns" = {
        via = [ "anon-*" ];
      };
    };
    relay_filters = {
      # Only use relays with low latency and good uptime
      availability = 1; # skip relays with >1% downtime
    };
    cache = true;
    cache_size = 512;  # in MB
  };

  # Prevent DHCP or NetworkManager from overriding your DNS
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  # if you use NetworkManager:
  networking.networkmanager.dns = "none"; # Then manage /etc/resolv.conf yourself

  # Set your system to use localhost for DNS
  networking.nameservers = [ "127.0.0.1" ];
}
