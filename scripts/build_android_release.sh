#!/bin/bash
# ──────────────────────────────────────────────────────
# Melodify Android Release Build Script
# Usage: ./scripts/build_android_release.sh [--aab|--apk]
# ──────────────────────────────────────────────────────

set -euo pipefail

BUILD_TYPE="appbundle"  # Default: Android App Bundle for Play Store

while [[ $# -gt 0 ]]; do
  case "$1" in
    --aab) BUILD_TYPE="appbundle"; shift ;;
    --apk) BUILD_TYPE="apk"; shift ;;
    *) shift ;;
  esac
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 Building Melodify Android Release"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$(dirname "$0")/.."

# ── Step 1: Clean & Get Dependencies ──
echo ""
echo "📦 Resolving dependencies..."
flutter clean > /dev/null 2>&1 || true
flutter pub get

# ── Step 2: Run Tests ──
echo ""
echo "🧪 Running tests..."
flutter test

# ── Step 3: Analyze ──
echo ""
echo "🔍 Analyzing code..."
flutter analyze

# ── Step 4: Build ──
echo ""
echo "🏗 Building release $BUILD_TYPE..."

if [ "$BUILD_TYPE" == "appbundle" ]; then
  flutter build appbundle --release
  OUTPUT="build/app/outputs/bundle/release/app-release.aab"
  SIZE=$(du -sh "$OUTPUT" 2>/dev/null | cut -f1 || echo 'N/A')
else
  # Split APKs per ABI for smaller download size
  flutter build apk --release --split-per-abi
  OUTPUT="build/app/outputs/flutter-apk/"
  SIZE=""
  for apk in "$OUTPUT"*.apk; do
    SIZE="$SIZE  $(basename "$apk"): $(du -sh "$apk" 2>/dev/null | cut -f1)"
  done
fi

# ── Step 5: Show Result ──
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Build Complete!"
echo ""
if [ "$BUILD_TYPE" == "appbundle" ]; then
  echo "📦 AAB: $OUTPUT"
  echo "📊 Size: $SIZE"
  echo ""
  echo "Next Steps:"
  echo "  1. Sign the AAB with your release keystore"
  echo "  2. Upload to Google Play Console"
  echo "  3. Or test locally: bundletool build-apks --bundle=$OUTPUT --output=app.apks"
else
  echo "📱 APKs: $OUTPUT"
  echo "$SIZE"
  echo ""
  echo "Next Steps:"
  echo "  1. Sign the APKs with your release keystore"
  echo "  2. Install: adb install app-armeabi-v8a-release.apk"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
