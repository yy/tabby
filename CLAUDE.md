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
tabby close --url arxiv             # Close first tab whose URL contains "arxiv"
tabby close --url github.com --all  # Close every tab whose URL matches
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
- Tab indices shift after closing, and browsers reorder windows by recency between calls, so an index from `list` can go stale — use `--expect` to verify title, or `close --url` to find-and-close atomically (no index race). Prefer `--url` in scripts.
- Browser-specific JXA is in `lib/browser.js`; commands use the shared abstraction
- Adding new subcommands: create `lib/tabby-<name>` (executable zsh + JXA script)
