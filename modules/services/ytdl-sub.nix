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
        break_on_existing = false;
        # Ignore problematic files
        ignoreerrors = true;
        # Add YouTube cookies to avoid bot captchas
        #cookiefile = "/srv/data/yt-dlp/cookies.txt";
        # Otherwise it tries writing to a directory it has no access to
        cachedir = "/srv/data/yt-dlp/cache";
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
    # TODO: Manage playlists with nix-sops
    # TODO: Add videos playlist & preset
    subscriptions."ingest-music" = {
      "hype"       = "https://music.youtube.com/playlist?list=PL_UY8eCGCOx6GbttquZ5KId1daZWrYWqC";
      "kroh"       = "https://music.youtube.com/playlist?list=OLAK5uy_n7aORjT0G08wRX2kEeFqp52uRHSpN2c4M";
      "derivakat"  = "https://music.youtube.com/playlist?list=OLAK5uy_lq762tCC4lzug2NnrbQPx9MJXcbG2NhMg";
      "frieren"    = "https://music.youtube.com/playlist?list=OLAK5uy_nU1AWxwD4OB0TdGIALStJA-GhHU3_EPT8";
      "j-hisaishi" = "https://music.youtube.com/playlist?list=OLAK5uy_nQMHvDUZuCx725SBVmyK3i8ypdArHF39M";
      "godfather"  = "https://music.youtube.com/playlist?list=OLAK5uy_lBOT3dgUkt4eJX37rd-k8xELt78K8TSG8";
      "speedrun"   = "https://music.youtube.com/playlist?list=PL_UY8eCGCOx6if7urYOFGk-cOevUz2z0v";
    };
  };

  # Ensures that the directories exist
  systemd.tmpfiles.rules = [
    "d /srv/data/yt-dlp                    0755 ytdl-sub ytdl-sub -"
    "d /srv/data/yt-dlp/cache              0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics                0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/kroh           0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/derivakat      0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/frieren        0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/speedrun       0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/j-hisaishi     0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/godfather      0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/hype           0755 ytdl-sub ytdl-sub -"
    "d /srv/media/harmonics/dlh            0755 ytdl-sub ytdl-sub -"
  ];
}

