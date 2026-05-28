# Jonas Jancarik Homebrew Tap

Personal Homebrew tap for @jonasjancarik's projects.

## Available Formulae

### codex-autofocus

Bring the Codex desktop app to the front when a Codex turn finishes.

```bash
brew tap jonasjancarik/tap
brew install codex-autofocus
codex-autofocus install --binary "$(brew --prefix codex-autofocus)/bin/codex-autofocus"
codex-autofocus-menu
```

The `codex-autofocus install` command is intentionally explicit because it edits
your Codex hook config. Codex may ask you to review and trust the hook before it
runs.

### brewse

Interactive TUI browser for Homebrew packages.

```bash
brew tap jonasjancarik/tap
brew install brewse
```

## Development: Updating brewse

When a new version is released on PyPI, update the formula using the provided script:

```bash
./update-formula.sh
```

You can also specify a specific version if needed:

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
