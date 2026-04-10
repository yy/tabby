# tabby

Mac CLI for managing browser tabs (Chrome & Safari). Pure zsh + JXA, no dependencies.

## Commands

```bash
tabby list              # JSON array of {window, tab, title, url}
tabby list --window 1   # Filter to one window
tabby count             # Per-window and total counts
tabby count --total     # Just the number
tabby url               # Active tab URL
tabby url 1 3           # Specific tab URL
tabby close 1 5         # Close by window/tab index
tabby close --expect "GitHub" 1 5   # Close only if title starts with "GitHub"
tabby focus 1 3         # Switch to window 1, tab 3
tabby dedup --dry-run   # Preview duplicate tabs
tabby dedup             # Close duplicates
```

## Browser selection

```bash
tabby --browser safari list         # Use Safari instead of Chrome
TABBY_BROWSER=safari tabby list     # Same, via env var
```

Default: `chrome`. Set `TABBY_BROWSER=safari` in your shell profile to switch permanently.

## Patterns

- `tabby list` output is JSON — pipe through `jq` for filtering
- Tab indices shift after closing — use `--expect` to verify title before closing
- Browser-specific JXA is in `lib/browser.js`; commands use the shared abstraction
- Adding new subcommands: create `lib/tabby-<name>` (executable zsh + JXA script)
