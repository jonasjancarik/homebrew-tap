# Brewse Tap

Custom Homebrew tap for [brewse](https://github.com/jonasjancarik/brewse) - an interactive TUI browser for Homebrew packages.

## What is brewse?

Brewse is an interactive terminal UI that lets you browse, search, and manage Homebrew packages with a beautiful curses interface. Features include:

- 🔍 Fast search through all Homebrew formulae and casks
- 📊 Package details with version info and install statistics
- ⚡ Real-time download progress indicators
- 💾 Smart caching for instant searches
- ⌨️ Keyboard-driven navigation

## Installation

```bash
brew tap jonasjancarik/brewse
brew install brewse
```

Or install directly without tapping:

```bash
brew install jonasjancarik/brewse/brewse
```

## Usage

Launch the interactive browser:

```bash
brewse
```

Or search directly:

```bash
brewse python
```

## Documentation

For full documentation, see the [main repository](https://github.com/jonasjancarik/brewse).

## Updating the Formula

When a new version is released on PyPI, update the formula using the provided script:

```bash
./update-formula.sh 0.1.3
```

This will automatically:
- Download the tarball from PyPI
- Calculate the SHA256 hash
- Update the formula file
- Show you the diff
- Commit and push the changes (with confirmation)

## Users: Updating brewse

To update brewse to the latest version:

```bash
brew update
brew upgrade brewse
```

