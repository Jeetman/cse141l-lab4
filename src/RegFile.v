// Module Name:    RegFile 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is your register file.
// If you have more or less bits for your registers, update the value of D.
// Ex. If you only supports 8 registers. Set D = 3

/* parameters are compile time directives 
       this can be an any-size reg_file: just override the params!
*/
module RegFile (Clk,WriteEn,opsWrite,Waddr,DataIn,DataOutA,DataOutB);
	parameter W=8, D=4;  // W = data path width (Do not change); D = pointer width (You may change)
	input                Clk,
								WriteEn;
	input			 			opsWrite;           //1 means top bits and 0 means bottom bits
	input        [D-1:0] Waddr;
	input        [W-1:0] DataIn;
	output reg   [W-1:0] DataOutA;			  
	output reg   [W-1:0] DataOutB;				

// W bits wide [W-1:0] and 2**4 registers deep 	 
reg [W-1:0] Registers[(2**D)-1:0];	  // or just registers[16-1:0] if we know D=4 always



// NOTE:
// READ is combinational
// WRITE is sequential

always@*
begin
 //read from OPS register 
 DataOutA = Registers[Registers[13][7:4]];	  
 DataOutB = Registers[Registers[13][3:0]];    
end

// sequential (clocked) writes 
always @ (posedge Clk)
  if (WriteEn)
	begin// works just like data_memory writes
		 Registers[Waddr] <= DataIn;
		 //write to ops register
		 if(opsWrite)
			Registers[13][7:4] <= DataIn[3:0];         //write to top 4 bits
		 else 
			Registers[13][3:0] <= DataIn[3:0];         //write to bottom 4 bits
    end
endmodule
