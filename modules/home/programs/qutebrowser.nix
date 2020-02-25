{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.qutebrowser;

  percOrInt = with types;
    (either (strMatching "^(0|[1-9]\d?|100)%$") ints.unsigned);

  minusOneZeroOrPositive = with types;  either (ints.between (-1) 0) ints.positive;

  verticalPosition = types.enum [ "top" "bottom"];

  boolAsk = types.enum [ "true" "false" "ask" ];

  autosaveSubmodule = types.submodule {
    options = {
      interval = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Time interval (in milliseconds) between auto-saves of config/cookies/etc.";
      };
      session = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Always restore open sites when qutebrowser is reopened.";
      };
    };
  };

  bindingsSubmodule = types.submodule {
    options = {
      keyMappings = mkOption {
        type = types.attrs;
        default = {};
        description = "Set of keys mapped to other keys.";
      };
    };
  };

  mkStringOption = description:
    mkOption {
      type = types.nullOr types.str;
      default = null;
      inherit description;
    };

  mkColorOption = mkStringOption;
  mkFontOption = mkStringOption;

  mkColorSystemOption = description:
    mkOption {
      type = types.nullOr (types.enum [ "rgb" "hsv" "hsl" "none" ]);
      default = null;
      inherit description;
    };

  mkColorGroupOption = opts: description:
    mkColorGroupOptionWithOptions opts description {};

  mkColorGroupOptionWithOptions = opts: description: extraOpts:
    mkOption {
      type = types.submodule {
        options = (filterAttrs (n: v: elem n opts) {
          bg = mkColorOption "Background color of ${description}.";
          fg = mkColorOption "Foreground color of ${description}.";
          border = mkColorOption "Border color of ${description}.";
        }) // extraOpts;
      };
      default = {};
      description = "Color settings for ${description}.";
    };

  completionColorSubmodule = types.submodule {
    options = {
      fg = mkColorOption "Text color of the completion widget.";
      even = mkColorGroupOption ["bg"] "the completion widget for even rows";
      odd = mkColorGroupOption ["bg"] "the completion widget for odd rows";
      category = mkColorGroupOptionWithOptions ["bg" "fg"] "the completion widget category headers" {
        border = mkOption {
          type = types.submodule {
            options = {
              bottom = mkColorOption "Bottom border color of the completion widget category headers.";
              top = mkColorOption "Top border color of the completion widget category headers.";
            };
          };
          description = "Color settings for the completion widget category header border.";
        };
      };
      item = mkOption {
        type = types.submodule {
          options = {
            selected = mkColorGroupOptionWithOptions ["bg" "fg"] "the selected completion item" {
              border = mkOption {
                type = types.submodule {
                  options = {
                    bottom = mkColorOption "Bottom border color of the selected completion item.";
                    top = mkColorOption "Top border color of the selected completion item.";
                  };
                };
                description = "Color settings for selected completion item border.";
              };
              match = mkColorGroupOption ["fg"] "the matched text in the selected completion item";
            };
          };
        };
        description = "Color settings for completion item.";
      };
      match = mkColorGroupOption ["fg"] "the matched text in the completion";
      scrollbar = mkColorGroupOption ["bg" "fg"] "in the completion view";
    };
  };

  contextmenuColorSubmodule = types.submodule {
    options = {
      menu = mkColorGroupOption ["bg" "fg"] "the context menu";
      selected = mkColorGroupOption ["bg" "fg"] "the context menu’s selected item";
    };
  };

  downloadsColorSubmodule = types.submodule {
    options = {
      bar = mkColorGroupOption ["bg"] "the download bar";
      error = mkColorGroupOption ["bg" "fg"] "downloads with errors";
      start = mkOption {
        type = types.submodule {
          options = {
            bg = mkColorOption "Color gradient start for download backgrounds.";
            fg = mkColorOption "Color gradient start for download text.";
          };
        };
        description = "Color settings for start gradient.";
      };
      stop = mkOption {
        type = types.submodule {
          options = {
            bg = mkColorOption "Color gradient stop for download backgrounds.";
            fg = mkColorOption "Color gradient stop for download text.";
          };
        };
        description = "Color settings for stop gradient.";
      };
      system = mkOption {
        type = types.submodule {
          options = {
            bg = mkColorSystemOption "Color gradient interpolation system for download backgrounds.";
            fg = mkColorSystemOption "Color gradient interpolation system for download text.";
          };
        };
        description = "Color settings for system gradient.";
      };
    };
  };

  hintsColorSubmodule = types.submodule {
    options = {
      bg = mkColorOption "Background color for hints.";
      fg = mkColorOption "Font color for hints.";
      match = mkColorGroupOption ["fg"] "matched part of hints";
    };
  };

  keyhintColorSubmodule = types.submodule {
    options = {
      bg = mkColorOption "Background color of the keyhint widget.";
      fg = mkColorOption "Text color for the keyhint widget.";
      suffix = mkColorGroupOption ["fg"] "keys to complete the current keychain";
    };
  };

  messagesColorSubmodule = types.submodule {
    options = {
      error = mkColorGroupOption ["bg" "fg" "border"] "an error message";
      info = mkColorGroupOption ["bg" "fg" "border"] "an info message";
      warning = mkColorGroupOption ["bg" "fg" "border"] "a warning message";
    };
  };

  promptsColorSubmodule = types.submodule {
    options = {
      bg = mkColorOption "Background color for prompts.";
      fg = mkColorOption "Foreground color for prompts.";
      border = mkColorOption "Border used around UI elements in prompts.";
      selected = mkColorGroupOption ["bg"] "the selected item in filename prompts";
    };
  };

  statusbarColorSubmodule = types.submodule {
    options = {
      caret = mkColorGroupOptionWithOptions ["bg" "fg"] "the statusbar in caret mode" {
        selection = mkColorGroupOption ["bg" "fg"] "the statusbar in caret mode with a selection";
      };
      command = mkColorGroupOptionWithOptions ["bg" "fg"] "the statusbar in command mode" {
        private = mkColorGroupOption ["bg" "fg"] "the statusbar in private browsing + command mode";
      };
      insert = mkColorGroupOption ["bg" "fg"] "the statusbar in insert mode";
      normal = mkColorGroupOption ["bg" "fg"] "the statusbar";
      passthrough = mkColorGroupOption ["bg" "fg"] "the statusbar in passthrough mode";
      private = mkColorGroupOption ["bg" "fg"] "the statusbar in private browsing mode";
      progress = mkColorGroupOption ["bg"] "the progress bar";
      url = mkColorGroupOptionWithOptions ["fg"] "the URL in the statusbar" {
        error = mkColorGroupOption ["fg"] "the URL in the statusbar on error";
        hover = mkColorGroupOption ["fg"] "the URL in the statusbar for hovered links";
        success = mkOption {
          type = types.submodule {
            options = {
              http = mkColorGroupOption ["fg"] "the URL in the statusbar on successful load (http)";
              https = mkColorGroupOption ["fg"] "the URL in the statusbar on successful load (https)";
            };
          };
          default = {};
          description = "Color settings for the URL in the statusbar on successful load.";
        };
        warn = mkColorGroupOption ["fg"] "the URL in the statusbar when there’s a warning";
      };
    };
  };

  tabsColorSubmodule = types.submodule {
    options = {
      bar = mkColorGroupOption ["bg"] "the tab bar";
      even = mkColorGroupOption ["bg" "fg"] "unselected even tabs";
      odd = mkColorGroupOption ["bg" "fg"] "unselected odd tabs";
      indicator = mkOption {
        type = types.submodule {
          options = {
            error = mkColorOption "Color for the tab indicator on errors.";
            start = mkColorOption "Color gradient start for the tab indicator.";
            stop = mkColorOption "Color gradient end for the tab indicator.";
            system = mkColorSystemOption "Color gradient interpolation system for the tab indicator.";
          };
        };
        default = {};
        description = "Color settings for the tab indicator.";
      };
      pinned = mkOption {
        type = types.submodule {
          options = {
            even = mkColorGroupOption ["bg" "fg"] "pinned unselected even tabs";
            odd = mkColorGroupOption ["bg" "fg"] "pinned unselected odd tabs";
            selected = mkOption {
              type = types.submodule {
                options = {
                  even = mkColorGroupOption ["bg" "fg"] "pinned selected even tabs";
                  odd = mkColorGroupOption ["bg" "fg"] "pinned selected odd tabs";
                };
              };
              default = {};
              description = "Color settings for pinned selected tabs.";
            };
          };
        };
        default = {};
        description = "Color settings for pinned tabs.";
      };
      selected = mkOption {
        type = types.submodule {
          options = {
            even = mkColorGroupOption ["bg" "fg"] "selected even tabs";
            odd = mkColorGroupOption ["bg" "fg"] "selected odd tabs";
          };
        };
        default = {};
        description = "Color settings for selected tabs.";
      };
    };
  };

  webpageColorSubmodule = types.submodule {
    options = {
      bg = mkColorOption "Background color for webpages if unset (or empty to use the theme’s color).";
      prefersColorSchemeDark = mkOption {
        type = types.nullOr types.bool;
        default = null;
        example = true;
        description = "Force prefers-color-scheme: dark colors for websites.";
      };
    };
  };

  colorsSubmodule = types.submodule {
    options = {
      completion = mkOption {
        type = types.nullOr completionColorSubmodule;
        default = null;
        description = "Completion color settings.";
      };
      contextmenu = mkOption {
        type = types.nullOr contextmenuColorSubmodule;
        default = null;
        description = "Context menu color settings.";
      };
      downloads = mkOption {
        type = types.nullOr downloadsColorSubmodule;
        default = null;
        description = "Downloads color settings.";
      };
      hints = mkOption {
        type = types.nullOr hintsColorSubmodule;
        default = null;
        description = "Hints color settings.";
      };
      keyhint = mkOption {
        type = types.nullOr keyhintColorSubmodule;
        default = null;
        description = "Keyhint color settings.";
      };
      messages = mkOption {
        type = types.nullOr messagesColorSubmodule;
        default = null;
        description = "Message color settings.";
      };
      prompts = mkOption {
        type = types.nullOr promptsColorSubmodule;
        default = null;
        description = "Prompt color settings.";
      };
      statusbar = mkOption {
        type = types.nullOr statusbarColorSubmodule;
        default = null;
        description = "Statusbar color settings.";
      };
      tabs = mkOption {
        type = types.nullOr tabsColorSubmodule;
        default = null;
        description = "Tab color settings.";
      };
      webpage = mkOption {
        type = types.nullOr webpageColorSubmodule;
        default = null;
        description = "Web page color settings.";
      };
    };
  };

  completionSubmodule = types.submodule {
    options = {
      cmdHistoryMaxItems = mkOption {
        type = types.nullOr minusOneZeroOrPositive;
        default = null;
        description = "Maximum number of pages to hold in the global memory page cache.";
      };
      delay = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Delay (in milliseconds) before updating completions after typing a character.";
      };
      height = mkOption {
        type = types.nullOr percOrInt;
        default = null;
        description = "Height (in pixels or as percentage of the window) of the completion.";
      };
      minChars = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Minimum amount of characters needed to update completions.";
      };
      openCategories = mkOption {
        type = with types; nullOr (listOf (enum [
          "searchengines"
          "quickmarks"
          "bookmarks"
          "history"
        ]));
        default = null;
        description = "Which categories to show (in which order) in the :open completion.";
      };
      quick = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Move on to the next part when there’s only one possible completion left.";
      };
      scrollbar = mkOption {
        type = types.submodule {
          options = {
            padding = mkOption {
              type = types.nullOr types.ints.unsigned;
              default = null;
              description = "Padding (in pixels) of the scrollbar handle in the completion window.";
            };
            width = mkOption {
              type = types.nullOr types.ints.unsigned;
              default = null;
              description = "Width (in pixels) of the scrollbar in the completion window.";
            };
          };
        };
        default = {};
        description = "Completion scrollbar settings.";
      };
      show = mkOption {
        type = types.nullOr (types.enum [ "always" "auto" "never" ]);
        default = null;
        description = "When to show the autocompletion window.";
      };
      shrink = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Shrink the completion to be smaller than the configured size if there are no scrollbars.";
      };
      timestampFormat = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Format of timestamps (e.g. for the history completion).";
        example = "%Y-%m-%d";
      };
      useBestMatch = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Execute the best-matching command on a partial match.";
      };
      webHistory = mkOption {
        type = types.submodule {
          options = {
            exclude = mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              description = "A list of patterns which should not be shown in the history.";
            };
            maxItems = mkOption {
              type = types.nullOr minusOneZeroOrPositive;
              default = null;
              description = ''
                Number of URLs to show in the web history.
                0: no history
                -1: unlimited
              '';
            };
          };
        };
        default = {};
        description = "Completion scrollbar settings.";
      };
    };
  };

  contentSubmodule = types.submodule {
    options = {
      autoplay = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Automatically start playing <video> elements.";
      };
      cache = mkOption {
        type = types.submodule {
          options = {
            appcache = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Enable support for the HTML 5 web application cache feature.";
            };
            maximumPages = mkOption {
              type = types.nullOr types.ints.unsigned;
              default = null;
              description = "Maximum number of pages to hold in the global memory page cache.";
            };
            size = mkOption {
              type = types.nullOr (types.ints.between 0 2147483647);
              default = null;
              description = "Size (in bytes) of the HTTP network cache. Null to use the default value.";
            };
          };
        };
        default = {};
        description = "Content cache settings.";
      };
      canvasReading = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Allow websites to read canvas elements.";
      };
      cookies = mkOption {
        type = types.submodule {
          options = {
            accept = mkOption {
              type = types.nullOr (types.enum [
                "all"
                "no-3rdparty"
                "no-unknown-3rdparty"
                "never"
              ]);
              default = null;
              description = "Which cookies to accept.";
            };
            store = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Store cookies.";
            };
          };
        };
        default = {};
        description = "Content cookie settings.";
      };
      defaultEncoding = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default encoding to use for websites.";
        example = "utf-8";
      };
      desktopCapture = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to share screen content.";
      };
      dnsPrefetch = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Try to pre-fetch DNS entries to speed up browsing.";
      };
      frameFlattening = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Expand each subframe to its contents.";
      };
      geolocation = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to request geolocations.";
      };
      headers = mkOption {
        type = types.submodule {
          options = {
            acceptLanguage = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Value to send in the Accept-Language header.";
            };
            custom = mkOption {
              type = with types; nullOr (attrsOf str);
              default = null;
              description = "Custom headers for qutebrowser HTTP requests.";
            };
            doNotTrack = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Value to send in the DNT header.";
            };
            referer = mkOption {
              type = types.nullOr (types.enum [ "always" "never" "same-domain" ]);
              default = null;
              description = "When to send the Referer header.";
            };
            userAgent = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "User agent to send.";
            };
          };
        };
        default = {};
        description = "Content headers settings.";
      };
      hostBlocking = mkOption {
        type = types.submodule {
          options = {
            enabled = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Enable host blocking.";
            };
            lists = mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              description = "List of URLs of lists which contain hosts to block.";
            };
            whitelist = mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              description = "A list of patterns that should always be loaded, despite being ad-blocked.";
            };
          };
        };
        default = {};
        description = "Content host blocking settings.";
      };
      hyperlinkAuditing = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable hyperlink auditing (<a ping>).";
      };
      images = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Load images automatically in web pages.";
      };
      javascript = mkOption {
        type = types.submodule {
          options = {
            enabled = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Enable JavaScript.";
            };
            alert = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Show javascript alerts.";
            };
            canAccessClipboard = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Allow JavaScript to read from or write to the clipboard.";
            };
            canCloseTabs = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Allow JavaScript to close tabs.";
            };
            canOpenTabsAutomatically = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Allow JavaScript to open new tabs without user interaction.";
            };
            log = mkOption {
              type = with types; nullOr (attrsOf (enum [
                "none"
                "debug"
                "info"
                "warning"
                "error"
              ]));
              default = null;
              description = "Log levels to use for JavaScript console logging messages.";
            };
            modalDialog = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Use the standard JavaScript modal dialog for alert() and confirm().";
            };
            prompt = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Show javascript prompts.";
            };
          };
        };
        default = {};
        description = "Content JavaScript settings.";
      };
      localContentCanAccessFileUrls = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Allow locally loaded documents to access other local URLs.";
      };
      localContentCanAccessRemoteUrls = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Allow locally loaded documents to access remote URLs.";
      };
      localStorage = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable support for HTML 5 local storage and Web SQL.";
      };
      mediaCapture = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to record audio/video.";
      };
      mouseLock = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to lock your mouse pointer.";
      };
      mute = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Automatically mute tabs.";
      };
      netrcFile = mkOption {
        type = with types; nullOr (either str path);
        default = null;
        description = "Netrc-file for HTTP authentication.";
      };
      notifications = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to show notifications.";
      };
      pdfjs = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Allow pdf.js to view PDF files in the browser.";
      };
      persistentStorage = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to request persistent storage quota via navigator.webkitPersistentStorage.requestQuota.";
      };
      plugins = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable plugins in Web pages.";
      };
      printElementBackgrounds = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Draw the background color and images also when the page is printed.";
      };
      privateBrowsing = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Open new windows in private browsing mode which does not record visited pages.";
      };
      proxy = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Proxy to use.";
      };
      proxyDnsRequests = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Send DNS requests over the configured proxy.";
      };
      registerProtocolHandler = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Allow websites to register protocol handlers via navigator.registerProtocolHandler.";
      };
      siteSpecificQuirks = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable quirks (such as faked user agent headers) needed to get specific sites to work properly.";
      };
      sslStrict = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Validate SSL handshakes.";
      };
      userStylesheets = mkOption {
        type = with types; nullOr
          (either str (either (listOf str)
            (either path (listOf path))));
        default = null;
        description = "List of user stylesheet filenames to use.";
      };
      webgl = mkOption {
        type = types.nullOr boolAsk;
        default = null;
        description = "Enable WebGL.";
      };
      webrtcIpHandlingPolicy = mkOption {
        type = types.nullOr (types.enum [
          "all-interfaces"
          "default-public-and-private-interfaces"
          "default-public-interface-only"
          "disable-non-proxied-udp"
        ]);
        default = null;
        description = "Which interfaces to expose via WebRTC.";
      };
      windowedFullscreen = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Limit fullscreen to the browser window (does not expand to fill the screen).";
      };
      xssAuditing = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Monitor load requests for cross-site scripting attempts.";
      };
    };
  };

  downloadsSubmodule = types.submodule {
    options = {
      location = mkOption {
        type = types.submodule {
          options = {
            directory = mkOption {
              type = with types; nullOr (either path str);
              default = null;
              description = "Directory to save downloads to.";
            };
            prompt = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Prompt the user for the download location.";
            };
            remember = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Remember the last used download directory.";
            };
            suggestion = mkOption {
              type = types.nullOr (types.enum [ "path" "filename" "both" ]);
              default = null;
              description = "What to display in the download filename input.";
            };
          };
        };
        default = {};
        description = "Download location settings.";
      };
      openDispatcher = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default program used to open downloads.";
      };
      position = mkOption {
        type = types.nullOr verticalPosition;
        default = null;
        description = "Where to show the downloaded files.";
      };
      removeFinished = mkOption {
        type = types.nullOr minusOneZeroOrPositive;
        default = null;
        description = "Duration (in milliseconds) to wait before removing finished downloads.";
      };
    };
  };

  editorSubmodule = types.submodule {
    options = {
      command = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
        description = "Editor (and arguments) to use for the open-editor command.";
      };
      encoding = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Encoding to use for the editor.";
      };
    };
  };

  fontsSubmodule = types.submodule {
    options = {
      completion = mkOption {
        type = types.submodule {
          options = {
            category = mkFontOption "Font used in the completion categories.";
            entry = mkFontOption "Font used in the completion widget.";
          };
        };
        default = {};
        description = "Completion font settings.";
      };
      contextmenu = mkFontOption "Font used for the context menu. If set to null, the Qt default is used.";
      debugConsole = mkFontOption "Font used for the debugging console.";
      defaultFamily = mkOption {
        type = with types; nullOr (either str (listOf str));
        default = null;
        description = "Default font families to use. Whenever "default_family" is used in a font setting, it’s replaced with the fonts listed here. If set to an empty value, a system-specific monospace default is used.";
      };
      defaultSize = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default font size to use. Whenever "default_size" is used in a font setting, it’s replaced with the size listed here. Valid values are either a float value with a "pt" suffix, or an integer value with a "px" suffix.";
      };
      downloads = mkFontOption "Font used for the downloadbar.";
      hints = mkFontOption "Font used for the hints.";
      keyhint = mkFontOption "Font used in the keyhint widget.";
      messages = mkOption {
        type = types.submodule {
          options = {
            error = mkFontOption "Font used for error messages.";
            info = mkFontOption "Font used for error messages.";
            warning = mkFontOption "Font used for warning messages.";
          };
        };
        default = {};
        description = "Message font settings.";
      };
      prompts = mkFontOption "Font used for prompts.";
      statusbar = mkFontOption "Font used in the statusbar.";
      tabs = mkFontOption "Font used in the tab bar.";
      web = mkOption {
        type = types.submodule {
          options = {
            family = mkOption {
              type = types.submodule {
                options = {
                  cursive = mkFontOption "Font family for cursive fonts.";
                  fantasy = mkFontOption "Font family for fantasy fonts.";
                  fixed = mkFontOption "Font family for fixed fonts.";
                  sansSerif = mkFontOption "Font family for sans-serif fonts.";
                  serif = mkFontOption "Font family for serif fonts.";
                  standard = mkFontOption "Font family for standard fonts.";
                };
              };
              default = {};
              description = "Web font family settings.";
            };
            size = mkOption {
              type = types.submodule {
                options = {
                  default = mkOption {
                    type = types.nullOr types.ints.unsigned;
                    default = null;
                    description = "Default font size (in pixels) for regular text.";
                  };
                  defaultFixed = mkOption {
                    type = types.nullOr types.ints.unsigned;
                    default = null;
                    description = "Default font size (in pixels) for fixed-pitch text.";
                  };
                  minimum = mkOption {
                    type = types.nullOr types.ints.unsigned;
                    default = null;
                    description = "Hard minimum font size (in pixels).";
                  };
                  minimumLogical = mkOption {
                    type = types.nullOr types.ints.unsigned;
                    default = null;
                    description = "Minimum logical font size (in pixels) that is applied when zooming out.";
                  };
                };
              };
              default = {};
              description = "Web font size settings.";
            };
          };
        };
        default = {};
        description = "Web font settings.";
      };
    };
  };

  hintsSubmodule = types.submodule {
    options = {
      autoFollow = mkOption {
        type = types.nullOr (types.enum [ "always" "unique-match" "full-match" "never" ]);
        default = null;
        description = "When a hint can be automatically followed without pressing Enter.";
      };
      autoFollowTimeout = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Duration (in milliseconds) to ignore normal-mode key bindings after a successful auto-follow.";
      };
      border = mkStringOption "CSS border value for hints.";
      chars = mkStringOption "Characters used for hint strings.";
      dictionary = mkOption {
        type = with types; nullOr (either path str);
        default = null;
        description = "Dictionary file to be used by the word hints.";
      };
      findImplementation = mkOption {
        type = types.nullOr (types.enum [ "javascript" "python" ]);
        default = null;
        description = "Which implementation to use to find elements to hint.";
      };
      hideUnmatchedRapidHints = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Hide unmatched hints in rapid mode.";
      };
      leaveOnLoad = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Leave hint mode when starting a new page load.";
      };
      minChars = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Minimum number of characters used for hint strings.";
      };
      mode = mkOption {
        type = types.nullOr (types.enum [ "number" "letter" "word" ]);
        default = null;
        description = "Mode to use for hints.";
      };
      nextRegexes = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
        description = "List of regular expressions to use for next links.";
      };
      prevRegexes = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
        description = "List of regular expressions to use for prev links.";
      };
      scatter = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Scatter hint key chains (like Vimium) or not (like dwb). Ignored for number hints.";
      };
      selectors = mkOption {
        type = with types; nullOr (attrsOf (listOf str));
        default = null;
        description = "CSS selectors used to determine which elements on a page should have hints.";
      };
      uppercase = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Make characters in hint strings uppercase.";
      };
    };
  };

  camelCaseToSnakeCase = replaceStrings upperChars (map (s: "_${s}") lowerChars);

  flattenModuleAttrs = let
    recurse = path: value:
      # Recurse and gather path as long as attribute set is a module.
      if isAttrs value && hasAttrByPath [ "_module" ] value then
        mapAttrsToList
          (n: v: recurse ([n] ++ path) v)
          (filterAttrs (n: v: n != "_module") value)
      else {
        ${concatStringsSep "." (reverseList path)} = value;
      };
  in attrs: foldl recursiveUpdate { } (flatten (recurse [ ] attrs));

  filterSettings = attrs:
    filterAttrs (n: v: n != "_module" && v != null) attrs;

  coerceValue = let
    toDictLines = attrs:
      mapAttrsToList
        (n: v: "    '${n}': ${recurse v}")
        (filterSettings attrs);
    recurse = value:
      if isBool value then (if value then "True" else "False")
      else if isString value then "'${value}'"
      else if isList value then "[${concatStringsSep ", " (map (s: recurse s) value)}]"
      else if isAttrs value then "{\n${concatStringsSep ",\n" (toDictLines value)}\n}"
      else toString value;
  in recurse;

  toSetting = name: value:
    optionalString
      (value != null)
      "c.${camelCaseToSnakeCase name} = ${coerceValue value}";

  toSettings = name: attrs:
    let
      flatAttrs = flattenModuleAttrs attrs;
      toSettings' = generators.toKeyValue {
        mkKeyValue = key: value: toSetting "${name}.${key}" value;
      };
    in optionalString
      (attrs != null)
      (toSettings' (filterSettings flatAttrs));
in {
  options.programs.qutebrowser = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable the qutebrowser web browser.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qutebrowser;
      defaultText = literalExample "pkgs.qutebrowser";
      description = ''
        The qutebrowser derivation to use.
      '';
    };

    aliases = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Set of aliases for qutebrowser.
      '';
    };

    autoSave = mkOption {
      type = types.nullOr autosaveSubmodule;
      default = null;
      description = "Auto save settings.";
    };

    backend = mkOption {
      type = types.nullOr (types.enum [ "webengine" "webkit" ]);
      default = null;
      description = "Backend to use to display websites.";
    };

    bindings = mkOption {
      type = types.nullOr bindingsSubmodule;
      default = null;
      description = "Key binding settings.";
    };

    colors = mkOption {
      type = types.nullOr colorsSubmodule;
      default = null;
      description = "Color settings.";
    };

    completion = mkOption {
      type = types.nullOr completionSubmodule;
      default = null;
      description = "Completion settings.";
    };

    confirmQuit = mkOption {
      type = types.nullOr (types.enum [ "always" "multiple-tabs" "downloads" "never" ]);
      default = null;
      description = "Require a confirmation before quitting the application.";
    };

    content = mkOption {
      type = types.nullOr contentSubmodule;
      default = null;
      description = "Content settings.";
    };

    downloads = mkOption {
      type = types.nullOr downloadsSubmodule;
      default = null;
      description = "Downloads settings.";
    };

    editor = mkOption {
      type = types.nullOr editorSubmodule;
      default = null;
      description = "Editor settings.";
    };

    fonts = mkOption {
      type = types.nullOr fontsSubmodule;
      default = null;
      description = "Fonts settings.";
    };

    hints = mkOption {
      type = types.nullOr hintsSubmodule;
      default = null;
      description = "Hints settings.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra lines added to the config.py configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.qutebrowser ];

    xdg.configFile."qutebrowser/config.py".text =
      ''
        # Generated by Home Manager
        ${toSetting "aliases" cfg.aliases}
        ${toSettings "auto_save" cfg.autoSave}
        ${toSetting "backend" cfg.backend}
        ${toSettings "bindings" cfg.bindings}
        ${toSettings "colors" cfg.colors}
        ${toSettings "completion" cfg.completion}
        ${toSetting "confirm_quit" cfg.confirmQuit}
        ${toSettings "content" cfg.content}
        ${toSettings "downloads" cfg.downloads}
        ${toSettings "editor" cfg.editor}
        ${toSettings "fonts" cfg.fonts}
        ${toSettings "hints" cfg.hints}
        ${cfg.extraConfig}
      '';
  };
}
