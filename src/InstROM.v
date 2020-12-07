// Module Name:    InstROM 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is your Instruction Memory
// At the begin of the program, it reads instructions from machine_code.txt
// Please make sure you have the file ready.
// You may hardcode instruction for debugging purposes. 
// Simply uncomment the commented code and comment the code to read from the text file
// Currently, it supports 2^11 instructions. 11 bits has been hardcoded.
// That should be enough for your 3 programs.



module InstROM (InstAddress, InstOut) ;
  input       [10:0] InstAddress;
  output reg  [8:0]  InstOut;
  //   need $readmemh or $readmemb to initialize all of the elements
  reg[8:0] inst_rom[(2**11)-1:0];
  always@* InstOut = inst_rom[InstAddress];
 
  initial begin		                  // load from external text file
  	$readmemb("C:/Users/kamal/dev/cse141l/lab2/machine_code.txt",inst_rom);
  end 
  
endmodule