#!/bin/bash
set -e

# Визначаємо крос-компілятор для TARGET системи. Наприклад, ARM Cortex.
# Якщо не задано іншого, використовуємо arm-linux-gnueabihf-gcc (поширений для 32-bit ARM).
CROSS_COMPILE=${CROSS_COMPILE:-arm-linux-gnueabihf-}
TARGET_CC="${CROSS_COMPILE}gcc"

# п. 3а) Скомпілювати застосунок під TARGET на HOST
echo "==> Cross-compiling application for TARGET using ${TARGET_CC}..."
${TARGET_CC} -Wall -O2 -o sysinfo_target src/sysinfo.c

# п. 3б) Перенести застосунок на TARGET систему.
echo "==> NOTE: Transfer the executable 'sysinfo_target' to the TARGET system manually or using scp."
echo "Example: scp sysinfo_target user@target_ip:/tmp/"

# п. 3в) Виконати аналіз скомпільованого застосунку (на HOST, оскільки ми тут)
# Для читання ELF файлів іншої архітектури краще використовувати крос-версії binutils
echo "==> Analyzing cross-compiled application with binutils..."

echo -e "\n\n# Звіт з аналізу крос-скомпільованого застосунку (TARGET on HOST)" >> Report.md

echo "## 1. ldd (на HOST неможливо виконати ldd для TARGET архітектури напряму)" >> Report.md
echo "Замість цього використовуємо readelf -d" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}readelf -d sysinfo_target >> Report.md || readelf -d sysinfo_target >> Report.md
echo "\`\`\`" >> Report.md

echo "## 2. size (Розміри секцій ELF)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}size sysinfo_target >> Report.md || size sysinfo_target >> Report.md
echo "\`\`\`" >> Report.md

echo "## 3. readelf (Заголовки ELF файлу)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}readelf -h sysinfo_target >> Report.md || readelf -h sysinfo_target >> Report.md
echo "\`\`\`" >> Report.md

echo "## 4. strings (Перші 20 рядків)" >> Report.md
echo "\`\`\`" >> Report.md
${CROSS_COMPILE}strings sysinfo_target | head -n 20 >> Report.md || strings sysinfo_target | head -n 20 >> Report.md
echo "\`\`\`" >> Report.md

# п. 3г) Виконати git commit 
echo "==> Committing results to git..."
git add 3_build_cross.sh Report.md
git commit -m "Task 3: Cross-compile for TARGET on HOST, analyze and update report"

echo "Task 3 completed successfully."
