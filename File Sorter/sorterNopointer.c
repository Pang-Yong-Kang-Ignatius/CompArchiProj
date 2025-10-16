#include <stdio.h>      // for printf, fgets
#include <stdlib.h>     // for system, popen, pclose
#include <string.h>     // for string operations

int main() {
    FILE *fp;                         // file pointer to read command output
    char filename[256];               // stores each file name
    char command[1024] = "zip mytxt.zip";  // base zip command
    int count = 0;

    // open a process to list files using 'ls'
    fp = popen("ls", "r");            // 'ls' lists all files in current directory
    if (fp == NULL) {
        printf("Failed to list directory.\n");
        return 1;
    }

    // read each file name from the list
    while (fgets(filename, sizeof(filename), fp) != NULL) {
        // remove newline character from the end
        filename[strcspn(filename, "\n")] = '\0';

        // check if file name ends with ".txt"
        if (strstr(filename, ".txt") != NULL) {
            count++;
            strcat(command, " ");
            strcat(command, filename);
        }
    }

    pclose(fp);   // close the command output

    if (count > 0) {
        system(command);  // run the zip command
        printf("There are %d .txt files and compressed into mytxt.zip\n", count);
    } else {
        printf("No .txt files found.\n");
    }

    return 0;
}
