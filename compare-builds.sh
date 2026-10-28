#!/usr/bin/env bash
# Builds the app two times. Between the builds, only the LabelInput interface changes.
# Prints the name, SHA-384 and debugId of the chunk that contains label.ts.
set -euo pipefail

cd "$(dirname "$0")"
LABEL=src/app/shared/label.ts
OUT=tmp/compare
rm -rf "$OUT"
mkdir -p "$OUT"
cp "$LABEL" "$OUT/label.ts.orig"
trap 'cp "$OUT/label.ts.orig" "$LABEL"' EXIT

build() {
  rm -rf dist
  npx ng build --source-map --subresource-integrity > /dev/null
  local chunk name sha
  chunk=$(grep -l 'label:' dist/repro/browser/chunk-*.js)
  name=$(basename "$chunk")
  sha="sha384-$(openssl dgst -sha384 -binary "$chunk" | openssl base64 -A)"
  echo "$1"
  echo "  file name:          $name"
  echo "  sha384 of bytes:    $sha"
  echo "  debugId line:       $(grep -o '//# debugId=.*' "$chunk")"
  echo "  sha in index.html:  $(grep -q "$sha" dist/repro/browser/index.html && echo yes || echo no)"
  cp "$chunk" "$OUT/$2.js"
}

build "Build 1" build1
# Type-only change. The JS output of label.ts stays the same.
sed -i.bak 's/value: string;/value: string; extra?: number;/' "$LABEL"
rm -f "$LABEL.bak"
build "Build 2" build2

echo
echo "Diff of the chunk between the two builds:"
diff "$OUT/build1.js" "$OUT/build2.js" || true
