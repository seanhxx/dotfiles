{
  pkgs,
  shares,
  config,
  ezModules,
  osConfig,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  imports =
    lib.debug.traceSeq osConfig.system.nixos.tags (
      if (builtins.elem "gui" osConfig.system.nixos.tags) then
        [
          ezModules.zsh
          ezModules.cli
          ezModules.gui
          ezModules.nvidia
          ezModules.hyprland
        ]
      else
        [ ezModules.tmux ]
    )
    ++ (
      if (builtins.elem "nvidia" osConfig.system.nixos.tags) then
        [
          ezModules.nvidia
        ]
      else
        [ ]
    );

  home = {
    file = {
    };
  };
  programs = {
    git = {
      includes = [
        {
          condition = "gitdir:**/github/**/.git";
          contents = {
            user = {
              email = "seanhxx42@live.com";
              name = "Hu Xiaoxiang";
              signingKey = "1BA08D88F5600ADF";
            };
            commit = {
              gpgSign = false;
            };
          };
        }
      ];
      signing = {
        key = "1BA08D88F5600ADF";
        signByDefault = false;
      };
      extraConfig = {
        user = {
          name = "Hu Xiaoxiang";
          email = "seanhxx42@live.com";
          useConfigOnly = true;
        };
      };
    };
    ssh = {
      matchBlocks = {
        "oracle-001" = {
          hostname = "138.2.104.198";
          user = "seanhxx";
          extraOptions = {
            "ForwardAgent" = "yes";
            "IdentityAgent" = "SSH_AUTH_SOCK";
            # "IdentityAgent" = "/run/user/1002/gnupg/S.gpg-agent.ssh";
          };
        };
      };
    };
  };

}
