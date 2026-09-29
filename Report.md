# Звіт з аналізу скомпільованого застосунку (HOST)
## 1. ldd (Залежності від спільних бібліотек)
```
	linux-vdso.so.1 (0x00007bce0f0c0000)
	libc.so.6 => /usr/lib/x86_64-linux-gnu/libc.so.6 (0x00007bce0ee00000)
	/lib64/ld-linux-x86-64.so.2 (0x00007bce0f0c2000)
```
## 2. size (Розміри секцій ELF)
```
   text	   data	    bss	    dec	    hex	filename
   3594	    696	     16	   4306	   10d2	sysinfo_host
```
## 3. readelf (Заголовки ELF файлу)
```
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Position-Independent Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x1280
  Start of program headers:          64 (bytes into file)
  Start of section headers:          14616 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         14
  Size of section headers:           64 (bytes)
  Number of section headers:         31
  Section header string table index: 30
```
## 4. strings (Перші 20 рядків, що містяться в бінарному файлі)
```
{/lib64/ld-linux-x86-64.so.2
gethostname
perror
__stack_chk_fail
__printf_chk
fopen
stdout
strftime
__fprintf_chk
__libc_start_main
__cxa_finalize
localtime
fclose
access
fwrite
uname
libc.so.6
GLIBC_2.3.4
GLIBC_2.4
GLIBC_2.34
```
