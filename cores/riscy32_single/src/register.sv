/*
Registers
*/
module register (
    // Inputs
    input             clk,
    we3,
    input      [ 4:0] a1,
    a2,
    a3,
    input      [31:0] wd3,
    // Outputs
    output reg [31:0] rd1,
    rd2
);
  logic [31:0] rf[31:0];  // 32 registers, each 32 bits wide

  // Later we will add registers for the return, pointers, zero etc.
  always_ff @(posedge clk) if (we3) rf[a3] <= wd3;

  assign rd1 = (a1 != 0) ? rf[a1] : 0;
  assign rd2 = (a2 != 0) ? rf[a2] : 0;

endmodule
