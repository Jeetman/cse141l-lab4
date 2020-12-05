// CSE141L  Fall 2020
// test bench to be used to verify student projects
// pulses start while loading program 2 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// Based on SystemVerilog source code provided by John Eldon
 
module test_bench_2();


  reg      clk   = 1'b0   ;      // advances simulation step-by-step
  reg      init  = 1'b1   ;      // init (reset) command to DUT
  reg      start = 1'b1   ;      // req (start program) command to DUT
  wire     done           ;      // done flag returned by DUT
  
// ***** instantiate your top level design here *****
  CPU dut(
    .Clk     (clk  ),   // input: use your own port names, if different
    .Reset   (init ),   // input: some prefer to call this ".reset"
    .Start   (start),   // input: launch program
    .Ack     (done )    // output: "program run complete"
  );


// program 1 variables
reg[63:0] dividend;     // fixed for pgm 1 at 64'h8000_0000_0000_0000;
reg[63:0] quotient1;	   // internal wide-precision result
real quotientR;			// quotient in $real format


// program 2 variables
reg[15:0] div_in2;	   // dividend 2 to DUT
reg[ 7:0] divisor2;	   // divisor 2 to DUT
reg[23:0] result2,	   // desired final result, rounded to 24 bits
          result2_DUT;  // actual result from DUT
			
// clock -- controls all timing, data flow in hardware and test bench
always begin
       clk = 0; #5;
		 clk = 1; #5;
end

initial begin

// preload operands and launch program 2
  #10; start = 1;	init = 0;
// The test below is calculating 3/255
// insert dividend and divisor
//  div_in2 = 3;	   	// *** try various values here ***
//  divisor2 = 255;	   // *** try various values here ***
  div_in2 = 65535;
  divisor2 = 128;
// *** change names of memory or its guts as needed ***
  dut.DM1.Core[0] = div_in2[15:8];
  dut.DM1.Core[1] = div_in2[ 7:0];
  dut.DM1.Core[2] = divisor2;
  if(divisor2) div2; 							             // divisor2 is "true" only if nonzero
  else result2 = {24{1'b1}};                           // same as program 1: limit to max.
  #20; start = 0;
  #20; wait(done);
// *** change names of memory or its guts as needed ***
  result2_DUT[23:16] = dut.DM1.Core[4];
  result2_DUT[15: 8] = dut.DM1.Core[5];
  result2_DUT[ 7: 0] = dut.DM1.Core[6];
  $display ("dividend = %h, divisor2 = %h, quotient = %h, result2 = %h, equiv to %10.5f",
    dividend, divisor2, quotient1, result2, quotientR); 
  if(result2==result2_DUT) $display("success -- match2");
  else $display("OOPS2! expected %h, got %h",result2,result2_DUT); 
  #10;
  $stop;
end

task automatic div2;
begin
  dividend = div_in2<<48;
  quotient1 = dividend/divisor2;
  result2 = quotient1[63:40]+quotient1[39]; // half-LSB upward rounding (Uncomment this line to use rounding)
  //result2 = quotient1[63:40];                 // No rounding
  quotientR = $itor(div_in2)/$itor(divisor2);
end
endtask

endmodule