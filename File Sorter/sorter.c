#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int main() {
    DIR *folder;
    struct dirent *entry;
    char zip_name[100];
    char command[1024] = "zip ";
    int count = 0;

    printf("Enter a name for your zip file (without .zip): ");
    scanf("%99s", zip_name);

    if (strstr(zip_name, ".zip") != 0) {
        zip_name[strlen(zip_name) - 4] = '\0';
        printf("You included '.zip', it will be removed.\n");
    }

    strcat(command, zip_name);
    strcat(command, ".zip");

    folder = opendir(".");
    if (folder == 0) {
        printf("Could not open current directory.\n");
        return 1;
    }

    while ((entry = readdir(folder)) != 0) {
        char *ext = strrchr(entry->d_name, '.');
        if (ext && strcmp(ext, ".txt") == 0) {
            strcat(command, " ");
            strcat(command, entry->d_name);
            count++;
        }
    }
    closedir(folder);

    if (count > 0) {
        system(command); // Execute zip command
        printf("There are number of %d .txt files and compressed into a .zip file\n", count);
        printf("Created zip file path: ./%s.zip\n", zip_name);
    } else {
        printf("No .txt files found in this folder.\n");
    }

    return 0;
}
