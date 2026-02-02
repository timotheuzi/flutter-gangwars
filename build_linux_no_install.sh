#!/bin/bash

# Custom build script that avoids installation to /usr/local
# This script builds the Linux version without requiring root permissions

echo "Building Linux desktop version without installation..."

# Set Flutter path
FLUTTER="/home/bim/flutter/bin/flutter"

# Clean previous build
echo "Cleaning previous build..."
$FLUTTER clean

# Build the application
echo "Building application..."
$FLUTTER build linux --release

# Check if build succeeded
if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
    echo "Executable location: build/linux/x64/release/intermediates_do_not_run/droid_gangwar_flutter"
    echo "Bundle location: build/linux/x64/release/bundle/"
    
    # Create a user-friendly copy
    if [ -f "build/linux/x64/release/intermediates_do_not_run/droid_gangwar_flutter" ]; then
        mkdir -p ./release
        cp build/linux/x64/release/intermediates_do_not_run/droid_gangwar_flutter ./release/
        echo "Copied executable to ./release/droid_gangwar_flutter"
        echo "You can run the application with: ./release/droid_gangwar_flutter"
    fi
else
    echo "Build failed!"
    exit 1
fi