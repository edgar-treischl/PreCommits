#!/bin/bash
# Custom secret detection with grep-like regex

fail=0

while read filename; do
  # Detect R-style password assignments
  if grep -E -i 'password\s*<-\s*".+"' "$filename"; then
    echo "❌ Found hardcoded password in: $filename"
    fail=1
  fi

  # Detect generic token strings
  if grep -E -i 'token\s*[:=]\s*["'"'"']?[A-Za-z0-9\-_]{10,}' "$filename"; then
    echo "❌ Found token-like string in: $filename"
    fail=1
  fi
done

exit $fail
