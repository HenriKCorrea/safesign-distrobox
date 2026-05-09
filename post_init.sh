#!/bin/bash

set -euo pipefail

FIREFOX_PROFILE_DIR="$HOME/.distrobox/$CONTAINER_ID/firefox"

# Create firefox user profile directory
rm -rf "$FIREFOX_PROFILE_DIR" && mkdir -p "$FIREFOX_PROFILE_DIR"

# Generate Firefox user profile to ensure the directory structure is created
firefox --no-remote --profile "$FIREFOX_PROFILE_DIR" --headless & sleep 5; kill %1

# Install the SafeSign Security module into the Firefox user profile
modutil -dbdir "sql:$FIREFOX_PROFILE_DIR" -add "SafeSign Module" -libfile /usr/lib/libaetpkss.so.3.8.4.2 -force

# Set alternative icon for Firefox to distinguish it from any native Firefox installation on the host system
cp firefox.png "$FIREFOX_PROFILE_DIR/icon.png"
sudo sed -i 's|^Icon=.*|Icon='"$FIREFOX_PROFILE_DIR"'/icon.png|' /usr/share/applications/firefox.desktop

# Delete firefox if already exists, then re-export it with the updated profile directory
distrobox-export --list-apps | grep -qi firefox && distrobox-export --app firefox --delete
distrobox-export --app firefox --extra-flags "--no-remote --profile $FIREFOX_PROFILE_DIR"
