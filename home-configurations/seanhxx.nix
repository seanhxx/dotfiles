{
  pkgs,
  ezModules,
  osConfig,
  lib,
  ...
}:
{
  imports =
    lib.debug.traceSeq osConfig.system.nixos.tags (
      if (builtins.elem "gui" osConfig.system.nixos.tags) then
        [
          ezModules.zsh
          ezModules.cli
          ezModules.gui
          # ezModules.nvidia
          ezModules.hyprland
        ]
      else
        [ ezModules.tmux ]
    )
    ++ (
      if (builtins.elem "nvidia" osConfig.system.nixos.tags) then
        [
          # ezModules.nvidia
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
          condition = "gitdir:**/github-private/**/.git";
          contents = {
            user = {
              email = "seanhxx42@live.com";
              name = "Hu Xiaoxiang";
              signingKey = "57B83C0B2B9C5E3F";
            };
            commit = {
              gpgSign = true;
            };
          };
        }
        {
          condition = "gitdir:**/dotfiles/.git";
          contents = {
            user = {
              email = "seanhxx42@live.com";
              name = "Hu Xiaoxiang";
              signingKey = "57B83C0B2B9C5E3F";
            };
            commit = {
              gpgSign = true;
            };
          };
        }
        {
          condition = "gitdir:**/github-htx/**/.git";
          contents = {
            user = {
              email = "sean.hu@htx-inc.com";
              name = "Hu Xiaoxiang";
              signingKey = "5D60F2018C745B5E";
            };
            commit = {
              gpgSign = false;
            };
          };
        }
      ];
      signing = {
        key = "";
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
          hostname = "213.35.107.62";
          user = "seanhxx";
          extraOptions = {
            "ForwardAgent" = "yes";
            "IdentityAgent" = "SSH_AUTH_SOCK";
            # "IdentityAgent" = "/run/user/1002/gnupg/S.gpg-agent.ssh";
            "RemoteForward" = "/run/user/1002/gnupg/S.gpg-agent /run/user/1002/gnupg/S.gpg-agent.extra";
          };
        };
      };
    };
  };

}
