module tb_sliding_window_convolution;

    // Testbench signals
    logic clk, reset, write, read;
    logic [31:0] data_in;
    logic [31:0] data_out;
    logic done;

    // Instantiate the design under test (DUT)
    sliding_window_convolution dut (
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Declare the matrix
    int matrix_values[0:4][0:4];

    // Initialize the matrix using an initial block
    initial begin
        matrix_values[0] = '{0, 1, 2, 3, 4};
        matrix_values[1] = '{5, 6, 7, 8, 9};
        matrix_values[2] = '{10, 11, 12, 13, 14};
        matrix_values[3] = '{15, 16, 17, 18, 19};
        matrix_values[4] = '{20, 21, 22, 23, 24};
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset = 1;
        write = 0;
        read = 0;
        data_in = matrix_values[0][0];

        // Apply reset
        #10 reset = 0;

        // Dump waveform
        $dumpfile("sliding_window_convolution.vcd"); // Specify the dump file name
        $dumpvars(0, tb_sliding_window_convolution); // Dump all variables in the module
        
        // Display kernel matrix
        $display("Kernel Matrix:");
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                $write("%0d ", dut.kernel[i][j]);
            end
            $display("");
        end

        // Write the input matrix
        $display("Starting to write input matrix...");
        write = 1;
        #20
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                data_in = matrix_values[i][j]; // Assign values from the specified matrix
                @(posedge clk);
            end
        end
        write = 0;

        // Display the input matrix
        $display("Input Matrix:");
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                $write("%0d ", matrix_values[i][j]);
            end
            $display(""); // Move to the next row
        end

        // Wait for computation to complete
        $display("Waiting for computation...");
        wait(done);
        $display("Computation completed.");

        // Read and display output matrix in 3x3 format
        $display("Output Matrix:");
        read = 1;
        #20
        for (int row = 0; row < 3; row++) begin
            for (int col = 0; col < 3; col++) begin
                @(posedge clk);
                $write("%0d ", data_out);
            end
            $display(""); // Move to the next row
        end
        read = 0;

        // End simulation
        $display("Testbench completed.");
        $finish;
    end
endmodule



/*module tb_sliding_window_convolution;

    // Testbench signals
    logic clk, reset, write, read;
    logic [7:0] data_in;
    logic [15:0] data_out;
    logic done;

    // Instantiate the design under test (DUT)
    sliding_window_convolution dut (
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Declare the matrix
    int matrix_values[0:4][0:4];

    // Initialize the matrix using an initial block
    initial begin
        matrix_values[0] = '{1, 2, 3, 4, 5};
        matrix_values[1] = '{5, 4, 3, 2, 1};
        matrix_values[2] = '{4, 2, 3, 1, 2};
        matrix_values[3] = '{3, 2, 1, 5, 4};
        matrix_values[4] = '{2, 5, 4, 1, 3};
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset = 1;
        write = 0;
        read = 0;
      data_in = matrix_values[0][0];

        // Apply reset
        #10 reset = 0;
       // Display kernel matrix
        $display("Kernel Matrix:");
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                $write("%0d ", dut.kernel[i][j]);
            end
            $display("");
        end


        // Write the input matrix
        $display("Starting to write input matrix...");
        write = 1;
        #20
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                data_in = matrix_values[i][j]; // Assign values from the specified matrix
                @(posedge clk);
            end
        end
        write = 0;

        // Display the input matrix
        $display("Input Matrix:");
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                $write("%0d ", matrix_values[i][j]);
            end
            $display(""); // Move to the next row
        end

        // Wait for computation to complete
        $display("Waiting for computation...");
        wait(done);
        $display("Computation completed.");

        // Read and display output matrix in 3x3 format
        $display("Output Matrix:");
        read = 1;
        #20
        for (int row = 0; row < 3; row++) begin
            for (int col = 0; col < 3; col++) begin
                @(posedge clk);
                $write("%0d ", data_out);
            end
            $display(""); // Move to the next row
        end
        read = 0;

        // End simulation
        $display("Testbench completed.");
        $finish;
    end
endmodule

*/