#!/bin/zsh
set -euo pipefail

repo_root="${0:A:h:h}"
tabby="$repo_root/bin/tabby"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/bin"
TABBY_OSASCRIPT_LOG="$tmpdir/osascript.log"
export TABBY_OSASCRIPT_LOG

cat >"$tmpdir/bin/osascript" <<'EOF'
#!/bin/zsh
set -euo pipefail

print -r -- "$@" >>"$TABBY_OSASCRIPT_LOG"
print -nr -- "${TABBY_OSASCRIPT_OUTPUT:-}"
exit "${TABBY_OSASCRIPT_EXIT_CODE:-0}"
EOF

chmod +x "$tmpdir/bin/osascript"
export PATH="$tmpdir/bin:$PATH"

run() {
    local expected_status="$1"
    shift

    local output
    set +e
    output="$("$tabby" "$@" 2>&1)"
    local exit_status=$?
    set -e

    if [[ $exit_status -ne $expected_status ]]; then
        echo "expected exit $expected_status, got $exit_status for: tabby $*" >&2
        echo "$output" >&2
        exit 1
    fi

    print -r -- "$output"
}

assert_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" != *"$needle"* ]]; then
        echo "expected output to contain: $needle" >&2
        echo "$haystack" >&2
        exit 1
    fi
}

assert_no_osascript() {
    if [[ -s "$TABBY_OSASCRIPT_LOG" ]]; then
        echo "expected osascript not to be called" >&2
        cat "$TABBY_OSASCRIPT_LOG" >&2
        exit 1
    fi
}

reset_log() {
    : >"$TABBY_OSASCRIPT_LOG"
}

reset_log
output="$(run 1 count nope)"
assert_contains "$output" "Usage: tabby count [--total]"
assert_no_osascript

reset_log
output="$(run 1 dedup nope)"
assert_contains "$output" "Usage: tabby dedup [--dry-run]"
assert_no_osascript

reset_log
output="$(run 1 list --window)"
assert_contains "$output" "Usage: tabby list [--window N]"
assert_no_osascript

reset_log
output="$(run 1 list --window nope)"
assert_contains "$output" "tabby: window must be a positive integer"
assert_no_osascript

reset_log
output="$(run 1 url nope 1)"
assert_contains "$output" "tabby: window must be a positive integer"
assert_no_osascript

reset_log
output="$(run 1 close 1 nope)"
assert_contains "$output" "tabby: tab must be a positive integer"
assert_no_osascript

echo "ok"
