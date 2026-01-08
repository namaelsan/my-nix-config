{ ... }:

{
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --log-format internal-json --flake /home/namael/nixos/#default &| nom --json";
    nixdiff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    "cd.." = "cd ..";
    "cd-" = "cd -";
    hotspot = "sudo create_ap wlo1 enp4s0 MyAccesPoint";
    nixupdate = "cd /home/namael/nixos & nix flake update & cd-";
  };
}
