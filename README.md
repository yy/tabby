<p align="center">
  <img src="assets/tabby-logo.png" alt="tabby logo" width="360">
</p>

# tabby

![Claude Insights quote: "User asked Claude to close 114 browser tabs in one session — the digital equivalent of finally cleaning out the garage"](assets/claude-insights-tabby.jpg)

A Mac CLI for herding browser tabs. Pure zsh + JXA, no dependencies.

## Install

```bash
# Clone and add to PATH
git clone git@github.com:yy/tabby.git ~/git/tabby
export PATH="$HOME/git/tabby/bin:$PATH"
```

## Usage

```
tabby list              # List all tabs as JSON
tabby list --window 1   # List tabs in window 1
tabby count             # Count tabs per window
tabby count --total     # Just the total
tabby url               # URL of active tab
tabby url 1 3           # URL of window 1, tab 3
tabby close 1 5         # Close window 1, tab 5
tabby close --url arxiv # Close first tab whose URL contains "arxiv"
tabby focus 1 3         # Switch to window 1, tab 3
tabby dedup             # Close duplicate tabs
tabby dedup --dry-run   # Preview duplicates
```

Composes with standard tools:

```bash
# Find all GitHub tabs
tabby list | jq '.[] | select(.url | test("github.com"))'

# Count tabs per domain
tabby list | jq -r '.[].url' | awk -F/ '{print $3}' | sort | uniq -c | sort -rn

# Close all Google search tabs (careful!)
tabby close --url "google.com/search" --all
```

## Browser selection

```bash
tabby --browser safari list         # Use Safari
TABBY_BROWSER=safari tabby list     # Same, via env var
```

Default: `chrome`. Set `TABBY_BROWSER=safari` in your shell profile to switch permanently.

## Safe close

Tab indices shift when tabs are closed, and browsers reorder windows by recency between calls, so a `window/tab` index read from `list` can point at a different tab by the time you `close` it. Two ways to close safely:

```bash
tabby close --expect "GitHub" 1 5   # Only closes if title starts with "GitHub"
tabby close --url github.com/foo    # Find + close by URL in one step (no index race)
tabby close --url github.com --all  # Close every matching tab
```

Prefer `--url` in scripts: it resolves the tab and closes it inside a single call, so window reordering can't make it hit the wrong tab.

## Permissions

On first run, macOS will prompt you to grant your terminal Automation access to Chrome (or Safari). This allows tabby to read tab titles/URLs and close tabs. You can revoke this in System Settings > Privacy & Security > Automation.

## Privacy

`tabby list` outputs all tab titles and URLs to stdout. Be mindful when piping to files or logs — URLs may contain tokens, session IDs, or reveal private browsing activity.

## Requirements

- macOS
- Google Chrome or Safari
