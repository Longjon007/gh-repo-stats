#!/usr/bin/env bash
set -e

# This script packages the gh-repo-stats bash script for distribution
# across different platforms for use with gh-extension-precompile

# Get the version/tag if provided as first argument, otherwise use "dev"
VERSION="${1:-dev}"

# Name of the extension
EXTENSION_NAME="gh-repo-stats"

# Source script to distribute
SOURCE_SCRIPT="gh-repo-stats"

# Create dist directory
mkdir -p dist

# Define platforms and architectures
# For bash scripts, the script itself is platform-independent,
# but we need to create platform-specific packages for gh-extension-precompile
PLATFORMS=("linux" "darwin" "windows")
ARCHES=("amd64" "arm64")

echo "Building ${EXTENSION_NAME} ${VERSION} for multiple platforms..."

for platform in "${PLATFORMS[@]}"; do
    for arch in "${ARCHES[@]}"; do
        # Skip arm64 for 32-bit architectures that don't exist
        if [[ "$arch" == "386" ]] && [[ "$platform" == "darwin" ]]; then
            continue
        fi
        
        # Determine file extension
        EXT=""
        if [[ "$platform" == "windows" ]]; then
            EXT=".exe"
        fi
        
        # Create the output filename following gh-extension-precompile convention
        OUTPUT_NAME="${platform}-${arch}${EXT}"
        OUTPUT_PATH="dist/${OUTPUT_NAME}"
        
        echo "Creating ${OUTPUT_PATH}..."
        
        # Copy the bash script to the dist directory
        cp "${SOURCE_SCRIPT}" "${OUTPUT_PATH}"
        
        # Make sure it's executable
        chmod +x "${OUTPUT_PATH}"
    done
done

echo "Build complete! Binaries created in dist/"
ls -lh dist/
