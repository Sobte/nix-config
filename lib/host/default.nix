{ inputs, ... }:
{
  # default vars
  host = {
    name = "meow";
    realName = "sobte";
    email = {
      address = "i@sobte.me";
      smtp.host = "pixel.mxrouting.net";
      imap.host = "pixel.mxrouting.net";
    };
    sendEmail = {
      smtpuser = "noreply@sobte.me";
    };
    samba.client = {
      # home nas config
      home-nas = {
        hostUrl = "home.nas.oop.icu";
        binds = {
          "home-resources" = { };
          "home-shared" = { };
        };
      };
    };
    gpg = {
      signKey = "612A2672CCEDF205";
      encryptKey = "FEE8B702D71CAEB0";
    };
    # Because these keys can access all computers, 
    # they are generated using fido2 and require a passphrase.
    # and it is not movable
    authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBCAtuUN2HxfkpZ5VKpZ3ZUrPT27Hj07WfJNGQXvnZ2626eLq1RR/cJfvoWbpKwPdAtbt1LATP+5D1XEfcFJGMjWKCKEWZIQjQ/Yes6dl65yHfwRemhlA0ERupZIkSaWZSg=="
    ];
    # using toml here to benefit from schema & lsp
    starship.settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
    wezterm.extraConfig = builtins.readFile ./config/wezterm.lua;
    # kde plasma settings
    # https://nix-community.github.io/plasma-manager/options.xhtml
    desktop.plasma = {
      # focus
      overrideConfig = true;
      # input
      input.keyboard = {
        numlockOnStartup = "on";
        layouts = [
          {
            layout = "us";
          }
        ];
      };
      # power management
      powerdevil = {
        AC = {
          autoSuspend.action = "nothing";
          powerButtonAction = "shutDown";
        };
      };
      # lockscreen
      kscreenlocker = {
        autoLock = true;
        timeout = 10;
        lockOnResume = true;
        appearance = {
          wallpaperSlideShow = {
            interval = 300;
            path = "${inputs.wallpapers}/wide";
          };
        };
      };
      # workspace
      workspace = {
        clickItemTo = "select";
        wallpaperSlideShow = {
          interval = 300;
          path = "${inputs.wallpapers}/wide";
        };
      };
      # kwin
      kwin = {
        effects = {
          blur.enable = true;
        };
        virtualDesktops = {
          names = [
            "Desktop 1"
            "Desktop 2"
          ];
          rows = 1;
        };
      };
      # spectacle
      spectacle.shortcuts = {
        captureRectangularRegion = "F6";
      };
      # panels
      panels = [
        {
          height = 32;
          location = "bottom";
        }
      ];
      # hotkeys
      hotkeys.commands = {
        "launch-wezterm" = {
          name = "Launch WezTerm";
          key = "Meta+Return";
          command = "wezterm";
        };
      };
      # fonts
      fonts = {
        general = {
          family = "Source Han Sans";
          pointSize = 10;
          styleStrategy.antialiasing = "prefer";
        };
        fixedWidth = {
          family = "Iosevka";
          pointSize = 10;
          styleStrategy.antialiasing = "prefer";
        };
        small = {
          family = "Source Han Sans";
          pointSize = 8;
          styleStrategy.antialiasing = "prefer";
        };
        toolbar = {
          family = "Source Han Sans";
          pointSize = 10;
          styleStrategy.antialiasing = "prefer";
        };
        menu = {
          family = "Source Han Sans";
          pointSize = 10;
          styleStrategy.antialiasing = "prefer";
        };
        windowTitle = {
          family = "DejaVu Math TeX Gyre";
          pointSize = 10;
          styleStrategy.antialiasing = "prefer";
        };
      };
      # other config
      configFile = {
        # use fcitx5 as input method
        "kwinrc"."Wayland"."InputMethod" = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
      };
      # data file
      dataFile = {
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };
  };
}
