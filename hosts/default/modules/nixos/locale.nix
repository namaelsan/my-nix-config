{ ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "tr_TR.UTF-8/UTF-8"
  ];

  # Configure console keymap
  console.keyMap = "trq";

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "tr";
  };

  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };
}
