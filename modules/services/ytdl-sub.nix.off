{ config, lib, pkgs, ... }:
{
  services.ytdl-sub.instances.main = {
    enable   = true;
    schedule = "daily";
    readWritePaths = [ "/srv/media/harmonics" "/srv/media/pewds" "/srv/data/yt-dlp" ];

    config.presets."ingest-music" = {
      # Music preset, see defaults at: https://ytdl-sub.readthedocs.io/en/latest/config_reference/prebuilt_presets/music.html
      preset   = [ "_music_base" ];
      download = [{ url = "{url}"; include_sibling_metadata = false; }];

      overrides = {
        music_directory  = "/srv/media/harmonics/{subscription_name}";

        track_artist     = "{creator}";
        # Set album artist blank to avoid potential metadata parsing issues
        track_album_artist = "";
        # No point in setting an album if it's not properly recognized
        track_album      = "";
        # Truncated due to previous errors
        track_full_path  = "{ %slice(creator_sanitized, 0, 60) } - { %slice(track_title_sanitized, 0, 80) }.{ext}";
        # Do not save a sidecar album cover
        album_cover_path = "";
        # Download the metadata of X songs at a time, specially useful with new, large playlists
        chunk_max_downloads = 5;
      };

      output_options = {
	# Saves time downloaded
        preserve_mtime = true;
      };

      audio_extract = {
        codec   = "opus";
        # Highest quality
        quality = 0;
      };

      embed_thumbnail  = true;
      square_thumbnail = true;

      ytdl_options = {
        # Temp, make true when initial download ends
        break_on_existing = true;
        # Ignore problematic files
        ignoreerrors = true;
        # Add YouTube cookies to avoid bot captchas
        #cookiefile = "/srv/data/yt-dlp/cookies.txt";
        # Otherwise it tries writing to a directory it has no access to
        cachedir = "/var/lib/yt-dlp/cache";
        # Avoids it trying clients that are only used when no auth is provided
        #extractor_args = {
        #  youtube = {
        #    player_client = [ "tv_downgraded" ];
        #  };
        #};
        # Retry everything X times just in case
        retries = 3;
        fragment_retries = 3;
        extractor_retries = 3;
        # Timeout instead of hanging
        socket_timeout = 30;
        # Avoid trying all tracks if rate-limited by YouTube
        skip_playlist_after_errors = 5;
      };

      # Conservative values that I found don't get me rate limited, probably could get away with shorter waits
      throttle_protection = {
        # Min is not set up in "sleep_per_request_s" due to yt-dlp limitations
        sleep_per_request_s      = { max = 3; };
        sleep_per_download_s     = { min = 15.0; max = 30.0;  };
        sleep_per_subscription_s = { min = 60.0; max = 120.0; };
        subscription_download_probability = 1.0;
        # No max downloads per subscription
      };
    };
    # TODO: Add videos playlist & preset
    subscriptions."ingest-music" = {
      "general" = "https://music.youtube.com/playlist?list=PL_UY8eCGCOx7qTwXKcFfJsQXhaXqZvPgn";
      "classic" = "https://music.youtube.com/playlist?list=PL_UY8eCGCOx7JtjUaAYi62XolmPkSO0o1";
      # Add artists later
    };
  };

  # Ensures that the directories exist
  systemd.tmpfiles.rules = [
    "d /srv/data/yt-dlp              0755 ytdl-sub ytdl-sub -"
    "d /srv/data/yt-dlp/cache        0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics          0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/general  0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/classic  0755 ytdl-sub ytdl-sub -"
  ];

  users.users.ytdl-sub.extraGroups = [ "media-public" ];
}

