module alu_tb ();
  logic [31:0] a, b, out;
  logic [3:0] ALUControl;
  logic [3:0] flags;

  alu alu (
      .rs1(a),
      .rs2(b),
      .rd(out),
      .flags(flags),
      .ALUControl(ALUControl)
  );

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, a, b, out, flags, ALUControl);

    ALUControl = 4'b0000;  // ADD
    a = 20;
    b = 30;
    assert (out == (a + b))
    else $error("ADD: is broken");

    #1;
    ALUControl = 4'b1000;  // SUB
    a = 8;
    b = 3;
    assert (out == (a - b))
    else $error("SUB: is broken");

    #1;
    ALUControl = 4'b0001;  // SLL
    a = 8;
    b = 3;
    assert (out == (a << b))
    else $error("SLL: is broken");

    #1;
    ALUControl = 4'b0010;  // SLT
    a = 8;
    b = 3;
    assert (out == {31'b0, a < b})
    else $error("SLT: is broken");

    #1;
    ALUControl = 4'b0010;  // SLTU
    a = 8;
    b = 3;
    assert (out == {31'b0, $unsigned(a) < $unsigned(b)})
    else $error("SLTU: is broken");

    #1;
    ALUControl = 4'b0100;  // XOR
    a = 8;
    b = 3;
    assert (out == (a ^ b))
    else $error("XOR: is broken");

    #1;
    ALUControl = 4'b0101;  // SRL
    a = 8;
    b = 3;
    assert (out == (a >> b))
    else $error("SRL: is broken");

    #1;
    ALUControl = 4'b1101;  // SRA
    a = 8;
    b = 3;
    assert (out == (a >> b))
    else $error("SRA: is broken");

    #1;
    ALUControl = 4'b0110;  // OR
    a = 20;
    b = 30;
    assert (out == (a | b))
    else $error("OR: is broken");

    #1;
    ALUControl = 4'b0111;  // AND
    a = 20;
    b = 30;
    assert (out == (a & b))
    else $error("AND: is broken");


    // -----------------------------
    // FLAGS (ONLY ZERO FOR NOW)
    // -----------------------------
    #1;
    ALUControl = 4'b0000;  // ADD
    a = 2 ^ 31;
    b = 1;
    assert (flags[0])
    else $error("Overflow flag is broken");

    #3;
    ALUControl = 4'b0000;  // ADD
    a = 2 ^ 31;
    b = 1;
    assert (flags[1])
    else $error("Carry flag is broken");

    #1;
    ALUControl = 4'b1000;  // SUB
    a = 20;
    b = 20;
    assert (flags[2])
    else $error("Zero flag is broken");

    #1;
    ALUControl = 4'b1000;  // SUB
    a = 20;
    b = 30;
    assert (!flags[2])
    else $error("Zero flag is broken");

    #1;
    ALUControl = 4'b1000;  // SUB
    a = -2;
    b = 30;
    assert (flags[3])
    else $error("Sign flag is broken");

    #1;
    ALUControl = 4'b0000;  // SUB
    a = 20;
    b = -30;
    assert (!flags[3])
    else $error("Sign flag is broken");
    $finish;
  end
endmodule

