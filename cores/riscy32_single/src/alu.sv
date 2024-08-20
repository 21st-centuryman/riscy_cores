/*
  ALU: Math
*/

module alu (
    // Inputs
    input      [ 3:0] ALUControl,
    input      [31:0] rs1,
    rs2,
    // Outputs
    output reg [31:0] rd,
    // Flags
    output     [ 3:0] flags
);
  logic [31:0] result;
  logic zero, sign, carry, overflow;

  always_comb begin
    logic carry_temp = 0;
    case (ALUControl)
      4'b0000: {carry_temp, result} = (rs1 + rs2);  // ADD
      4'b1000: {carry_temp, result} = (rs1 - rs2);  // SUB
      4'b0001: result = rs1 << rs2;  // SLL
      4'b0010: result = {31'b0, rs1 < rs2};  // SLT
      4'b0011: result = {31'b0, $unsigned(rs1) < $unsigned(rs2)};  // SLTU
      4'b0100: result = (rs1 ^ rs2);  // XOR
      4'b0101: result = (rs1 >> rs2);  // SRL
      4'b1101: result = (rs1 >>> rs2);  // SRA
      4'b0110: result = (rs1 | rs2);  // OR
      4'b0111: result = (rs1 & rs2);  // AND
      default: $display("Error: Invalid ALUControl combination");
    endcase

    rd = result;
    zero = (result == '0);
    sign = result[31];
    carry = carry_temp;

    // Make the overflow cleaner
    case (ALUControl)
      4'b0000: overflow = (rs1[31] == rs2[31]) && (rs1[31] != result[31]);
      4'b0001: overflow = ((rs1[31] != rs2[31]) && (rs1[31] != result[31]));
      default: overflow = 0;
    endcase

    flags = {sign, zero, carry, overflow};
  end
endmodule
