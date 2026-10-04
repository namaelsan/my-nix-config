{ config, ... }:

{

  networking.firewall = {
    allowedTCPPorts = [
      80 # makes nginx available to the network
      8096 # jellyfin
    ];
  };

  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/.state";
    mediaUsers = [ "namael" ];

    downloadsDir = "/data/downloads";
    torrentClients.qbittorrent = {
      enable = true;
      serverConfig.Preferences.WebUI = {
        Username = "user";
        Password_PBKDF2 = "@ByteArray(6tCTkDnncVq0BpwMoDGQZg==:d+Kb26NbFMQAS4uESIedarrNbpwO8yVxiigDgvpjyni5oC/4JlJLb6ua0fAJyNinBOnpMSHwu9BFs6T/u6GHxg==)";
      };
      password = {
        _secret = config.sops.secrets."sonarr/password".path;
      };
    };

    downloadarr = {
      enable = true;
      qbittorrent.enable = true;
    };

    # theme = {
    #   enable = true;
    #   name = "overseerr";
    # };

    nginx.enable = true;
    nginx.addHostsEntries = true; # Disable this is you have your own DNS configuration
    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."sonarr/api_key".path;
        };
        hostConfig = {
          username = "user";
          password = {
            _secret = config.sops.secrets."sonarr/password".path;
          };
        };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."radarr/api_key".path;
        };
        hostConfig = {
          username = "user";
          password = {
            _secret = config.sops.secrets."radarr/password".path;
          };
        };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."prowlarr/api_key".path;
        };
        hostConfig = {
          username = "user";
          password = {
            _secret = config.sops.secrets."prowlarr/password".path;
          };
          port = 9696;
        };
        indexers = [
          { name = "TorrentDownload"; }
          { name = "Uindex"; }
          { name = "nekoBT"; }
          { name = "Nyaa.si"; }
          { name = "Knaben"; }
          { name = "The Pirate Bay"; }
          { name = "RuTor"; }
          { name = "Torrent Downloads"; }
          { name = "LimeTorrents"; }
          { name = "Bangumi Moe"; }
          { name = "BitSearch"; }
          # { name = "TorrentGalaxyClone"; }
          # { name = "kickasstorrents.ws"; }
          # { name = "Internet Archive"; }
        ];
      };
    };

    jellyfin = {
      enable = true;
      apiKey = {
        _secret = config.sops.secrets."jellyfin/api_key".path;
      };
      encoding = {
        hardwareAccelerationType = "nvenc";
        enableHardwareEncoding = true;
        enableEnhancedNvdecDecoder = true; # For better NVIDIA decoding
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
          "vp9"
          "av1"
        ]; # RTX 3050 Ti supports these
      };
      network.localNetworkAddresses = [ ];
      users.admin = {
        policy.isAdministrator = true;
        password = {
          _secret = config.sops.secrets."jellyfin/admin_password".path;
        };
      };

    };

    seerr = {
      enable = true;
      apiKey = {
        _secret = config.sops.secrets."jellyseerr/api_key".path;
      };
    };
  };
}
