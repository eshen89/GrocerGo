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
flutter build web --release --base-href /

# Verify build output exists
if [ ! -d "build/web" ]; then
    echo "Error: build/web directory not found!"
    exit 1
fi

# List build output
ls -la build/web/ 