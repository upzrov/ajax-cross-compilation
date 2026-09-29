#!/bin/bash
set -e

# Цей скрипт призначений для виконання на TARGET системі!
# Відповідно до п. 4, на TARGET системі розгорнуто середовище розробки (gcc, binutils, git).

# п. 4б) Виконати компіляцію за допомогою розробленого скрипту на TARGET.
echo "==> Compiling application natively on TARGET..."
gcc -Wall -O2 -o sysinfo_target_native src/sysinfo.c

# п. 4в) Виконати п. 2б-2в на TARGET.
# 2б) Перевірка працездатності:
echo "==> Running application natively on TARGET (without arguments):"
./sysinfo_target_native

echo "==> Running application on TARGET (with argument 'target_native_output.txt'):"
./sysinfo_target_native target_native_output.txt

# 2в) Аналіз бінарника
echo "==> Analyzing application with binutils (natively on TARGET)..."

echo -e "\n\n# Звіт з аналізу нативної компіляції на TARGET" >> Report.md

echo "## 1. ldd (Залежності від спільних бібліотек на TARGET)" >> Report.md
echo "\`\`\`" >> Report.md
ldd sysinfo_target_native >> Report.md || echo "ldd not available" >> Report.md
echo "\`\`\`" >> Report.md

echo "## 2. size (Розміри секцій ELF)" >> Report.md
echo "\`\`\`" >> Report.md
size sysinfo_target_native >> Report.md
echo "\`\`\`" >> Report.md

echo "## 3. readelf (Заголовки ELF файлу)" >> Report.md
echo "\`\`\`" >> Report.md
readelf -h sysinfo_target_native >> Report.md
echo "\`\`\`" >> Report.md

echo "## 4. strings (Перші 20 рядків)" >> Report.md
echo "\`\`\`" >> Report.md
strings sysinfo_target_native | head -n 20 >> Report.md
echo "\`\`\`" >> Report.md

# п. 4г) Виконати git commit 
echo "==> Committing results to git..."
git add 4_build_target_native.sh Report.md
git commit -m "Task 4: Native build on TARGET, execution, binutils analysis and report"

echo "Task 4 completed successfully."
