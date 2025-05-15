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
    git = {
      sendEmail = {
        smtpuser = "noreply@sobte.me";
      };
      ignores = [
        ".Trash*"
        ".DS_Store"
      ];
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
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General.launchers = [
                  "applications:code.desktop"
                  "applications:cursor.desktop"
                  "applications:dev.zed.Zed.desktop"
                  "applications:org.telegram.desktop.desktop"
                  "applications:google-chrome.desktop"
                  "applications:thunderbird.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.wezfurlong.wezterm.desktop"
                  "applications:vesktop.desktop"
                  "applications:obsidian.desktop"
                  "applications:org.remmina.Remmina.desktop"
                ];
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
      # hotkeys
      hotkeys.commands = {
        "launch-ghostty" = {
          name = "Launch Ghostty";
          key = "Meta+Return";
          command = "ghostty";
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
        "kwinrc"."Wayland"."InputMethod" =
          "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        # spectacle
        "spectaclerc"."Annotations"."annotationToolType" = 6;
        "spectaclerc"."Annotations"."rectangleShadow" = false;
        "spectaclerc"."Annotations"."rectangleStrokeColor" = "255,0,0";
        "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
        "spectaclerc"."ImageSave"."preferredImageFormat" = "WEBP";
        "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
        "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
      };
      # data file
      dataFile = {
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };
    # catppuccin
    catppuccin = {
      global = {
        flavor = "macchiato";
        accent = "sky";
        sddm = {
          background = "${inputs.wallpapers}/wide/default";
          font = "Iosevka";
          fontSize = "10";
          loginBackground = false;
        };
      };
      home = {
        flavor = "macchiato";
        accent = "sky";
        vscode.enable = false;
        zed.enable = false;
      };
    };
    # zed-editor
    zed-editor = {
      extensions = [
        "nix"
        "elixir"
        "deno"
        "zig"
        "lua"
        "kotlin"
        "toml"
        "haskell"
        "latex"
        "env"
        "dockerfile"
        "make"
        "rainbow-csv"
      ];
      userKeymaps = { };
      userSettings = {
        # use direnv
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        ui_font_size = 16;
        buffer_font_size = 16;
        theme = {
          mode = "system";
          light = "Gruvbox Dark Hard";
          dark = "One Dark";
        };
      };
    };
  };
}
