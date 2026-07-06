{ config, lib, pkgs, ... }:

let
  gpuOverride = {
    PrivateDevices      = lib.mkForce false;
    DeviceAllow         = [ "/dev/dri rw" ];
    SupplementaryGroups = [ "video" "render" ];
  };
in
{

  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = config.ports.immich;
    mediaLocation = "/srv/media/gallery";
    environment = {
      # Keep models loaded indefinitely
      MACHINE_LEARNING_MODEL_TTL = "-1";
      # Best model for smart search: https://docs.immich.app/features/searching#clip-models
      MACHINE_LEARNING_PRELOAD__CLIP__TEXTUAL = "ViT-SO400M-16-SigLIP2-384__webli";
      MACHINE_LEARNING_PRELOAD__CLIP__VISUAL =  "ViT-SO400M-16-SigLIP2-384__webli";
      # Best (and heaviest) facial recognition model: https://huggingface.co/collections/immich-app/facial-recognition
      MACHINE_LEARNING_PRELOAD__FACIAL_RECOGNITION__DETECTION =   "antelopev2";
      MACHINE_LEARNING_PRELOAD__FACIAL_RECOGNITION__RECOGNITION = "antelopev2";
      # Better than "mobile" version - source: drop-down in settings lol
      MACHINE_LEARNING_PRELOAD__OCR__DETECTION =   "PP-OCRv5_server";
      MACHINE_LEARNING_PRELOAD__OCR__RECOGNITION = "PP-OCRv5_server";
      # Close the admin creation endpoint (enable on new setup) TODO: add to docs
      IMMICH_ALLOW_SETUP = "false";
    };
  };

  users.users.immich.extraGroups = [
    "media-private"
    "video"
    "render"
  ];

  systemd.services.immich-server.serviceConfig.ReadWritePaths = [
    "/srv/media/gallery"
  ];

  environment.systemPackages = with pkgs; [ immich-cli ];
}
