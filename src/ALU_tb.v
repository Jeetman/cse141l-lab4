`timescale 1ns/ 1ps



//Test bench
//Arithmetic Logic Unit
/*
* INPUT: A, B
* op: 00, A PLUS B
* op: 01, A AND B
* op: 10, A OR B
* op: 11, A XOR B
* OUTPUT A op B
* equal: is A == B?
* even: is the output even?
*/


module ALU_tb;
reg [ 7:0] INPUTA;     	  // data inputs
reg [ 7:0] INPUTB;
reg [ 3:0] op;		// ALU opcode, part of microcode
wire[ 7:0] OUT;		  
wire Zero;    
 
reg [7:0] expected;
reg expected_zero;
 
// CONNECTION
ALU uut(
  .InputA(INPUTA),      	  
  .InputB(INPUTB),
  .OP(op),				  
  .Out(OUT),		  			
  .Zero(Zero)
);
	 
initial begin


  // == Begin testing separate opcodes ==

  // ADD 0000
  //
  // test case 1: add two unsigned values
  // expected output 8'b00000010
	INPUTA = 8'b00000001;
	INPUTB = 8'b00000001; 
	op= 4'b0000; // AND
	test_alu_func; // void function call
	#5;
  // test case 2: add two's complement values (hidden to ALU)
  // expected output 8'b00000001
  INPUTA = 8'b11111111; // 1
  INPUTB = 8'b00000010; // 2
	test_alu_func; // void function call
	#5;


  // LSL 0001
  // test case 1: shift 
  // expected output 8'b00000010
	INPUTA = 8'b00000001;
	INPUTB = 8'b00000001; 
	op= 4'b0001; // LSL 
	test_alu_func; // void function call
	#5;

  
  // LSR 0010
  // test case 1: shift unsigned to the right
  // expected output 8'b00000001
	INPUTA = 8'b00000010;
	INPUTB = 8'b00000001; 
	op= 4'b0010; // LSR 
	test_alu_func; // void function call
	#5;


  // AND 0011
  // expected output 8'b00000010
	INPUTA = 8'b00000010;
	INPUTB = 8'b00000010; 
	op= 4'b0011; // AND 
	test_alu_func; // void function call
	#5;


  // OR  0100
  // expected output 8'b10000011
	INPUTA = 8'b10000001;
	INPUTB = 8'b10000010; 
	op= 4'b0100; // OR 
	test_alu_func; // void function call
	#5;


  // XOR 0101
  // expected output 8'b00000011
	INPUTA = 8'b10000001;
	INPUTB = 8'b10000010; 
	op= 4'b0101; // XOR 
	test_alu_func; // void function call
	#5;


  // SLT 0110
  // test case 1: set zero bit if input A < input B
  // expected zero bit: 1
	INPUTA = 8'b00000001;
	INPUTB = 8'b00000010; 
	op= 4'b0110; // SLT
	test_alu_func; // void function call
	#5;

  // test case 2: zero bit unset when input A !< input B
  // expected zero bit: 0
	INPUTA = 8'b00000010; 
	INPUTB = 8'b00000001;
	op= 4'b0110; // SLT
	test_alu_func; // void function call
	#5;


  // MOV 0111
  // test case 1: output value is inputB
  // expected output: 8'b00000010
	INPUTA = 8'b00000000;
	INPUTB = 8'b00000010; 
	op= 'b0111; // MOV
	test_alu_func; // void function call
	#5;

end
	
	task test_alu_func;
	begin
	  case (op)
		4'b0000: expected = INPUTA + INPUTB;
		4'b0001: expected = INPUTA << INPUTB;
		4'b0010: expected = INPUTA >> INPUTB;
		4'b0011: expected = INPUTA & INPUTB;
		4'b0100: expected = INPUTA | INPUTB;	
		4'b0101: expected = INPUTA ^ INPUTB; // XOR  
		4'b0110: begin // SLT
      if (INPUTA < INPUTB)
      begin
          expected_zero = 1;
		end
	   else
		begin
          expected_zero = 0;
      end
    end
    4'b0111: expected = INPUTB; // MOV
	  endcase

	  #1; 
    if(op != 4'b0110)
    begin
      if(expected == OUT)
        begin
          $display("%t YAY!! inputs = %h %h, opcode = %b, Zero %b",$time, INPUTA,INPUTB,op, Zero);
        end
      else 
        begin 
          $display("%t FAIL! inputs = %h %h, opcode = %b, zero %b",$time, INPUTA,INPUTB,op, Zero);
        end
    end
    else
    begin
      if(expected_zero == Zero)
      begin
          $display("%t YAY!! inputs = %h %h, opcode = %b, Zero %b",$time, INPUTA,INPUTB,op, Zero);
      end
      else 
        begin 
          $display("%t FAIL! inputs = %h %h, opcode = %b, zero %b",$time, INPUTA,INPUTB,op, Zero);
        end
    end
		
	end
	endtask

endmodule
