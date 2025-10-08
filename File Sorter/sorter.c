#include <stdio.h>      // for input and output
#include <dirent.h>     // for directory operations
#include <string.h>     // for string functions
#include <stdlib.h>     // for system() and malloc()

int main() {
    struct dirent *entry;           // used to store directory entries
    DIR *folder;                    // pointer for directory
    int count = 0;                  // to count .txt files
    char command[1024] = "zip mytxt.zip";  // base command to create zip file

    folder = opendir(".");          // open the current directory
    if (folder == NULL) {           // check if it failed
        printf("Could not open directory.\n");
        return 1;
    }

    // go through each file in the directory
    while ((entry = readdir(folder)) != NULL) {
        // check if the file name ends with ".txt"
        if (strstr(entry->d_name, ".txt") != NULL) {
            count++;
            strcat(command, " ");             // add a space before next filename
            strcat(command, entry->d_name);   // add the filename to the zip command
        }
    }

    closedir(folder);  // close the directory

    // run the zip command only if there are .txt files
    if (count > 0) {
        system(command);  // execute the zip command (uses system shell)
        printf("There are %d .txt files and compressed into a .zip file\n", count);
    } else {
        printf("No .txt files found in this directory.\n");
    }

    return 0;
}
