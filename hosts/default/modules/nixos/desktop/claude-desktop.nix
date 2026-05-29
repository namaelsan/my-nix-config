{ inputs, ... }:

{
  imports = [ inputs.claude-cowork-service.nixosModules.default ];
  services.claude-cowork.enable = true;
}
