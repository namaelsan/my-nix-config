{ ... }:

{
  # I2C for brightness control
  hardware.i2c.enable = true;
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660", TAG+="uaccess"
  '';
}
