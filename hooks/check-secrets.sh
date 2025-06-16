#!/bin/bash
fail=0

for filename in "$@"; do
  if grep -E -i 'password\s*<-\s*".+"' "$filename"; then
    echo "❌ Found hardcoded password in: $filename"
    fail=1
  fi

  if grep -E -i 'token\s*[:=]\s*["'"'"']?[A-Za-z0-9\-_]{10,}' "$filename"; then
    echo "❌ Found token-like string in: $filename"
    fail=1
  fi
done

exit $fail
