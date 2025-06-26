#!/usr/bin/env bash

# ---- #
# ASDF #
# ---- #
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# ---- #
# DENO #
# ---- #
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# -------- #
# POSTGRES #
# -------- #
# Default `psql` to PostgreSQL v17
if command -v brew &>/dev/null; then
  postgres_prefix="$(brew --prefix postgresql@17 2>/dev/null || true)"
  if [ -n "$postgres_prefix" ] && [ -d "$postgres_prefix/bin" ]; then
    export PATH="$postgres_prefix/bin:$PATH"
  fi
fi

# --------------- #
# SQLITE SETTINGS #
# --------------- #
# Prefer Homebrew's SQLite over the default macOS one, if available
if command -v brew &>/dev/null; then
  sqlite_prefix="$(brew --prefix sqlite 2>/dev/null || true)"
  if [ -n "$sqlite_prefix" ] && [ -d "$sqlite_prefix/bin" ]; then
    export PATH="$sqlite_prefix/bin:$PATH"
  fi
fi