/*
RAM: single cycle implementation
*/

module memory (
    // Inputs
    input             clk,
    write_enable,
    input      [31:0] address,
    input      [31:0] data_in,
    // Outputs
    output reg [31:0] data_out
);
  logic [31:0] mem[2**12:0];  // 16KB memory with 32-bit words

  always_ff @(posedge clk) if (write_enable) mem[address] <= data_in;

  assign data_out = mem[address];
endmodule
