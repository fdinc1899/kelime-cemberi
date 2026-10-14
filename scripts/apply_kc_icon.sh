#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Icon resources are tracked in Git. This step is optional: add after `flutter create`
# when a CI template force-overwrites Android launcher resources.
test -f assets/icons/app_icon.png || { echo "app_icon.png eksik"; exit 1; }
for density in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  f="android/app/src/main/res/mipmap-${density}/ic_launcher.png"
  test -s "$f" || { echo "Eksik: $f"; exit 1; }
done
printf 'Kelime Cemberi ikon dosyalari hazir.\n'
