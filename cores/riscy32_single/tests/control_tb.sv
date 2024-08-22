/*
Control Test bench
*/
module control_tb;
  logic [6:0] op;
  logic [3:0] flags;
  logic [2:0] funct3;
  logic RegWrite, ALUSrc, MemWrite, PCSrc, funct7;
  logic [1:0] ImmSrc, ResultSrc;
  logic [3:0] ALUControl;

  control dut (
      .op(op),
      .funct3(funct3),
      .funct7(funct7),
      .flags(flags),
      .RegWrite(RegWrite),
      .ALUSrc(ALUSrc),
      .MemWrite(MemWrite),
      .PCSrc(PCSrc),
      .ImmSrc(ImmSrc),
      .ResultSrc(ResultSrc),
      .ALUControl(ALUControl)
  );

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, control_tb);

    #1;
    // Test R-Type
    op = 7'b0110011;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 1)
    else $error("RegWrite R-Type");
    assert (ALUSrc == 0)
    else $error("ALUSrc R-Type");
    assert (MemWrite == 0)
    else $error("MemWrite R-Type");
    assert (PCSrc == 0)
    else $error("PCSrc: R-Type");
    assert (ImmSrc == 2'b00)
    else $error("ImmSrc R-Type");
    assert (ResultSrc == 2'b00)
    else $error("ResultSrc  R-Type");
    assert (ALUControl == 4'h0)
    else $error("ALUControl R-Type");
    assert (PCSrc == 0)
    else $error("PCSrc R-type");

    #1;
    // Test I-type Arithmetic
    op = 7'b0010011;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 1)
    else $error("RegWrite I-type Arithmetic");
    assert (ALUSrc == 1)
    else $error("ALUSrc I-type Arithmetic");
    assert (MemWrite == 0)
    else $error("MemWrite I-type Arithmetic");
    assert (PCSrc == 0)
    else $error("PCSrc I-type Arithmetic");
    assert (ImmSrc == 2'b00)
    else $error("ImmSrc I-type Arithmetic");
    assert (ResultSrc == 2'b00)
    else $error("ResultSrc I-type Arithmetic");
    assert (ALUControl == 4'h5)
    else $error("ALUControl I-type Arithmetic");
    assert (PCSrc == 0)
    else $error("PCSrc I-type Arithmetic");

    #1;
    // Test I-type Load
    op = 7'b0000011;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 1)
    else $error("RegWrite I-type Load");
    assert (ALUSrc == 1)
    else $error("ALUSrc I-type Load");
    assert (MemWrite == 0)
    else $error("MemWrite I-type Load");
    assert (PCSrc == 0)
    else $error("PCSrc I-type Load");
    assert (ImmSrc == 2'b00)
    else $error("ImmSrc I-type Load");
    assert (ResultSrc == 2'b01)
    else $error("ResultSrc I-type Load");
    assert (ALUControl == 4'h0)
    else $error("ALUControl I-type Load");
    assert (PCSrc == 0)
    else $error("PCSrc I-Type");

    #1;
    // Test S-Type
    op = 7'b0100011;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 0)
    else $error("RegWrite S-Type");
    assert (ALUSrc == 1)
    else $error("ALUSrc S-Type");
    assert (MemWrite == 1)
    else $error("MemWrite S-Type");
    assert (PCSrc == 0)
    else $error("PCSrc: S-Type");
    assert (ImmSrc == 2'b01)
    else $error("ImmSrc S-Type");
    assert (ResultSrc == 'x)
    else $error("ResultSrc  S-Type");
    assert (ALUControl == 4'h0)
    else $error("ALUControl S-Type");
    assert (PCSrc == 0)
    else $error("PCSrc S-Type");

    #1;
    // Test B-Type
    op = 7'b1100011;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 0)
    else $error("RegWrite B-Type");
    assert (ALUSrc == 1)
    else $error("ALUSrc B-Type");
    assert (MemWrite == 1)
    else $error("MemWrite B-Type");
    assert (PCSrc == 0)
    else $error("PCSrc: B-Type");
    assert (ImmSrc == 2'b01)
    else $error("ImmSrc B-Type");
    assert (ResultSrc == 'x)
    else $error("ResultSrc B-Type");
    assert (ALUControl == 4'h8)
    else $error("Branch B-Type");
    assert (PCSrc == 0)
    else $error("PCSrc B-Type");

    #1;
    // Test jal
    op = 7'b1101111;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 1)
    else $error("RegWrite jal");
    assert (ImmSrc == 2'b11)
    else $error("ImmSrc jal");
    assert (ALUSrc == 'x)
    else $error("ALUSrc jal");
    assert (MemWrite == 0)
    else $error("MemWrite jal");
    assert (ResultSrc == 2'b10)
    else $error("ResultSrc jal");
    assert (ALUControl == 'x)
    else $error("ALUControl jal");
    assert (PCSrc == 1)
    else $error("PCSrc jal");

    #1;
    // Test U-Type: lui
    op = 7'b0110111;
    funct3 = 3'h0;
    funct7 = 0;
    flags = 4'b0000;
    assert (RegWrite == 1)
    else $error("RegWrite U-Type: lui");
    assert (ALUSrc == 0)
    else $error("ALUSrc U-Type: lui");
    assert (MemWrite == 0)
    else $error("MemWrite U-Type: lui");
    assert (PCSrc == 0)
    else $error("PCSrc: U-Type: lui");
    assert (ImmSrc == 2'b10)
    else $error("ImmSrc U-Type: lui");
    assert (ResultSrc == 2'b00)
    else $error("ResultSrc U-Type: lui");
    assert (ALUControl == 4'h0)
    else $error("ALUControl U-Type: lui");
    assert (PCSrc == 0)
    else $error("PCSrc B-Type");

    #1;
    // Test Branch Flags
    op = 7'b1100011;
    funct3 = 3'h0;
    funct7 = 1;
    flags = 4'b0000;

    #1;
    // Test Beq
    funct3   = 3'h0;
    flags[2] = 1'b1;
    assert (PCSrc == 1)
    else $error("PCSrc Beq");

    #1;
    // Test Bne
    funct3   = 3'h1;
    flags[2] = 1'b1;
    assert (PCSrc == 0)
    else $error("PCSrc Bne");

    #1;
    // Test Blt
    funct3   = 3'h4;
    flags[3] = 1'b1;
    flags[0] = 1'b0;
    assert (PCSrc == 1)
    else $error("PCSrc Blt");

    #1;
    // Test Bge
    funct3   = 3'h5;
    flags[3] = 1'b1;
    flags[0] = 1'b0;
    assert (PCSrc == 0)
    else $error("PCSrc Bge");

    #1;
    // Test Bltu
    funct3   = 3'h6;
    flags[1] = 1'b0;
    assert (PCSrc == 1)
    else $error("PCSrc Bltu");

    #1;
    // Test Bgeu
    funct3   = 3'h7;
    flags[1] = 1'b0;
    assert (PCSrc == 0)
    else $error("PCSrc Bgeu");

    #1;
    // Test default
    funct3 = 3'h2;
    assert (PCSrc == 0)
    else $error("PCSrc default");

    $finish;
  end
endmodule
