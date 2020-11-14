//-----------------------------------------------
// Module name: counter.v
// Function: Simple counter module
//-----------------------------------------------

module counter (

  PARAMETER WIDTH=8;
  input clk, inc_en, wrt_en, rst;
  input [WIDTH-1:0] data_in;

  output [WIDTH-1:0] data_out;

  always @(posedge clk) begin
    if (inc_en == 1'b1)
      data_out <= data_out + 1;
    if (rst == 1'b0)
      data_out <= 0;
  end

endmodule
