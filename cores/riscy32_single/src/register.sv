/*
Registers
*/
module register (
    // Inputs
    input             clk,
    we3,
    done,
    input      [ 4:0] a1,
    a2,
    a3,
    input      [31:0] wd3,
    // Outputs
    output reg [31:0] rd1,
    rd2
);
  reg [31:0] registers[32];  // 32 registers, each 32 bits wide

  initial begin  // Initialize registers to zero
    for (int i = 0; i < 32; i++) registers[i] = 32'b0;
  end

  // Later we will add registers for the return, pointers etc.
  always_ff @(posedge clk) begin
    if (we3 && a3 != 5'b00000) registers[rd1] <= wd3;
  end

  always_comb begin
    rd1 = registers[a1];
    rd2 = registers[a2];
  end

  always_ff @(posedge clk && done) begin  // This stuff will be added in a dfferent place later
    for (int i = 0; i < 32; i++) $display("%d", registers[i]);  // Print registers at program ending
  end
endmodule
