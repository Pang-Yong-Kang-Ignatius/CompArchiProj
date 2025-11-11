// zip_many_txt.c — works with hundreds of files; no <sys/wait.h> required on Windows
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <ctype.h>
#include <sys/stat.h>
#include <time.h>

#ifdef _WIN32
#define POPEN  _popen
#define PCLOSE _pclose
#else
#define POPEN  popen
#define PCLOSE pclose
#endif

// return 1 if name ends with .txt (case-insensitive)
static int is_txt_file(const char *name) {
    const char *dot = strrchr(name, '.');
    if (!dot || dot == name) return 0;
    const char *ext = dot + 1;
    return (tolower((unsigned char)ext[0])=='t' &&
            tolower((unsigned char)ext[1])=='x' &&
            tolower((unsigned char)ext[2])=='t' &&
            ext[3]=='\0');
}

// return 1 if path is a regular file
static int is_regular_file(const char *path) {
    struct stat st;
    return (stat(path, &st) == 0) && S_ISREG(st.st_mode);
}

// strip a trailing ".zip" (case-insensitive)
static void strip_zip(char *s) {
    size_t n = strlen(s);
    if (n >= 4) {
        char *p = s + (n - 4);
        if (tolower((unsigned char)p[0])=='.' &&
            tolower((unsigned char)p[1])=='z' &&
            tolower((unsigned char)p[2])=='i' &&
            tolower((unsigned char)p[3])=='p') {
            *p = '\0';
        }
    }
}

int main(void) {
    DIR *folder;
    struct dirent *entry;
    char zip_name[100];

    printf("Enter a name for your zip file (without .zip): ");
    if (scanf("%99s", zip_name) != 1) {
        fprintf(stderr, "Invalid name.\n");
        return 1;
    }
    strip_zip(zip_name);

    folder = opendir(".");
    if (!folder) {
        perror("opendir");
        return 1;
    }

    // Let zip read file names from stdin (-@) to avoid long command lines
    char cmd[256];
#ifdef _WIN32
    // Assumes `zip` is in PATH (e.g., via Git Bash or installed zip.exe)
    snprintf(cmd, sizeof(cmd), "zip -q -@ ./%s.zip", zip_name);
#else
    snprintf(cmd, sizeof(cmd), "zip -q -@ ./%s.zip", zip_name);
#endif

    struct timespec t0, t1;
#ifdef CLOCK_MONOTONIC
    clock_gettime(CLOCK_MONOTONIC, &t0);
#else
    t0.tv_sec = t0.tv_nsec = 0;
#endif

    FILE *zp = POPEN(cmd, "w");
    if (!zp) {
        perror("popen");
        closedir(folder);
        return 1;
    }

    int count = 0;
    while ((entry = readdir(folder)) != NULL) {
        const char *name = entry->d_name;
        if (is_txt_file(name) && is_regular_file(name)) {
            fprintf(zp, "%s\n", name);   // feed filename to zip
            count++;
        }
    }
    closedir(folder);

    int rc = PCLOSE(zp);

#ifdef CLOCK_MONOTONIC
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double elapsed = (t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec)/1e9;
#else
    double elapsed = 0.0;
#endif

#ifdef _WIN32
    int ok = (rc == 0);                  // on Windows, 0 means success
#else
    int ok = (rc == 0);                  // pclose returns 0 when child exit status was 0
#endif

    if (count == 0) {
        printf("No .txt files found in this folder.\n");
        return 0;
    }

    if (ok) {
        printf("There are number of %d .txt files and compressed into a .zip file\n", count);
        printf("Created zip file path: ./%s.zip\n", zip_name);
        if (elapsed > 0.0) {
            printf("Zipping execution time: %.6f seconds\n", elapsed);
        }
    } else {
        fprintf(stderr, "zip failed (exit code %d). Is 'zip' installed and in PATH?\n", rc);
        return 1;
    }

    return 0;
}
