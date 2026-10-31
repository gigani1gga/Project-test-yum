#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GRADLE_VERSION="${GRADLE_VERSION:-8.7}"
GRADLE_HOME="$SCRIPT_DIR/.gradle"
GRADLE_DIST_DIR="$GRADLE_HOME/gradle-$GRADLE_VERSION"
GRADLE_BIN="$GRADLE_DIST_DIR/bin/gradle"

mkdir -p "$GRADLE_HOME"

if ! command -v gradle >/dev/null 2>&1; then
  if [ ! -x "$GRADLE_BIN" ]; then
    DIST_ZIP="$GRADLE_HOME/gradle-${GRADLE_VERSION}-bin.zip"
    if [ ! -f "$DIST_ZIP" ]; then
      echo "Downloading Gradle ${GRADLE_VERSION}..."
      curl -L --fail "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "$DIST_ZIP"
    fi
    unzip -q -o "$DIST_ZIP" -d "$GRADLE_HOME"
  fi
  export PATH="$GRADLE_DIST_DIR/bin:$PATH"
fi

exec gradle "$@"
