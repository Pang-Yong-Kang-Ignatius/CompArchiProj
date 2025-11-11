// zip_many_txt_list_timer_seconds.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <time.h>

int main() {
    DIR *d = opendir(".");
    if (!d) { printf("Cannot open directory.\n"); return 1; }

    char zip_name[128];
    printf("Enter zip name (without .zip): ");
    scanf("%127s", zip_name);

    FILE *listfile = fopen("files_to_zip.txt", "w");
    if (!listfile) { printf("Failed to create list file.\n"); return 1; }

    int count = 0;
    struct dirent *e;
    while ((e = readdir(d))) {
        char *dot = strrchr(e->d_name, '.');
        if (dot && strcmp(dot, ".txt") == 0) {
            fprintf(listfile, "%s\n", e->d_name);
            count++;
        }
    }
    closedir(d);
    fclose(listfile);

    if (count == 0) {
        remove("files_to_zip.txt");
        printf("No .txt files found.\n");
        return 0;
    }

    char command[512];

#ifdef _WIN32
    // Windows (uses built-in tar to produce .zip)
    snprintf(command, sizeof(command),
             "tar -a -c -f \"%s.zip\" -T files_to_zip.txt", zip_name);
#else
    // Linux/macOS (zip reads list from stdin)
    snprintf(command, sizeof(command),
             "zip -q \"%s.zip\" -@ < files_to_zip.txt", zip_name);
#endif

    clock_t start = clock();
    int rc = system(command);
    clock_t end = clock();

    remove("files_to_zip.txt");

    if (rc != 0) {
        printf("Compression failed (exit code %d)\n", rc);
        return 1;
    }

    // Convert to seconds (previously ms)
    double elapsed_seconds = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Zipped %d .txt files into %s.zip\n", count, zip_name);
    printf("Execution time: %.4f seconds\n", elapsed_seconds);

    return 0;
}
