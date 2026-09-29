#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/utsname.h>
#include <unistd.h>

void print_sysinfo(FILE *out) {
    char hostname[256];
    if (gethostname(hostname, sizeof(hostname)) != 0) {
        strncpy(hostname, "unknown", sizeof(hostname) - 1);
        hostname[sizeof(hostname) - 1] = '\0';
    }

    time_t t = time(NULL);
    struct tm *tm = localtime(&t);
    char time_str[64];
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M:%S", tm);

    struct utsname sys_info;
    if (uname(&sys_info) != 0) {
        fprintf(out, "Error getting system info\n");
        return;
    }

    fprintf(out, "Hostname: %s\n", hostname);
    fprintf(out, "Current Time: %s\n", time_str);
    fprintf(out, "OS System: %s\n", sys_info.sysname);
    fprintf(out, "OS Release: %s\n", sys_info.release);
    fprintf(out, "OS Version: %s\n", sys_info.version);
    fprintf(out, "Hardware Platform: %s\n", sys_info.machine);
}

int main(int argc, char *argv[]) {
    // 1. Повинен виводити в консоль форматоване інформаційне повідомлення
    print_sysinfo(stdout);

    // 2. Якщо в якості параметра командної строки задане ім'я файлу - записати це повідомлення в файл
    if (argc > 1) {
        const char *filename = argv[1];
        
        // Якщо такий файл існує то вивести попередження
        if (access(filename, F_OK) == 0) {
            printf("Warning: File '%s' exists, appending data.\n", filename);
        }

        // та дописати інформаційне повідомлення в кінець файлу.
        FILE *file = fopen(filename, "a");
        if (file == NULL) {
            perror("Error opening file");
            return 1;
        }
        
        print_sysinfo(file);
        fclose(file);
    }

    return 0;
}
