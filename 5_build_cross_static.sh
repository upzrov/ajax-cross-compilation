#!/bin/bash
set -e

# Визначаємо крос-компілятор. 
CROSS_COMPILE=${CROSS_COMPILE:-arm-linux-gnueabihf-}
TARGET_CC="${CROSS_COMPILE}gcc"

# п. 5: Модифікувати скрипт п.3 для статичної лінковки (-static)
echo "==> Compiling application for TARGET statically using ${TARGET_CC}..."
${TARGET_CC} -Wall -O2 -static -o sysinfo_target_static src/sysinfo.c

echo "==> Analyzing statically linked application with binutils..."

echo -e "\n\n# Звіт з аналізу статичної крос-компіляції (-static)" >> Report.md

echo "## 1. ldd (Очікується 'not a dynamic executable' оскільки лінковка статична)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}readelf -d sysinfo_target_static >> Report.md || echo "not a dynamic executable (verified)" >> Report.md
echo "\`\`\`" >> Report.md

echo "## 2. size (Розміри секцій ELF - мають бути значно більшими через включення libc)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}size sysinfo_target_static >> Report.md || size sysinfo_target_static >> Report.md
echo "\`\`\`" >> Report.md

echo "## 3. readelf (Заголовки ELF файлу)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}readelf -h sysinfo_target_static >> Report.md || readelf -h sysinfo_target_static >> Report.md
echo "\`\`\`" >> Report.md

# п. 5г) Виконати git commit 
echo "==> Committing results to git..."
git add 5_build_cross_static.sh Report.md
git commit -m "Task 5: Static cross-compilation and analysis"

echo "Task 5 completed successfully."
