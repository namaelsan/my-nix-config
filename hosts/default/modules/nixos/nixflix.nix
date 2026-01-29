{ ... }:

{
  sops.secrets = {
    "nixflix" = {
      "sonarr/api_key" = { };
      "sonarr/password" = { };
      "radarr/api_key" = { };
      "radarr/password" = { };
      "prowlarr/api_key" = { };
      "prowlarr/password" = { };
      "jellyfin/alice_password" = { };
      "jellyseerr/api_key" = { };
    };
  };

  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/.state";

    nginx.enable = true;
    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."sonarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."sonarr/password".path;
        };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."radarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."radarr/password".path;
        };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."prowlarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."prowlarr/password".path;
        };
      };
    };

    jellyfin = {
      enable = true;
      users.admin = {
        policy.isAdministrator = true;
        password = {
          _secret = config.sops.secrets."jellyfin/admin_password".path;
        };
      };
    };
  };
}
