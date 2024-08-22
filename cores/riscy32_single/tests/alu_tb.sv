/*
ALU Test bench
*/
module alu_tb ();
  logic [31:0] a, b, out;
  logic [3:0] ALUControl;
  logic [3:0] flags;

  alu dut (
      .rs1(a),
      .rs2(b),
      .rd(out),
      .flags(flags),
      .ALUControl(ALUControl)
  );

  logic [31:0] max = 4294967295;  // 2 ^ 31 -1

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, a, b, out, ALUControl, flags);

    ALUControl = 4'b0000;  // ADD
    a = 20;
    b = 30;
    #1;
    assert (out == (a + b))  // 20 + 30 = 50
    else $error("ADD: is broken");

    ALUControl = 4'b1000;  // SUB
    a = 8;
    b = 3;
    #1;
    assert (out == (a - b))  // 8-3 = 5
    else $error("SUB: is broken");

    ALUControl = 4'b0001;  // SLL
    a = 27;
    b = 4;
    #1;
    assert (out == (a << b))
    else $error("SLL: is broken");

    ALUControl = 4'b0010;  // SLT
    a = 8;
    b = 3;
    #1;
    assert (out == {31'b0, a < b})
    else $error("SLT: is broken");

    ALUControl = 4'b0011;  // SLTU
    a = 8;
    b = 3;
    #1;
    assert (out == {31'b0, $unsigned(a) < $unsigned(b)})
    else $error("SLTU: is broken");

    ALUControl = 4'b0100;  // XOR
    a = 10;
    b = 5;
    #1;
    assert (out == (a ^ b))  // 10 ^ 5 = 15
    else $error("XOR: is broken");

    ALUControl = 4'b0101;  // SRL
    a = 8;
    b = 3;
    #1;
    assert (out == (a >> b))
    else $error("SRL: is broken");

    ALUControl = 4'b1101;  // SRA
    a = 8;
    b = 3;
    #1;
    assert (out == (a >> b))
    else $error("SRA: is broken");

    ALUControl = 4'b0110;  // OR
    a = 20;
    b = 30;
    #1;
    assert (out == (a | b))
    else $error("OR: is broken");

    ALUControl = 4'b0111;  // AND
    a = 20;
    b = 30;
    #1;
    assert (out == (a & b))
    else $error("AND: is broken");

    // -----------------------------
    // FLAGS
    // -----------------------------
    ALUControl = 4'b0000;  // ADD
    a = max;
    b = 1;
    #1;
    assert (flags[0])
    else $error("Overflow pos flag is broken");

    ALUControl = 4'b1000;  // SUB
    a = -(max);
    b = max;
    #1;
    assert (flags[0])
    else $error("Overflow neg flag is broken");

    ALUControl = 4'b0000;  // ADD
    a = max;
    b = 1;
    #2;
    assert (flags[1])
    else $error("Carry flag is broken");

    ALUControl = 4'b1000;  // SUB
    a = 20;
    b = 20;
    #2;
    assert (flags[2])
    else $error("Zero flag is broken");

    ALUControl = 4'b1000;  // SUB
    a = 20;
    b = 30;
    #2;
    assert (!flags[2])
    else $error("Zero flag is broken");

    ALUControl = 4'b1000;  // SUB
    a = -2;
    b = 30;
    #2;
    assert (flags[3])
    else $error("Sign flag is broken");

    ALUControl = 4'b0000;  // SUB
    a = -20;
    b = 30;
    #2;
    assert (!flags[3])
    else $error("Sign flag is broken");
    #2;
    $finish;
  end
endmodule
