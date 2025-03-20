module matrix_convolution_avalon_interface (// Signals for Avalon-MM slave port “s1” with irq
csi_clockreset_clk, //clockreset clock interface
csi_clockreset_reset_n,//clockreset clock interface
avs_s1_address,//s1 slave interface
avs_s1_read, //s1 slave interface
avs_s1_write,  //s1 slave interface
avs_s1_writedata, //s1 slave interface
avs_s1_readdata //s1 slave interface
//ins_irq0_irq; //irq0 port interrupt sender interface
 );

 input csi_clockreset_clk; 
 input csi_clockreset_reset_n;
 input [7:0] avs_s1_address;
 input avs_s1_read;input avs_s1_write;
 input [31:0] avs_s1_writedata;
 output reg [31:0] avs_s1_readdata;
 //output ins_irq0_irq;
 
/* Insert your logic here */
    matrix_convolution dut (
        .clk(csi_clockreset_clk),
        .reset(~csi_clockreset_reset_n),
        .start(x), // Assuming start[0] is the start signal
        .input_matrix_0(a0),
        .input_matrix_1(a1),
        .input_matrix_2(a2),
        .input_matrix_3(a3),
        .input_matrix_4(a4),
        .input_matrix_5(a5),
        .input_matrix_6(a6),
        .input_matrix_7(a7),
        .input_matrix_8(a8),
        .done(y), // Assuming status[0] indicates done
        .output_matrix_0(r0),
        .output_matrix_1(r1),
        .output_matrix_2(r2),
        .output_matrix_3(r3)
    );
// Input logic captures values from the bus at offsets 0,4, 8  from the base address
// using the provided slave address 
reg [31:0] a0,a1,a2, a3, a4, a5, a6, a7, a8, control,status,r0,r1,r2,r3;
reg x,y;
always @(posedge csi_clockreset_clk) begin
  if (csi_clockreset_reset_n==0) begin
    a0 <= 0; a1 <= 0; a2 <= 0; a3 <= 0; a4 <= 0;a5 <= 0; a6 <= 0; a7 <= 0; a8 <= 0; 
  end else if (avs_s1_write) begin
    case (avs_s1_address)
      0: a0<=avs_s1_writedata;
      1: a1<=avs_s1_writedata;
      2: a2<=avs_s1_writedata;
      3: a3<=avs_s1_writedata;
      4: a4<=avs_s1_writedata;
      5: a5<=avs_s1_writedata;
      6: a6<=avs_s1_writedata;
      7: a7<=avs_s1_writedata;
      8: a8<=avs_s1_writedata;
      9: x<=avs_s1_writedata;
      10:control<=avs_s1_writedata;
    endcase
  end    
end


// dummy_logic for control and status
// The status confirms the control value by repeating the value
// The delay through a pipeline of registers serves no purpose other than for demonstration
// If you use the component with the embedded processor you would be able to observe the delay
// You will not be able to observe this through the terminal...
//    you would need to add more delay stages
reg [31:0] dummy_delay [30:0];
always @(posedge csi_clockreset_clk) begin: dummy_logic
  integer i;
  dummy_delay[0]<=control;
  for (i=1;i<=29;i=i+1) begin 
    dummy_delay[i]<=dummy_delay[i-1];
    status<=dummy_delay[29];
  end
end


// Output logic returns values based on the offset from the base address, 
//  offsets 0,4, and 12  are valid here
// using the provided slave address 

always @(*) begin//avs_s1_readdata = 32'hf0f0f0f0;
  case (avs_s1_address)
   20: avs_s1_readdata = r0;
   21: avs_s1_readdata = r1;
   22: avs_s1_readdata = r2;
   23: avs_s1_readdata = r3;
   24: avs_s1_readdata = y;
   25: avs_s1_readdata = status;
  endcase
end

endmodule

