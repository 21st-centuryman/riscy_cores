/*
Program counter
*/
module pc (
    input clk,
    input [31:0] next_pc,
    output [31:0] pc
);
  reg [31:0] current_pc;
  always_ff @(posedge clk) current_pc <= next_pc;
  assign pc = current_pc;
endmodule

