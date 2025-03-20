module matrix_convolution(
    input logic clk,
    input logic reset,
    input logic start,
    input logic [31:0] input_matrix_0, input_matrix_1, input_matrix_2,
    input logic [31:0] input_matrix_3, input_matrix_4, input_matrix_5,
    input logic [31:0] input_matrix_6, input_matrix_7, input_matrix_8,
    output logic done,
    output logic [31:0] output_matrix_0, output_matrix_1,
    output logic [31:0] output_matrix_2, output_matrix_3
);

    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        COMPUTE,
        DONE
    } state_t;

    state_t current_state, next_state;
    logic [31:0] sum;
    int i, j;

    logic [31:0] input_matrix [0:8];
    assign input_matrix = '{input_matrix_0, input_matrix_1, input_matrix_2,
                            input_matrix_3, input_matrix_4, input_matrix_5,
                            input_matrix_6, input_matrix_7, input_matrix_8};

    logic [31:0] output_matrix [0:3];

    // Hardcoded kernel matrix computation
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            i <= 0;
            j <= 0;
            sum <= 0;
        end else begin
            current_state <= next_state;

            if (current_state == COMPUTE) begin
                sum = 0; // Ensure sum is reset for every computation
                if (i == 0 && j == 0) begin
                    sum = input_matrix[0] * 1 + input_matrix[1] * 0 + input_matrix[3] * 1 + input_matrix[4] * 0;
                    
                end
                else if (i == 0 && j == 1) begin
                    sum = input_matrix[1] * 1 + input_matrix[2] * 0 + input_matrix[4] * 1 + input_matrix[5] * 0;
                    $display("Kernel applied to input_matrix[1,2,4,5]: %0d %0d %0d %0d", input_matrix[1], input_matrix[2], input_matrix[4], input_matrix[5]);
                end
                else if (i == 1 && j == 0) begin
                    sum = input_matrix[3] * 1 + input_matrix[4] * 0 + input_matrix[6] * 1 + input_matrix[7] * 0;
                    $display("Kernel applied to input_matrix[3,4,6,7]: %0d %0d %0d %0d", input_matrix[3], input_matrix[4], input_matrix[6], input_matrix[7]);
                end
                else if (i == 1 && j == 1) begin
                    sum = input_matrix[4] * 1 + input_matrix[5] * 0 + input_matrix[7] * 1 + input_matrix[8] * 0;
                    $display("Kernel applied to input_matrix[4,5,7,8]: %0d %0d %0d %0d", input_matrix[4], input_matrix[5], input_matrix[7], input_matrix[8]);
                end

                $display("Computed sum for output_matrix[%0d]: %0d", i * 2 + j, sum);
                output_matrix[i * 2 + j] <= sum;

                if (j < 1) begin
                    j <= j + 1;
                end else begin
                    j <= 0;
                    i <= i + 1;
                end
            end
        end
    end

    always_comb begin
        output_matrix_0 = output_matrix[0];
        output_matrix_1 = output_matrix[1];
        output_matrix_2 = output_matrix[2];
        output_matrix_3 = output_matrix[3];

        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: if (start) next_state = LOAD;
            LOAD: next_state = COMPUTE;
            COMPUTE: if (i == 1 && j == 1) next_state = DONE;
            DONE: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end
endmodule


