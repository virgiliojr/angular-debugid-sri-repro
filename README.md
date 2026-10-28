# Reproduction: debugId changes chunk bytes but not the chunk file name

Minimal reproduction for an `@angular/build` issue. Since 22.1.0, the builder adds a `//# debugId=` line to each JS file. In an optimized chunk, the file name hash does not cover this line. A type-only change then gives a chunk with the same file name but different bytes, and a different SRI hash.

## App setup

- Made with `ng new` (Angular CLI 22.2.2), no other packages.
- 3 lazy routes (`/a`, `/b`, `/c`), so the chunk optimizer runs.
- `lazy-a` and `lazy-b` use `src/app/shared/label.ts`. This module has no imports, so it becomes its own chunk.

## Steps

1. Run `npm ci`.
2. Run `npx ng build --source-map --subresource-integrity`.
3. In `dist/repro/browser/`, find the chunk that contains `label:`. Write down its file name and its SHA-384.
4. In `src/app/shared/label.ts`, add `extra?: number;` to the `LabelInput` interface.
5. Run `npx ng build --source-map --subresource-integrity` again.
6. Find the chunk that contains `label:` again.

**Actual result:** the chunk has the same file name, but different bytes. Only the `//# debugId=` line is different. The SRI hash in `index.html` is different too.

**Expected result:** if the bytes of a hashed file change, its file name changes too.

## Script

`bash compare-builds.sh` does steps 2 to 6 and prints the result. At the end, it puts `label.ts` back to its original content.
