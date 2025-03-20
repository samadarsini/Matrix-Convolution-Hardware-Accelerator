// Testbench for module of 3x3 Matrix convolution
module tb_matrix_convolution;
    // Signals declaration
    logic clk;
    logic reset;
    logic start;
    logic [31:0] input_matrix_0, input_matrix_1, input_matrix_2;
    logic [31:0] input_matrix_3, input_matrix_4, input_matrix_5;
    logic [31:0] input_matrix_6, input_matrix_7, input_matrix_8;

    logic done;
    logic [31:0] output_matrix_0, output_matrix_1;
    logic [31:0] output_matrix_2, output_matrix_3;

    // Instantiate the matrix convolution module
    matrix_convolution uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .input_matrix_0(input_matrix_0), .input_matrix_1(input_matrix_1), .input_matrix_2(input_matrix_2),
        .input_matrix_3(input_matrix_3), .input_matrix_4(input_matrix_4), .input_matrix_5(input_matrix_5),
        .input_matrix_6(input_matrix_6), .input_matrix_7(input_matrix_7), .input_matrix_8(input_matrix_8),
        .done(done),
        .output_matrix_0(output_matrix_0), .output_matrix_1(output_matrix_1),
        .output_matrix_2(output_matrix_2), .output_matrix_3(output_matrix_3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Stimulus block
    initial begin
        $dumpfile("waveform.vcd");  // Create a waveform file
        $dumpvars(0, tb_matrix_convolution); // Dump all variables in the testbench

        reset = 1;         // Apply reset
        start = 0;         // Start signal inactive
        #10 reset = 0;     // De-assert reset after 10 ns

        // Initialize input matrix
        input_matrix_0 = 1; input_matrix_1 = 2; input_matrix_2 = 3;
        input_matrix_3 = 4; input_matrix_4 = 5; input_matrix_5 = 6;
        input_matrix_6 = 7; input_matrix_7 = 8; input_matrix_8 = 9;

        // Start the convolution
        start = 1;
        #10 start = 0;

        // Wait for the done signal
        wait(done);

        // Display the output matrix
        $display("Output Matrix:");
        $display("%d %d", output_matrix_0, output_matrix_1);
        $display("%d %d", output_matrix_2, output_matrix_3);
        #10
        // Finish simulation
        $stop;
    end
endmodule
