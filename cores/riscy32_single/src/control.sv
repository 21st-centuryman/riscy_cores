/*
  Controller
*/

module control (
    // Inputs
    input        [6:0] op,
    input        [2:0] funct3,
    input              funct7,
    // Flags
    input        [3:0] flags,
    // Outputs
    output logic       RegWrite,
    ALUSrc,
    MemWrite,
    PCSrc,
    output logic [1:0] ImmSrc,
    ResultSrc,
    output logic [3:0] ALUControl
);

  logic Branch, Jump, BranchSrc;

  always_latch begin
    case (op)
      7'b0110011: begin  // R-Type
        RegWrite = 1;
        ImmSrc = 'x;
        ALUSrc = 0;
        MemWrite = 0;
        ResultSrc = 2'b00;
        Branch = 0;
        ALUControl = {funct7, funct3};
        Jump = 0;
      end

      7'b0010011: begin  // I-type Arithmetic
        RegWrite = 1;
        ImmSrc = 2'b00;
        ALUSrc = 1;
        MemWrite = 0;
        ResultSrc = 2'b00;
        Branch = 0;
        if (funct3 == 3'h5 || funct3 == 3'h1) begin
          ALUControl = {funct7, funct3};
        end else begin
          ALUControl = {1'b0, funct3};
        end
        Jump = 0;
      end

      7'b0000011: begin  // I-type load
        RegWrite = 1;
        ImmSrc = 2'b00;
        ALUSrc = 1;
        MemWrite = 0;
        ResultSrc = 2'b01;
        Branch = 0;
        ALUControl = 4'h0;
        Jump = 0;
      end

      7'b0100011: begin  // S-type
        RegWrite = 0;
        ImmSrc = 2'b01;
        ALUSrc = 1;
        MemWrite = 1;
        ResultSrc = 'x;
        Branch = 1;
        ALUControl = 4'h0;
        Jump = 0;
      end

      7'b1100011: begin  // B-type
        RegWrite = 0;
        ImmSrc = 2'b01;
        ALUSrc = 1;
        MemWrite = 1;
        ResultSrc = 'x;
        Branch = 1;
        ALUControl = 4'h8;
        Jump = 0;
      end

      7'b1101111: begin  // jal
        RegWrite = 1;
        ImmSrc = 2'b11;
        ALUSrc = 'x;
        MemWrite = 0;
        ResultSrc = 2'b10;
        Branch = 0;
        ALUControl = 'x;
        Jump = 1;
      end

      7'b1100111: begin  // jalr implement later
      end

      7'b0110111: begin  // U-type: lui
        RegWrite = 1;
        ImmSrc = 2'b10;
        ALUSrc = 0;
        MemWrite = 0;
        ResultSrc = 2'b00;
        Branch = 0;
        ALUControl = 4'h0;
        Jump = 0;
      end

      7'b0010111: begin  //  auipc implement later
      end

      default: begin
        RegWrite = 'x;
        ImmSrc = 'x;
        ALUSrc = 'x;
        MemWrite = 'x;
        ResultSrc = 'x;
        Branch = 'x;
        ALUControl = 'x;
        Jump = 'x;
      end
    endcase

    // Branch Flags
    case (funct3)
      3'h0: BranchSrc = flags[2];  // Beq
      3'h1: BranchSrc = !flags[2];  // Bne
      3'h4: BranchSrc = flags[3] ^ flags[0];  // blt
      3'h5: BranchSrc = !(flags[3] ^ flags[0]);  // bge
      3'h6: BranchSrc = !flags[1];  // bltu
      3'h7: BranchSrc = flags[1];  // bgeu
      default: BranchSrc = 0;
    endcase
    PCSrc = Jump || (Branch & BranchSrc);

  end
endmodule
