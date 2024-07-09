{ config, pkgs, ... }:

  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  programs = {
    firefox = {
      enable = true;
#      languagePacks = [ "en-US" ];
      profiles.default = {
	bookmarks = [
	  { name = "Home Manager Search"; url="https://home-manager-options.extranix.com/"; }
	  { name = "NixOs Packet Search"; url="https://search.nixos.org/packages"; }
	];
	isDefault = true;
	id = 0;
	name = "default";
        search = {
	  force = true;
	  default = "DuckDuckGo";
	  order = [ "DuckDuckGo" "Google" ];
        };
      };
      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
	  # Foxy Proxy
	  "foxyproxy@eric.h.jung" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-standard/latest.xpi";
	    installation_mode = "force_installed";
	  };
	  # Wappalyzer
	  "wappalyzer@crunchlabz.com" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi";
	    installation_mode = "force_installed";
	  };
	  # Disable Javascript (diable javascript at the push of a button)
	  "{41f9e51d-35e4-4b29-af66-422ff81c8b41}" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/disable-javascript/latest.xpi";
	    installation_mode = "force_installed";
	  };
        };
  
        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = { 
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
	  "browser.aboutConfig.showWarning" = lock-false;
	  "browser.in-content.dark-mode" = lock-true;
	  "browser.cache.disk.enable" = lock-false;
	  "browser.search.defaultenginename" = { Value="DuckDuckGo"; Status="locked"; };
	  "browser.search.order.1" = { Value="DuckDuckGo"; Status="locked"; };
        };
      };
    };
  };
}
