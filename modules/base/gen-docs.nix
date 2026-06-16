{ lib, pkgs, options, ... }:

let
  # Filter out just the options from the "ivy" namespace
  ivyOptions = lib.filterAttrs (n: _: n == "ivy") options;

  optionsDoc = pkgs.nixosOptionsDoc {
    options = ivyOptions;
  };
  
  # Beware of the hardcoded path when rebuilding
  # TODO: Fix possible build errors due to missing directory
  docsDir = "/home/non/nixos/docs";

in {
  system.build.ivy-docs = optionsDoc.optionsCommonMark;

  # Regenerates the docs on every rebuild
  system.activationScripts.gen-ivy-docs = {
    text = ''
      mkdir -p ${docsDir}
      TARGET="${docsDir}/ivy-options.md"
      TMP_FILE=$(mktemp)

      cp ${optionsDoc.optionsCommonMark} "$TARGET"

      ${pkgs.gnused}/bin/sed -E \
        -e 's|\[/nix/store/[^/]+/([^]]+)\]\([^)]+\)|\1|g' \
        -e 's/^[[:space:]]+$//' \
        "$TARGET" | ${pkgs.coreutils}/bin/cat -s > "$TMP_FILE"

      mv "$TMP_FILE" "$TARGET"
      chmod 644 "$TARGET"
      chown non:users "$TARGET"
    '';
  };
}

