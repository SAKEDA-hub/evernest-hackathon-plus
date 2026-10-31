#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
OUT="${TMPDIR:-/tmp}/locqa-demo-$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$OUT"
cd "$ROOT"

echo "1/3 Check the clean synthetic example"
python3 -m locqa check \
  --source examples/intl_ru.arb \
  --target examples/intl_kk.arb \
  --glossary glossary.csv \
  --out "$OUT/clean.json"

echo "2/3 Inject three reproducible synthetic issues"
python3 -m locqa seed \
  --source examples/intl_ru.arb \
  --target examples/intl_kk.arb \
  --glossary glossary.csv \
  --n 3 --seed 13 \
  --out "$OUT/seeded.arb" \
  --answers "$OUT/answers.json"

echo "3/3 Detect the injected issues"
python3 -m locqa check \
  --source examples/intl_ru.arb \
  --target "$OUT/seeded.arb" \
  --glossary glossary.csv \
  --all \
  --out "$OUT/seeded-report.json"

echo "Demo artifacts: $OUT"
echo "Open $OUT/clean.html and $OUT/seeded-report.html to view the reports."
