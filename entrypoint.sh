#!/bin/bash
set -e

# If base64-encoded Garmin token data is passed in GARMIN_TOKENS_BASE64, restore it
if [ -n "$GARMIN_TOKENS_BASE64" ]; then
    echo "Restoring Garmin OAuth tokens from GARMIN_TOKENS_BASE64..." >&2
    mkdir -p /root/.garminconnect
    chmod 700 /root/.garminconnect
    echo "$GARMIN_TOKENS_BASE64" | base64 -d > /root/.garminconnect/garmin_tokens.json
    chmod 600 /root/.garminconnect/garmin_tokens.json
    echo "Garmin OAuth tokens restored successfully." >&2
fi

exec garmin-mcp "$@"
