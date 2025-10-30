#include <stdio.h>
#include <string.h>
#include <dirent.h>   // for directory reading
#include <stdlib.h>   // for system()

int main() {
    DIR *folder; // a directory pointer using the direcnt.h 
    struct dirent *entry; // point to directory entry and read  information like names 
    char zip_name[100]; // to store user provided zip file name
    char command[1024] = "zip ";  // base zip command then 1024 is the max size of command
    int count = 0; // to count .txt files found starting from 0

    // Ask user for zip name
    printf("Enter a name for your zip file (without .zip): ");
    scanf("%99s", zip_name); // to just read the string but limit it to only 99 characters

    // If user typed ".zip", remove it
    if (strstr(zip_name, ".zip") != 0 ) { // check if .zip is in the name and it exist
        zip_name[strlen(zip_name) - 4] = '\0';   // remove last 4 chars (.zip)
        printf("You included '.zip' , it will be removed.\n");
    }

    // Prepare full command, e.g. "zip mynotes.zip"
    strcat(command, zip_name);
    strcat(command, ".zip");

    // Open current directory
    folder = opendir(".");
    if (folder == 0) {
        printf("Could not open current directory.\n");
        return 1;
    }

    // Loop through files
    while ((entry = readdir(folder)) != 0) {
        char *ext = strrchr(entry->d_name, '.');  // find last '.'
        if (ext && strcmp(ext, ".txt") == 0) {    // check if ends with .txt
            strcat(command, " ");
            strcat(command, entry->d_name);
            count++;
        }
    }

    closedir(folder);

    // If .txt files found, zip them
    if (count > 0) {
        system(command);
        printf("There are %d .txt files. Created zip file: %s.zip\n", count, zip_name);
    } else {
        printf("No .txt files found in this folder.\n");
    }

    return 0;
}
