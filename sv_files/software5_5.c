#include <stdio.h>
#include <time.h>

// Matrix dimensions
#define INPUT_ROWS 5
#define INPUT_COLS 5
#define KERNEL_ROWS 3
#define KERNEL_COLS 3
#define OUTPUT_ROWS (INPUT_ROWS - KERNEL_ROWS + 1)
#define OUTPUT_COLS (INPUT_COLS - KERNEL_COLS + 1)

// Function prototypes
void matrix_convolution(int input[INPUT_ROWS][INPUT_COLS], int kernel[KERNEL_ROWS][KERNEL_COLS], int output[OUTPUT_ROWS][OUTPUT_COLS]);

int main() {
    // Input matrix (5x5)
    int input[INPUT_ROWS][INPUT_COLS] = {
        {0, 1, 2, 3, 4},
        {5, 6, 7, 8, 9},
        {10, 11, 12, 13, 14},
        {15, 16, 17, 18, 19},
        {20, 21, 22, 23, 24}
    };

    // Kernel matrix (3x3)
    int kernel[KERNEL_ROWS][KERNEL_COLS] = {
        {1, 0, 1},
        {1, 0, 1},
        {1, 0, 1}
    };

    // Output matrix (3x3)
    int output[OUTPUT_ROWS][OUTPUT_COLS] = {0};

    // Perform matrix convolution
    matrix_convolution(input, kernel, output);


    // Print the input matrix
    printf("Input Matrix:\n");
    for (int i = 0; i < INPUT_ROWS; i++) {
        for (int j = 0; j < INPUT_COLS; j++) {
            printf("%d ", input[i][j]);
        }
        printf("\n");
    }

    // Print the kernel matrix
    printf("\nKernel Matrix:\n");
    for (int i = 0; i < KERNEL_ROWS; i++) {
        for (int j = 0; j < KERNEL_COLS; j++) {
            printf("%d ", kernel[i][j]);
        }
        printf("\n");
    }

    // Print the output matrix
    printf("\nOutput Matrix:\n");
    for (int i = 0; i < OUTPUT_ROWS; i++) {
        for (int j = 0; j < OUTPUT_COLS; j++) {
            printf("%d ", output[i][j]);
        }
        printf("\n");
    }

    return 0;
}

// Function to perform matrix convolution
void matrix_convolution(int input[INPUT_ROWS][INPUT_COLS], int kernel[KERNEL_ROWS][KERNEL_COLS], int output[OUTPUT_ROWS][OUTPUT_COLS]) {
    for (int i = 0; i < OUTPUT_ROWS; i++) {
        for (int j = 0; j < OUTPUT_COLS; j++) {
            int sum = 0;
            for (int ki = 0; ki < KERNEL_ROWS; ki++) {
                for (int kj = 0; kj < KERNEL_COLS; kj++) {
                    sum += input[i + ki][j + kj] * kernel[ki][kj];
                }
            }
            output[i][j] = sum;
        }
    }
}
