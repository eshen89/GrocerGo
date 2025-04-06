#!/bin/bash

# Exit on error
set -e

# Create a non-root user
useradd -m builder || true

# Set ownership and permissions
mkdir -p /vercel/flutter
chown -R builder:builder /vercel/flutter
chown -R builder:builder .

# Run Flutter commands as non-root user
runuser -l builder -c '
export PATH="/vercel/flutter/bin:$PATH"
export HOME="/home/builder"

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /vercel/flutter

# Verify flutter installation
which flutter
flutter --version

# Disable analytics and accept licenses
flutter config --no-analytics

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Clean previous build
flutter clean

# Build for production
flutter build web --release --base-href /
'

# Verify build output exists
if [ ! -d "build/web" ]; then
    echo "Error: build/web directory not found!"
    exit 1
fi

# List build output
ls -la build/web/ 