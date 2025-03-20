// Matrix Convolution for a 3x3 Input Matrix
// Computes a 2x2 output matrix using a hardcoded kernel matrix
// Kernel = [1, 0; 1, 0] (applied for each window)

module matrix_convolution(
    input logic clk,                      
    input logic reset,                       
    input logic start,                       
    input logic [31:0] input_matrix_0, input_matrix_1, input_matrix_2, // 3x3 Input matrix elements as 32-bit inputs
    input logic [31:0] input_matrix_3, input_matrix_4, input_matrix_5,
    input logic [31:0] input_matrix_6, input_matrix_7, input_matrix_8,
    output logic done,
    output logic [31:0] output_matrix_0, output_matrix_1,      // 2x2 Output matrix elements as 32-bit outputs
    output logic [31:0] output_matrix_2, output_matrix_3
);

    // State machine
    typedef enum logic [1:0] {
        IDLE,       // Idle state: waiting for the start signal
        LOAD,       // Load state: initializes the input matrix elements
        COMPUTE,    // Compute state: performs the convolution
        DONE        // Done state: indicates completion
    } state_t;

    state_t current_state, next_state;  // State registers

    logic [31:0] sum;                         
    int i, j;                                 

    logic [31:0] input_matrix [0:8];
    assign input_matrix = '{input_matrix_0, input_matrix_1, input_matrix_2,
                            input_matrix_3, input_matrix_4, input_matrix_5,
                            input_matrix_6, input_matrix_7, input_matrix_8};

    logic [31:0] output_matrix [0:3];

    // State and computation control logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all values to initial state
            current_state <= IDLE;
            i <= 0;            
            j <= 0;            
            sum <= 0;          
        end else begin
            current_state <= next_state; 

            // Performs computation 
            if (current_state == COMPUTE) begin
                sum = 0; 

                if (i == 0 && j == 0) begin
                    
                    sum = input_matrix[0] * 1 + input_matrix[1] * 0 +
                          input_matrix[3] * 1 + input_matrix[4] * 0;
                end else if (i == 0 && j == 1) begin
                    
                    sum = input_matrix[1] * 1 + input_matrix[2] * 0 +
                          input_matrix[4] * 1 + input_matrix[5] * 0;
                end else if (i == 1 && j == 0) begin
                    
                    sum = input_matrix[3] * 1 + input_matrix[4] * 0 +
                          input_matrix[6] * 1 + input_matrix[7] * 0;
                end else if (i == 1 && j == 1) begin
                    
                    sum = input_matrix[4] * 1 + input_matrix[5] * 0 +
                          input_matrix[7] * 1 + input_matrix[8] * 0;
                end

                // Store result into the output matrix
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

    // Next-state logic
    always_comb begin
        output_matrix_0 = output_matrix[0];
        output_matrix_1 = output_matrix[1];
        output_matrix_2 = output_matrix[2];
        output_matrix_3 = output_matrix[3];

        next_state = current_state;
        done = 0;

        // State machine transitions
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
            end
            LOAD: begin
                next_state = COMPUTE;
            end
            COMPUTE: begin
                if (i == 1 && j == 1)
                    next_state = DONE;
            end
            DONE: begin
                done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
