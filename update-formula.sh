#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Version number required${NC}"
    echo "Usage: ./update-formula.sh <version>"
    echo "Example: ./update-formula.sh 0.1.3"
    exit 1
fi

NEW_VERSION=$1
PACKAGE_NAME="brewse"
FORMULA_FILE="Formula/brewse.rb"

echo -e "${YELLOW}Updating $PACKAGE_NAME to version $NEW_VERSION${NC}"

# Construct PyPI URL
PYPI_URL="https://files.pythonhosted.org/packages/source/${PACKAGE_NAME:0:1}/${PACKAGE_NAME}/${PACKAGE_NAME}-${NEW_VERSION}.tar.gz"

echo -e "${YELLOW}Downloading tarball from PyPI...${NC}"
echo "URL: $PYPI_URL"

# Download and calculate SHA256
SHA256=$(curl -sL "$PYPI_URL" | shasum -a 256 | awk '{print $1}')

if [ -z "$SHA256" ]; then
    echo -e "${RED}Error: Failed to download or calculate SHA256${NC}"
    echo "Make sure version $NEW_VERSION exists on PyPI: https://pypi.org/project/$PACKAGE_NAME/$NEW_VERSION/"
    exit 1
fi

echo -e "${GREEN}✓ SHA256: $SHA256${NC}"

# Check if formula file exists
if [ ! -f "$FORMULA_FILE" ]; then
    echo -e "${RED}Error: Formula file not found: $FORMULA_FILE${NC}"
    exit 1
fi

# Update the formula file
echo -e "${YELLOW}Updating formula file...${NC}"

# Create a backup
cp "$FORMULA_FILE" "${FORMULA_FILE}.bak"

# Update URL and SHA256 using sed (macOS compatible)
sed -i '' "s|url \"https://files.pythonhosted.org/packages/source/./.*/.*-.*\.tar\.gz\"|url \"$PYPI_URL\"|" "$FORMULA_FILE"
sed -i '' "s|sha256 \".*\"|sha256 \"$SHA256\"|" "$FORMULA_FILE"

echo -e "${GREEN}✓ Formula updated${NC}"

# Show the diff
echo -e "${YELLOW}Changes:${NC}"
git diff "$FORMULA_FILE"

# Ask for confirmation
echo ""
read -p "Commit and push changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Commit and push
    git add "$FORMULA_FILE"
    git commit -m "Update brewse to v${NEW_VERSION}

- Updated tarball URL for version ${NEW_VERSION}
- Updated SHA256 hash: ${SHA256}"
    
    git push
    
    # Remove backup
    rm "${FORMULA_FILE}.bak"
    
    echo -e "${GREEN}✓ Successfully updated and pushed formula for version $NEW_VERSION${NC}"
    echo ""
    echo "Users can now update with:"
    echo "  brew update"
    echo "  brew upgrade brewse"
else
    # Restore backup
    mv "${FORMULA_FILE}.bak" "$FORMULA_FILE"
    echo -e "${YELLOW}Changes reverted${NC}"
    exit 1
fi

