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
tabby list | jq -r '.[] | select(.url | test("google.com/search")) | "\(.window) \(.tab)"' | while read w t; do tabby close $w $t; done
```

## Requirements

- macOS
- Google Chrome
