#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// binary1 for virtual memory page number
// binary for virtual page offset

int main() {
    // Page table
    int Process_A[32] = {9, 1, 14, 10, -1, 13, 8, 15, -1, 30, 18, -1, 21, 27, -1, 22, 29, -1, 19, 26, 17, 25, -1, 31, 20, 0, 5, 4, -1, -1, 3, 2};
    // -1 represents "Frame number not found for this page"

    char binary1[5], binary2[8]; // buffers for input
    int decimal1, decimal2;

    printf("========================================= Convert Virtual Address to Physical Address =========================================\n");

    // Input virtual page number (5-bit)
    while (1) {
        printf("Enter virtual memory page number (5 bits): ");
        scanf("%s", binary1);

        // Check if only 0 or 1
        int valid = 1;
        if (strlen(binary1) != 5 && strspn(binary1, "01") !=5) {
            valid = 0;
        } 

        if (!valid) {
            printf("Please enter a valid binary number (only 0s and 1s allowed).\n");
            continue;
        }

        decimal1 = (int)strtol(binary1, NULL, 2);
        if (decimal1 >= 0 && decimal1 <= 31) {
            break;
        } else {
            printf("Input a valid binary that is less than or equals to 31.\n");
        }
    }

    // Input virtual page offset (8-bit)
    while (1) {
        printf("Enter virtual page offset (8 bits): ");
        scanf("%s", binary2);

        // Check if only 0 or 1
        int valid = 1;
        for (int i = 0; i < strlen(binary2); i++) {
            if (binary2[i] != '0' && binary2[i] != '1') {
                valid = 0;
                break;
            }
        }

        if (!valid) {
            printf("Please enter a valid binary number (only 0s and 1s allowed).\n");
            continue;
        }

        decimal2 = (int)strtol(binary2, NULL, 2);
        if (decimal2 >= 0 && decimal2 <= 255) {
            break;
        } else {
            printf("Input a valid binary that is less than or equals to 255.\n");
        }
    }

    // Format page offset to 8-bit binary
    char offset_binary[9];
    for (int i = 7; i >= 0; i--) {
        offset_binary[7-i] = (decimal2 & (1 << i)) ? '1' : '0';
    }
    offset_binary[8] = '\0';

    // Group into 4-bit halves for display
    char grouped_offset[10];
    grouped_offset[0] = offset_binary[0];
    grouped_offset[1] = offset_binary[1];
    grouped_offset[2] = offset_binary[2];
    grouped_offset[3] = offset_binary[3];
    grouped_offset[4] = ' ';
    grouped_offset[5] = offset_binary[4];
    grouped_offset[6] = offset_binary[5];
    grouped_offset[7] = offset_binary[6];
    grouped_offset[8] = offset_binary[7];
    grouped_offset[9] = '\0';

    printf("========================================================== Results ============================================================\n");

    // Virtual page number binary (5 bits)
    char virtual_binary[6];
    for (int i = 4; i >= 0; i--) {
        virtual_binary[4-i] = (decimal1 & (1 << i)) ? '1' : '0';
    }
    virtual_binary[5] = '\0';

    int frame_no = Process_A[decimal1];

    printf("The virtual memory address you keyed in is: %s %s\n", virtual_binary, grouped_offset);

    if (frame_no == -1) {
        printf("Frame number not found for this page\n");
    } else {
        // Physical frame binary (5 bits)
        char frame_binary[6];
        for (int i = 4; i >= 0; i--) {
            frame_binary[4-i] = (frame_no & (1 << i)) ? '1' : '0';
        }
        frame_binary[5] = '\0';

        printf("The physical memory address to be accessed after paging is: %s %s\n", frame_binary, grouped_offset);
    }

    return 0;
}
