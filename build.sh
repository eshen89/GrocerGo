#!/bin/bash

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Clean previous build
flutter clean

# Build for production
flutter build web --release --web-renderer canvaskit 