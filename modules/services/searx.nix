{ config, lib, pkgs, ... }:

{
  sops.secrets."searx-env" = {
    owner = "searx";
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;

    # UWSGI configuration
    configureUwsgi = true;

    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      http = ":8888";
      chmod-socket = "660";
    };

    # Searx configuration
    settings = {
      # Instance settings
      general = {
        debug = false;
        instance_name = "SearXNG Instance";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      # User interface
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = false;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "auto";
        search_on_category_select = false;
        hotkeys = "vim";
      };

      # Search engine settings
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        favicon_resolver = "duckduckgo";
	formats = [ "html" "json" ];
      };

      # Server configuration
      environmentFile = config.sops.secrets."searx-env".path;
      server = {
        base_url = "https://search.perseuslynx.dev";
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "@SEARX_SECRET@";
        limiter = false;
        public_instance = false;
        image_proxy = true;
        method = "GET";
      };

      # Search engines
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {

        # General search
        "brave".disabled = false;
        "brave".weight = 1.5;
        
        "duckduckgo".disabled = false;
        "duckduckgo".weight = 1.0;
       
        "bing".disabled = false;
        "bing".weight = 0.3;
       
        # Specialist
        "wikipedia".disabled = false;
        "wikipedia".weight = 1.0;
        
        "ddg definitions".disabled = false;
        "ddg definitions".weight = 2.0;
        
        "crowdview".disabled = false;
        "crowdview".weight = 0.5;

        # Images
        "bing images".disabled = false;
        "bing images".weight = 0.5;

        "unsplash".disabled = false;
        "unsplash".weight = 0.8;

        # Videos
        "youtube".disabled = false;
        "youtube".weight = 1.0;

        # Disabled engines
        "1x".disabled = true;
        "artic".disabled = true;
        "brave.images".disabled = true;
        "brave.news".disabled = true;
        "brave.videos".disabled = true;
        "currency".disabled = true;
        "curlie".disabled = true;
        "dailymotion".disabled = true;
        "deviantart".disabled = true;
        "dictzone".disabled = true;
        "duckduckgo images".disabled = true;
        "duckduckgo videos".disabled = true;
        "flickr".disabled = true;
        "google".disabled = true;
        "google images".disabled = true;
        "google news".disabled = true;
        "google play movies".disabled = true;
        "google videos".disabled = true;
        "imgur".disabled = true;
        "invidious".disabled = true;
        "library of congress".disabled = true;
        "lingva".disabled = true;
        "material icons".disabled = true;
        "mojeek".disabled = true;
        "mwmbl".disabled = true;
        "odysee".disabled = true;
        "openverse".disabled = true;
        "peertube".disabled = true;
        "pinterest".disabled = true;
        "piped".disabled = true;
        "qwant".disabled = true;
        "qwant images".disabled = true;
        "qwant videos".disabled = true;
        "rumble".disabled = true;
        "sepiasearch".disabled = true;
        "svgrepo".disabled = true;
        "vimeo".disabled = true;
        "wallhaven".disabled = true;
        "wikibooks".disabled = true;
        "wikicommons.images".disabled = true;
        "wikidata".disabled = true;
        "wikiquote".disabled = true;
        "wikisource".disabled = true;
        "wikispecies".disabled = true;
        "wikiversity".disabled = true;
        "wikivoyage".disabled = true;
        "yacy images".disabled = true;
      };

      # Outgoing requests
      outgoing = {
        request_timeout = 5.0;
        max_request_timeout = 15.0;
        pool_connections = 100;
        pool_maxsize = 15;
        enable_http2 = true;
      };

      # Enabled plugins
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };

  # User management
  users.groups.searx.members = ["nginx"];
}
