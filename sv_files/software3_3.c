#include <stdio.h>
#include <time.h>

// Matrix dimensions
#define INPUT_ROWS 3
#define INPUT_COLS 3
#define KERNEL_ROWS 2
#define KERNEL_COLS 2
#define OUTPUT_ROWS (INPUT_ROWS - KERNEL_ROWS + 1)
#define OUTPUT_COLS (INPUT_COLS - KERNEL_COLS + 1)

// Function prototypes
void matrix_convolution(int input[INPUT_ROWS][INPUT_COLS], int kernel[KERNEL_ROWS][KERNEL_COLS], int output[OUTPUT_ROWS][OUTPUT_COLS]);

int main() {
    // Input matrix (3x3)
    int input[INPUT_ROWS][INPUT_COLS] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };

    // Kernel matrix (2x2)
    int kernel[KERNEL_ROWS][KERNEL_COLS] = {
        {1, 0},
        {1, 0}
    };

    // Output matrix (calculated dimensions: 2x2)
    int output[OUTPUT_ROWS][OUTPUT_COLS] = {0};

    // Start benchmarking
    clock_t start_time = clock();

    // Perform matrix convolution
    matrix_convolution(input, kernel, output);

    // End benchmarking
    clock_t end_time = clock();

    // Calculate total execution time in seconds
    double total_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

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

    // Print the total execution time
    printf("\nExecution Time: %.6f seconds\n", total_time);

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
