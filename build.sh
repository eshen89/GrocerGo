#!/bin/bash

# Exit on error
set -e

# Set up Flutter environment
export FLUTTER_ROOT="/vercel/flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $FLUTTER_ROOT

# Verify flutter installation
which flutter
flutter --version

# Disable analytics
flutter config --no-analytics

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Clean previous build
flutter clean

# Build for production
flutter build web --release

# Verify build output exists
if [ ! -d "build/web" ]; then
    echo "Error: build/web directory not found!"
    exit 1
fi

# Show build contents for debugging
echo "Contents of build/web:"
ls -la build/web/
echo "Contents of build/web/assets:"
ls -la build/web/assets/ || true
echo "Contents of main.dart.js:"
head -n 5 build/web/main.dart.js || true 