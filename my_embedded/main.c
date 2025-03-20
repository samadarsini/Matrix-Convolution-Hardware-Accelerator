// filename: main.c
// Unified base address with incremental offsets for all registers

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>  // Added for benchmarking
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

// Constants for HPS-to-FPGA bridge access
#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

// Base address of the matrix_convolution module
#define MATRIX_CONVOLUTION_BASE 0xFF200400

// Macros for accessing Avalon-MM registers
#define IO_PTR(BASE, OFFSET) ((volatile uint32_t *)(virtual_base + ((BASE + OFFSET) & HW_REGS_MASK)))

// Function prototypes
void write_input_matrix(void *virtual_base);
void start_computation(void *virtual_base);
void add_basic_delay();
void read_output_matrix(void *virtual_base);
void print_current_time();
double get_time_diff(struct timespec start, struct timespec end);

int main() {
    void *virtual_base;
    int fd;
    struct timespec total_start, total_end, start_time, end_time;
    double elapsed_time, total_time;

    // Open /dev/mem to access FPGA registers
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("ERROR: Could not open /dev/mem...\n");
        return 1;
    }

    // Map FPGA registers into user space
    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
    if (virtual_base == MAP_FAILED) {
        printf("ERROR: mmap() failed...\n");
        close(fd);
        return 1;
    }

    printf("INFO: FPGA memory mapped successfully.\n");

    // Start total execution time
    clock_gettime(CLOCK_MONOTONIC, &total_start);
    print_current_time();

    // Benchmark the input writing phase
    clock_gettime(CLOCK_MONOTONIC, &start_time);
    printf("DEBUG: Writing input matrix to FPGA...\n");
    write_input_matrix(virtual_base);
    clock_gettime(CLOCK_MONOTONIC, &end_time);
    elapsed_time = get_time_diff(start_time, end_time);
    printf("BENCHMARK: Writing inputs took %.6f seconds.\n", elapsed_time);

    // Benchmark the computation phase
    clock_gettime(CLOCK_MONOTONIC, &start_time);
    printf("DEBUG: Starting computation...\n");
    start_computation(virtual_base);
    add_basic_delay();
    clock_gettime(CLOCK_MONOTONIC, &end_time);
    elapsed_time = get_time_diff(start_time, end_time);
    printf("BENCHMARK: Computation took %.6f seconds.\n", elapsed_time);

    // Benchmark the output reading phase
    clock_gettime(CLOCK_MONOTONIC, &start_time);
    printf("DEBUG: Reading output matrix from FPGA...\n");
    read_output_matrix(virtual_base);
    clock_gettime(CLOCK_MONOTONIC, &end_time);
    elapsed_time = get_time_diff(start_time, end_time);
    printf("BENCHMARK: Reading outputs took %.6f seconds.\n", elapsed_time);

    // End total execution time
    clock_gettime(CLOCK_MONOTONIC, &total_end);
    total_time = get_time_diff(total_start, total_end);
    printf("TOTAL EXECUTION TIME: %.6f seconds.\n", total_time);

    // Clean up and close
    if (munmap(virtual_base, HW_REGS_SPAN) != 0) {
        printf("ERROR: munmap() failed...\n");
        close(fd);
        return 1;
    }
    close(fd);
    printf("INFO: /dev/mem closed successfully.\n");

    return 0;
}

// Function to write inputs to the matrix convolution module
void write_input_matrix(void *virtual_base) {
    for (int i = 0; i < 9; i++) {
        *IO_PTR(MATRIX_CONVOLUTION_BASE, i * 4) = i + 1;  // Write inputs a0 to a8
        uint32_t value = *IO_PTR(MATRIX_CONVOLUTION_BASE, i * 4);
        printf("DEBUG: Wrote a%d = %d at address 0x%08X, Read back: %d\n", i, i + 1, MATRIX_CONVOLUTION_BASE + (i * 4), value);
    }
    printf("INFO: Input matrix written successfully.\n");
}

// Function to start the computation
void start_computation(void *virtual_base) {
    *IO_PTR(MATRIX_CONVOLUTION_BASE, 9 * 4) = 1;  // Write 1 to start register
    uint32_t start_value = *IO_PTR(MATRIX_CONVOLUTION_BASE, 9 * 4);
    printf("DEBUG: Wrote start = 1 at address 0x%08X, Read back: %d\n", MATRIX_CONVOLUTION_BASE + (9 * 4), start_value);
    printf("INFO: Computation started.\n");
}

// Function to add a basic delay
void add_basic_delay() {
    volatile int delay_count = 1000000;  // Adjust this value as needed
    while (delay_count > 0) {
        delay_count--;
    }
    printf("DEBUG: Basic delay completed.\n");
}

// Function to read outputs from the matrix convolution module
void read_output_matrix(void *virtual_base) {
    uint32_t expected_values[] = {5, 7, 11, 13};
    for (int i = 20; i <= 23; i++) {  // r0 to r3: offsets are 20, 21, 22, 23
        uint32_t value = *IO_PTR(MATRIX_CONVOLUTION_BASE, i * 4);
        printf("DEBUG: Read r%d = %d at address 0x%08X (Expected: %d)\n", i - 20, value, MATRIX_CONVOLUTION_BASE + (i * 4), expected_values[i - 20]);
    }
    printf("INFO: Output matrix read successfully.\n");
}

// Function to calculate the time difference in seconds
double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

// Function to print the current system time
void print_current_time() {
    time_t now = time(NULL);
    struct tm *local_time = localtime(&now);
    printf("CURRENT TIME: %02d:%02d:%02d\n",
           local_time->tm_hour,
           local_time->tm_min,
           local_time->tm_sec);
}
