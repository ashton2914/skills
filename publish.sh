#!/bin/bash

# Exit on error
set -e

# Getting the project root directory where the script is located
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$PROJECT_ROOT/skills"
DIST_DIR="$PROJECT_ROOT/dist"

echo "Using skills directory: $SKILLS_DIR"
if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: skills directory not found at $SKILLS_DIR!"
  exit 1
fi

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

# Loop through subdirectories checking for _meta.json
for SKILL_PATH in "$SKILLS_DIR"/*; do
  # Check if it's a directory
  if [ -d "$SKILL_PATH" ]; then
    SKILL_NAME="$(basename "$SKILL_PATH")"
    META_FILE="$SKILL_PATH/_meta.json"
    
    if [ -f "$META_FILE" ]; then
      # Extract fields using Python to avoid needing to install jq
      SLUG=$(python3 -c "import json, sys; print(json.load(open(sys.argv[1]))['slug'])" "$META_FILE" 2>/dev/null || echo "")
      VERSION=$(python3 -c "import json, sys; print(json.load(open(sys.argv[1]))['version'])" "$META_FILE" 2>/dev/null || echo "")
      
      if [ -z "$SLUG" ] || [ -z "$VERSION" ]; then
        echo "Warning: Could not read valid 'slug' or 'version' from $META_FILE. Skipping $SKILL_NAME..."
        continue
      fi
      
      ZIP_NAME="${SLUG}-${VERSION}.zip"
      ZIP_PATH="$DIST_DIR/$ZIP_NAME"
      
      echo "Packaging skill '${SKILL_NAME}' as '${ZIP_NAME}'..."
      
      # Remove previously built zip if it exists
      rm -f "$ZIP_PATH"
      
      # Change into directory so the zip file contents don't include the folder structure path
      (cd "$SKILL_PATH" && zip -r "$ZIP_PATH" .)
      
    else
      echo "Skipping '${SKILL_NAME}': no _meta.json found."
    fi
  fi
done

echo ""
echo "Publishing complete! Outputs are located in $DIST_DIR"
