// Module Name:    InstFetch_tb
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// Test module for instruction fetch functionality

`timescale 1ns/ 1ps

module InstFetch_tb;
  // Simulate InstFetch fields
  reg Reset;
  reg Start;
  reg Clk;
  reg BranchRelEn;
  reg ALU_flag;
  reg          [7:0] Target;
  wire          [7:0] ProgCtr;

  // Compared output
  reg   [7:0] expected;
//);

// CONNECTION
InstFetch uut(
  .Reset(Reset),
  .Start(Start),
  .Clk(Clk),
  .BranchRelEn(BranchRelEn),
  .ALU_flag(ALU_flag),
  .Target(Target),
  .ProgCtr(ProgCtr)
);

  initial begin
    Clk = 0;
    // Useless field. TODO: delete ALU flag from InstFetch
    ALU_flag = 0;
    // == Begin testing separate fetch flags ==
      
    // Test case 1: clear PC to 0
    // expected output: ProgCtr == 11'b00000000000
    Reset = 1;
    Start = 0;
    BranchRelEn = 0;
    Target = 8'b00000000;
    test_instfetch_func;
    #15;

    
    // Test case 2: hold PC while Start is asserted
    // expected output: ProgCtr == 11'b00000000100
    Reset = 0;
    Start = 1;
    BranchRelEn = 0;
    Target = 8'b00000100;
    test_instfetch_func;
    #15;
    

    // Test Case 3: relative jump forwards
    // expected output: ProgCtr == 11b'00000000100
    Reset = 0;
    Start = 0;
    BranchRelEn = 1;
    Target = 8'b00000100; // Offset of 4
    test_instfetch_func;
    #15;
    
    // Test Case 3: relative jump backwards 
    // expected output: ProgCtr == 11b'00000000010
    Reset = 0;
    Start = 0;
    BranchRelEn = 1;
    Target = 8'b11111110; // Offset of -2
    test_instfetch_func;
    #15;
    

    // Test case 4: increment PC following standard instruction
    // expected output: 11'b00000000011
    Reset = 0;
    Start = 0;
    BranchRelEn = 0;
    Target = 8'b00000000;
    test_instfetch_func;
    #15;
  end
  
  always
    #5 Clk = !Clk;

  task test_instfetch_func;
    begin
	 
     if(Reset)
       begin
         expected = 0;
       end
     else if(Start)
       begin
         expected = ProgCtr;
       end
     else if(BranchRelEn)
       begin
         expected = Target + ProgCtr;
       end
     else
       begin
         expected = ProgCtr + 'b1;
       end
    
      #10;
      if (expected == ProgCtr)
        begin
          $display("%t YOU ARE SUCCESS! Reset = %b, Start = %b, BranchRelEn = %b, Target = %b, ProgCtr = %b",$time, Reset, Start, BranchRelEn, Target, ProgCtr);
        end
      else
        begin
          $display("%t Failed! Reset = %b, Start = %b, BranchRelEn = %b, Target = %b, ProgCtr = %b",$time, Reset, Start, BranchRelEn, Target, ProgCtr);
        end
		end
    endtask

endmodule
