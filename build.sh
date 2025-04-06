#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Clean previous build
flutter clean

# Build for production
flutter build web --release --web-renderer canvaskit --base-href /

# Verify build output
ls -la build/web/ 