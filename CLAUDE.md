# tabby

Mac CLI for managing Chrome browser tabs. Pure zsh + JXA, no dependencies.

## Commands

```bash
tabby list              # JSON array of {window, tab, title, url}
tabby list --window 1   # Filter to one window
tabby count             # Per-window and total counts
tabby count --total     # Just the number
tabby url               # Active tab URL
tabby url 1 3           # Specific tab URL
tabby close 1 5         # Close by window/tab index
tabby dedup --dry-run   # Preview duplicate tabs
tabby dedup             # Close duplicates
```

## Patterns

- `tabby list` output is JSON — pipe through `jq` for filtering
- Tab indices shift after closing — close from highest index first, or re-list between closes
- Adding new subcommands: create `lib/tabby-<name>` (executable zsh + JXA script)
