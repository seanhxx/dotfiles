{
  inputs,
  ezModules,
  lib,
  ...
}:
{
  imports =
    lib.attrValues {
      inherit (ezModules)
        # alacritty
        zsh-minimal
        cli-minimal
        ;
    }
    ++ [
      inputs.impermanence.nixosModules.home-manager.impermanence
      inputs.sops-nix.homeManagerModules.sops
    ];

  sops = {
    gnupg = {
      home = "~/.gnupg";
    };
    defaultSopsFile = ../secrets/common.yaml;
  };

  programs.home-manager.enable = true;
}
