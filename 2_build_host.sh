#!/bin/bash
set -e

# п. 2а) Скомпілювати застосунок
echo "==> Compiling application for HOST..."
gcc -Wall -O2 -o sysinfo_host src/sysinfo.c

# п. 2б) Перевірити застосунок на працездатність
echo "==> Running application on HOST (without arguments):"
./sysinfo_host

echo "==> Running application on HOST (with argument 'host_output.txt'):"
./sysinfo_host host_output.txt

echo "==> Running application on HOST again (to check warning and append):"
./sysinfo_host host_output.txt

# п. 2в) Виконати аналіз скомпільованого застосунку за допомогою утіліт binutils
echo "==> Analyzing application with binutils..."

echo "# Звіт з аналізу скомпільованого застосунку (HOST)" > Report.md

echo "## 1. ldd (Залежності від спільних бібліотек)" >> Report.md
echo "\`\`\`" >> Report.md
ldd sysinfo_host >> Report.md || echo "ldd not available" >> Report.md
echo "\`\`\`" >> Report.md

echo "## 2. size (Розміри секцій ELF)" >> Report.md
echo "\`\`\`" >> Report.md
size sysinfo_host >> Report.md
echo "\`\`\`" >> Report.md

echo "## 3. readelf (Заголовки ELF файлу)" >> Report.md
echo "\`\`\`" >> Report.md
readelf -h sysinfo_host >> Report.md
echo "\`\`\`" >> Report.md

echo "## 4. strings (Перші 20 рядків, що містяться в бінарному файлі)" >> Report.md
echo "\`\`\`" >> Report.md
strings sysinfo_host | head -n 20 >> Report.md
echo "\`\`\`" >> Report.md

# п. 2г) Виконати git commit
echo "==> Committing results to git..."
git add src/sysinfo.c 2_build_host.sh Report.md
git commit -m "Task 2: Host build, functionality check, and binutils analysis"

echo "Task 2 completed successfully."
