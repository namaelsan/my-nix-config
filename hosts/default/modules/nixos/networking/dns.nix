{ ... }:

{
  # DPI blocker
  services.zapret = {
    enable = true;
    params = [ "--dpi-desync=fake --dpi-desync-ttl=07" ]; # can depend on the network/isp
  };

  services.dnscrypt-proxy = {
    enable = true;

    # Use the public server list built into dnscrypt-proxy
    settings = {
      ipv4_servers = true;
      ipv6_servers = false;

      # Require DNS encryption
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      # enable anonymized DNS relays
      anonymized_dns = {
        skip_incompatible = true;
        routes = [
          {
            server_name = "*";
            via = [ "anon-*" ];
          }
        ];
      };
    };
  };

  # Prevent DHCP or NetworkManager from overriding your DNS
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  # if you use NetworkManager:
  networking.networkmanager.dns = "none"; # Then manage /etc/resolv.conf yourself

  # Set your system to use localhost for DNS
  networking.nameservers = [
    "127.0.0.1"
    "::1"
  ];
}
