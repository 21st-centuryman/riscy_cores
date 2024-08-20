/*
CPU: yes its all coming together
*/
module cpu (
    // Inputs
    input clk,
    input len,  // Size of program
    input [31:0] instructions[len]
);

  // Control signals
  logic RegWrite, ALUSrc, MemWrite, PCSrc;
  logic [1:0] ImmSrc, ResultSrc;
  logic [3:0] ALUControl;
  // Fetch stage
  logic [31:0] pc, pc_plus, pc_next;
  // Decode stage
  logic [31:0] instruction;
  logic [31:0] SrcA, WriteData, ImmExt;
  // Execute stage
  logic [31:0] pc_target, SrcB;
  logic [31:0] ALUResult;
  logic [ 3:0] flags;
  // Memory stage
  logic [31:0] ReadData, Result;

  always_comb begin : DataPath
    if (instruction[6:0] == 7'b1110011 || pc == $size(len)) begin  // ecall, basically end
      logic done = 1;
    end else begin
      logic done = 0;
      pc_plus = pc + 1;
      instruction = instruction[pc];
      case (ImmSrc)
        2'b00: ImmExt = {{20{instruction[31]}}, instruction[31:20]};  // I-type
        2'b01: ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};  // S-type
        2'b10:
        ImmExt = {
          {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0
        };  // B-type
        2'b11:
        ImmExt = {
          {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0
        };  // J-type
        default: ImmExt = 'x;  // Default case
      endcase
      SrcB = !(ALUSrc) ? WriteData : ImmExt;
      pc_target = pc + ImmExt;
      case (ResultSrc)
        2'b00:   Result = ALUResult;
        2'b10:   Result = ReadData;
        2'b10:   Result = pc_plus;
        default: Result = 'x;
      endcase
      next_pc = !(PCSrc) ? pc_plus : pc_target;
    end
  end

  pc pc (
      .clk(clk),
      .next_pc(next_pc),
      .pc(pc)
  );

  memory memory (
      .clk(clk),
      .write_enable(MemWrite),
      .address(ALUResult),
      .data_in(WriteData),
      .data_out(ReadData)
  );

  register register (
      .done(done),
      .clk (clk),
      .we3 (RegWrite),
      .a1  (instruction[19:15]),
      .a2  (instruction[24:20]),
      .a3  (instruction[11:7]),
      .wd3 (Result),
      .rd1 (SrcA),
      .rd2 (WriteData)
  );

  alu alu (
      .ALUControl(ALUControl),
      .rs1(SrcA),
      .rs2(SrcB),
      .rd(ALUResult),
      .flags(flags)
  );

  control control (
      .instruction(instruction),
      .flags(flags),
      .RegWrite(RegWrite),
      .ALUSrc(ALUSrc),
      .MemWrite(MemWrite),
      .PCSrc(PCSrc),
      .ImmSrc(ImmSrc),
      .ResultSrc(ResultSrc),
      .ALUControl(ALUControl)
  );

endmodule
