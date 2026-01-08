{ ... }:

{
  services.power-profiles-daemon.enable = true; # has to be disabled to use tlp

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     # Set the min/max/turbo frequency for the Intel GPU. Possible values depend on your hardware. See the output of tlp-stat -g for available frequencies.
  #     INTEL_GPU_MIN_FREQ_ON_AC = 500;
  #     INTEL_GPU_MIN_FREQ_ON_BAT = 100;
  #     # INTEL_GPU_MAX_FREQ_ON_AC=0
  #     # INTEL_GPU_MAX_FREQ_ON_BAT=0
  #     # INTEL_GPU_BOOST_FREQ_ON_AC=0
  #     # INTEL_GPU_BOOST_FREQ_ON_BAT=0
  #   };
  # };
}
