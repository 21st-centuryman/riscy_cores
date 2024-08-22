/*
  ALU: Math
*/

module alu (
    // Inputs
    input         [ 3:0] ALUControl,
    input  signed [31:0] rs1,
    rs2,
    // Outputs
    output logic  [31:0] rd,
    // Flags
    output logic  [ 3:0] flags
);

  always_comb begin
    logic [31:0] result = 0;
    logic carry = 0;

    flags = 4'h0;


    case (ALUControl)
      4'b0000: result = (rs1 + rs2);  // ADD
      4'b1000: result = (rs1 - rs2);  // SUB
      4'b0001: result = rs1 << rs2;  // SLL
      4'b0010: result = {31'b0, rs1 < rs2};  // SLT
      4'b0011: result = {31'b0, $unsigned(rs1) < $unsigned(rs2)};  // SLTU
      4'b0100: result = rs1 ^ rs2;  // XOR
      4'b0101: result = rs1 >> rs2;  // SRL
      4'b1101: result = rs1 >>> rs2;  // SRA
      4'b0110: result = rs1 | rs2;  // OR
      4'b0111: result = rs1 & rs2;  // AND
      default: $display("Error: Invalid ALUControl combination");
    endcase


    carry = (rs1[31] & rs2[31]) | (rs1[31] & ~result[31]) | (rs2[31] & ~result[31]);
    flags = {result[31], (result == '0), carry, ((rs1[31] ^ rs2[31]) & (result[31] ^ carry))};

    rd = result[31:0];
  end
endmodule
