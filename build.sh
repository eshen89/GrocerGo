#!/bin/bash

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for production with proper base href
flutter build web --release --web-renderer canvaskit --base-href / 