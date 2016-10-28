{ pkgs, ... }:
{

  programs = {

    btop = {
      enable = true;
      settings = {
        graph_symbol = "braille";
        theme_background = "True";
        show_battery = "True";
        selected_battery = "Auto";
      };
    };

    atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1m";
        sync = {
          records = true;
        };
        #sync_address = "https://atuin.inner.autolife-robotics.me";
      };
    };

    ssh = {
      enable = true;
      hashKnownHosts = false;
      controlMaster = "auto";
      controlPersist = "24h";
      compression = true;
    };

    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    git = {
      enable = true;

      lfs = {
        enable = true;
      };
      aliases = {
        trash = "!mkdir -p .trash && git ls-files --others --exclude-standard | xargs mv -f -t .trash";
        pushall = "!git remote | xargs -L1 git push --all";
        rank = "shortlog -s -n --no-merges";
      };
      signing.format = "openpgp";
      difftastic = {
        enable = true;
        background = "dark";
      };

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        # [url "ssh://git@github.com/"]
        # 	insteadOf = https://github.com/
      };

      ignores = [
        "tags"
        "*.DS_Store"
        "*.sw[nop]"
        ".bundle"
        ".env"
        "db/*.sqlite3"
        "log/*.log"
        "rerun.txt"
        "tmp/**/*"
        "workspace.xml"
        ".idea/"
        "node_modules/"
        "target"
        "!target/native/include/*"
        ".meteor/"
        ".vim/"
        "Debug/"
        "compile_commands.json"
        "tests/CMakeCache.txt"
        "**/.ensime*"
        ".metals/"
        ".bloop/"
        "dist"
        "dist-*"
        "cabal-dev"
        "*.o"
        "*.hi"
        "*.chi"
        "*.chs.h"
        "*.dyn_o"
        "*.dyn_hi"
        ".hpc"
        ".hsenv"
        ".cabal-sandbox/"
        "cabal.sandbox.config"
        "*.prof"
        "*.aux"
        "*.hp"
        "*.eventlog"
        ".stack-work/"
        "cabal.project.local"
        "cabal.project.local~"
        ".HTF/"
        ".ghc.environment.*"
        "nohup.out"
        ".attach_bid*"
      ];
    };

    jq = {
      enable = true;
    };

    man = {
      enable = true;
    };
    gpg = {
      enable = true;
      settings = {
        #keyserver = "hkps://keyserver.ubuntu.com";
        fixed-list-mode = true;
        # cert-digest-algo = "SHA256";
        # personal-digest-preferences = "SHA256";
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = false;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        #throw-keyids = true;
      };
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        ale
        denite
        lightline-vim
        nerdtree
        tagbar
      ];
      settings = {
        expandtab = true;
        history = 1000;
        background = "dark";
      };

      extraConfig = ''
        set clipboard=unnamed,unnamedplus  " use the clipboards of vim and win
        set paste               " Paste from a windows or from vim
        set go+=a               " Visual selection automatically copied to the clipboard
      '';
    };

    # navi = { enable = true; };

    zoxide = {
      enable = true;
    };

    starship = {
      enable = true;
      settings = {
        # move the rest of the prompt to the right
        # format = "$character";
        # right_format = "$all";
        # A continuation prompt that displays two filled in arrows
        continuation_prompt = "▶▶";
        kubernetes = {
          disabled = false;
        };
        # directory = {
        #   truncation_length = 20;
        #   truncation_symbol = "…/";
        # };
        status = {
          disabled = false;
        };
        time = {
          disabled = false;
        };
        git_metrics = {
          disabled = false;
        };
        sudo = {
          disabled = false;
        };
      };
    };

    eza = {
      enable = true;
    };

  };
  home = {
    file = {
      ".curlrc" = {
        text = ''
          connect-timeout = 30
          referer = ";auto"
          show-error
          progress-bar
          user-agent = "Mozilla/5.0 Gecko"
        '';
      };
      ".aspell" = {
        text = ''
          lang en_US
        '';
      };
    };
    stateVersion = "25.05";
    keyboard = {
      options = [ "caps:ctrl_modifier" ];
    };
  };
}
# ocng
