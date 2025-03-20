module sliding_window_convolution (
    input  logic         clk,
    input  logic         reset,
    input  logic         write,
    input  logic         read,
    input  logic [31:0]   data_in,
    output logic [31:0]  data_out,
    output logic         done
);

    // Parameters for matrix and kernel dimensions
    parameter INPUT_SIZE = 5;
    parameter KERNEL_SIZE = 3;
    parameter OUTPUT_SIZE = INPUT_SIZE - KERNEL_SIZE + 1;

    // Internal storage for input matrix and kernel
    logic [31:0] input_matrix[0:INPUT_SIZE-1][0:INPUT_SIZE-1];
    logic [31:0] kernel[0:KERNEL_SIZE-1][0:KERNEL_SIZE-1];
    logic [31:0] output_matrix[0:OUTPUT_SIZE-1][0:OUTPUT_SIZE-1];

    // Indices and sum
    logic [3:0] row, col, read_row, read_col;
    logic [31:0] sum;

    // State machine states
    typedef enum logic [2:0] {IDLE, WRITE_MATRIX, COMPUTE, READ_OUTPUT, DONE} state_t;
    state_t state, next_state;

    // Kernel initialization
    initial begin
        kernel[0][0] = 1; kernel[0][1] = 0; kernel[0][2] = 1;
        kernel[1][0] = 1; kernel[1][1] = 0; kernel[1][2] = 1;
        kernel[2][0] = 1; kernel[2][1] = 0; kernel[2][2] = 1;
    end

    // State machine logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            row <= 0;
            col <= 0;
            read_row <= 0;
            read_col <= 0;
            sum <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (write) begin
                        row <= 0;
                        col <= 0;
                    end
                end

                WRITE_MATRIX: begin
                    if (write) begin
                        input_matrix[row][col] <= data_in;
                        if (col == INPUT_SIZE - 1) begin
                            col <= 0;
                            if (row == INPUT_SIZE - 1) row <= 0;
                            else row <= row + 1;
                        end else begin
                            col <= col + 1;
                        end
                    end
                end

                COMPUTE: begin
                    sum = 0;
                    for (int i = 0; i < KERNEL_SIZE; i++) begin
                        for (int j = 0; j < KERNEL_SIZE; j++) begin
                            sum += input_matrix[row + i][col + j] * kernel[i][j];
                        end
                    end
                    output_matrix[row][col] <= sum;
                    if (col == OUTPUT_SIZE - 1) begin
                        col <= 0;
                        if (row == OUTPUT_SIZE - 1) done <= 1;
                        else row <= row + 1;
                    end else begin
                        col <= col + 1;
                    end
                end

                READ_OUTPUT: begin
                    if (read) begin
                        data_out <= output_matrix[read_row][read_col];
                        if (read_col == OUTPUT_SIZE - 1) begin
                            read_col <= 0;
                            if (read_row == OUTPUT_SIZE - 1) begin
                                read_row <= 0;
                                done <= 1;
                            end else read_row <= read_row + 1;
                        end else read_col <= read_col + 1;
                    end
                end

                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: next_state = write ? WRITE_MATRIX : IDLE;
            WRITE_MATRIX: next_state = (row == INPUT_SIZE - 1 && col == INPUT_SIZE - 1) ? COMPUTE : WRITE_MATRIX;
            COMPUTE: next_state = (row == OUTPUT_SIZE - 1 && col == OUTPUT_SIZE - 1) ? READ_OUTPUT : COMPUTE;
            READ_OUTPUT: next_state = (read_row == OUTPUT_SIZE - 1 && read_col == OUTPUT_SIZE - 1 && done) ? DONE : READ_OUTPUT;
            DONE: next_state = IDLE;
        endcase
    end
endmodule
