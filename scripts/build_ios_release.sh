#!/bin/bash
# ──────────────────────────────────────────────────────
# Melodify iOS Release Build Script
# Usage: ./scripts/build_ios_release.sh [--upload]
# ──────────────────────────────────────────────────────

set -euo pipefail

BUNDLE_ID="com.xxh.melodify"
APP_NAME="Melodify"
TEAM_ID="${APPLE_TEAM_ID:-}"
UPLOAD=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --upload) UPLOAD=true; shift ;;
    --team-id) TEAM_ID="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Building Melodify iOS Release"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Step 1: Clean & Get Dependencies ──
echo ""
echo "📦 Resolving dependencies..."
cd "$(dirname "$0")/.."
flutter clean > /dev/null 2>&1 || true
flutter pub get
cd ios
pod install --repo-update || pod install
cd ..

# ── Step 2: Run Tests ──
echo ""
echo "🧪 Running tests..."
flutter test

# ── Step 3: Analyze ──
echo ""
echo "🔍 Analyzing code..."
flutter analyze

# ── Step 4: Build Release IPA ──
echo ""
echo "🏗 Building release IPA..."
BUILD_CMD="flutter build ipa --release"

if [ -n "$TEAM_ID" ]; then
  BUILD_CMD="$BUILD_CMD --team-id $TEAM_ID"
fi

if [ "$UPLOAD" = true ]; then
  BUILD_CMD="$BUILD_CMD --export-method app-store"
fi

BUILD_CMD="$BUILD_CMD --no-tree-shake-icons"
$BUILD_CMD

# ── Step 5: Show Result ──
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Build Complete!"
echo ""
echo "📱 IPA: build/ios/ipa/Melodify.ipa"
echo "📊 App Size: $(du -sh build/ios/ipa/Melodify.ipa 2>/dev/null | cut -f1 || echo 'N/A')"
echo ""
echo "Next Steps:"
echo "  1. Test the IPA on a real device"
echo "  2. Upload via Transporter: xcrun altool --upload-app -f build/ios/ipa/Melodify.ipa -t ios"
echo "  3. Or upload via Xcode Organizer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
