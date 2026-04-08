# tabby

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
tabby list | jq -r '.[] | select(.url | test("google.com/search")) | "\(.window) \(.tab)"' \
  | while IFS=' ' read -r w t; do tabby close "$w" "$t"; done
```

## Browser selection

```bash
tabby --browser safari list         # Use Safari
TABBY_BROWSER=safari tabby list     # Same, via env var
```

Default: `chrome`. Set `TABBY_BROWSER=safari` in your shell profile to switch permanently.

## Safe close

Tab indices shift when tabs are closed. Use `--expect` to verify a tab's title before closing:

```bash
tabby close --expect "GitHub" 1 5   # Only closes if title starts with "GitHub"
```

## Permissions

On first run, macOS will prompt you to grant your terminal Automation access to Chrome (or Safari). This allows tabby to read tab titles/URLs and close tabs. You can revoke this in System Settings > Privacy & Security > Automation.

## Privacy

`tabby list` outputs all tab titles and URLs to stdout. Be mindful when piping to files or logs — URLs may contain tokens, session IDs, or reveal private browsing activity.

## Requirements

- macOS
- Google Chrome or Safari
