// filename: main.c
// Unified base address with incremental offsets for all registers

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
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

int main() {
    void *virtual_base;
    int fd;

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

    // Step 1: Write inputs to the matrix convolution module
    printf("DEBUG: Writing input matrix to FPGA...\n");
    write_input_matrix(virtual_base);

    // Step 2: Start the computation
    printf("DEBUG: Starting computation...\n");
    start_computation(virtual_base);

    // Step 3: Add a basic delay
    printf("DEBUG: Adding delay for computation to complete...\n");
    add_basic_delay();

    // Step 4: Read the output matrix
    printf("DEBUG: Reading output matrix from FPGA...\n");
    read_output_matrix(virtual_base);

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
