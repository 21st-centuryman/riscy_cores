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
  reg [31:0] mem[2**32];  // 4GB memory with 32-bit words

  always_ff @(posedge clk) begin : Memory
    if (write_enable) mem[address] <= data_in;
    else data_out <= mem[address];
  end
endmodule
