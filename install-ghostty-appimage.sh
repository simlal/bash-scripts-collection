#! /usr/bin/bash

# Fetch latest AppImage URL from ghostty-appimage repo
REPO="psadi/ghostty-appimage"
URL=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r '.assets[] | select(.name | endswith("x86_64.AppImage") and (contains("Glfw") | not)) | .browser_download_url')

if [[ -z "$URL" ]]; then
  echo "Error: Could not find the latest Ghostty AppImage."
  exit 1
fi

# Adjust endpoint
APPIMAGE="$HOME/.local/bin/ghostty"

# Download the latest nightly build
echo "Downloading Ghostty Nightly from $URL..."
curl -L "$URL" -o "$APPIMAGE"

chmod +x "$APPIMAGE"
echo "Done!"
