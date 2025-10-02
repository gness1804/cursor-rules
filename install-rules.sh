#!/bin/bash
# install-rules.sh - Install Cursor rules in a workspace

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Installing Cursor rules...${NC}"

# Save the directory where this script is located (before changing directories)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine workspace root
WORKSPACE_ROOT=""
CURRENT_DIR="$(pwd)"

# Look for the true workspace root (contains multiple projects)
SEARCH_DIR="$CURRENT_DIR"
while [ "$SEARCH_DIR" != "/" ]; do
    # Check if this directory contains multiple project directories
    if [ -d "$SEARCH_DIR/scripts" ] && [ -d "$SEARCH_DIR/Desktop" ]; then
        WORKSPACE_ROOT="$SEARCH_DIR"
        echo -e "${GREEN}✅ Found workspace root: $WORKSPACE_ROOT${NC}"
        break
    fi
    SEARCH_DIR="$(dirname "$SEARCH_DIR")"
done

if [ -z "$WORKSPACE_ROOT" ]; then
    # Fallback: look for .cursor directory in parent directories
    SEARCH_DIR="$CURRENT_DIR"
    while [ "$SEARCH_DIR" != "/" ]; do
        if [ -d "$SEARCH_DIR/.cursor" ]; then
            WORKSPACE_ROOT="$SEARCH_DIR"
            echo -e "${GREEN}✅ Found workspace root (by .cursor): $WORKSPACE_ROOT${NC}"
            break
        fi
        SEARCH_DIR="$(dirname "$SEARCH_DIR")"
    done
fi

if [ -z "$WORKSPACE_ROOT" ]; then
    echo -e "${YELLOW}⚠️  No workspace root found. Using current directory as workspace root.${NC}"
    WORKSPACE_ROOT="$CURRENT_DIR"
fi

# Change to workspace root
cd "$WORKSPACE_ROOT"
echo -e "${BLUE}📁 Installing rules in: $(pwd)${NC}"

# Create .cursor/rules directory
mkdir -p .cursor/rules

# Check if rules already exist
if [ -d ".cursor/rules" ] && [ "$(ls -A .cursor/rules 2>/dev/null)" ]; then
    echo -e "${YELLOW}⚠️  Cursor rules already exist in this workspace.${NC}"
    read -p "Do you want to overwrite them? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}ℹ️  Installation cancelled.${NC}"
        exit 0
    fi
fi

# Copy rules from this repository
# SCRIPT_DIR was already set at the beginning of the script

if [ -d "$SCRIPT_DIR" ]; then
    echo -e "${GREEN}📋 Copying Cursor rules from $SCRIPT_DIR...${NC}"
    # Check if .mdc files exist in the script directory
    if ls "$SCRIPT_DIR"/*.mdc 1> /dev/null 2>&1; then
        cp -r "$SCRIPT_DIR"/*.mdc .cursor/rules/
        echo -e "${GREEN}✅ Cursor rules installed successfully!${NC}"
    else
        echo -e "${RED}❌ No .mdc files found in: $SCRIPT_DIR${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Rules source directory not found: $SCRIPT_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Cursor rules installation complete!${NC}"
echo -e "${BLUE}ℹ️  Rules are now active in this workspace.${NC}"
echo -e "${BLUE}ℹ️  Rules location: $(pwd)/.cursor/rules/${NC}"
