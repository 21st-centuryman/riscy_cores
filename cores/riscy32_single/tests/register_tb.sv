module register_tb;
  reg clk;
  reg we3;
  reg [4:0] a1, a2, a3;
  reg [31:0] wd3;
  wire [31:0] rd1, rd2;
  logic done = 0;

  register dut (
      .clk (clk),
      .we3 (we3),
      .a1  (a1),
      .a2  (a2),
      .a3  (a3),
      .wd3 (wd3),
      .rd1 (rd1),
      .rd2 (rd2),
      .done(done)
  );

  always #1 clk <= ~clk;

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(clk, we3, a1, a2, a3, wd3, rd1, rd2, done);

    done = 0;
    clk  = 0;
    we3  = 0;
    a1   = 0;
    a2   = 0;
    a3   = 0;
    wd3  = 0;
    #10;

    // Test write to register 1
    we3 = 1;
    a3  = 1;
    wd3 = 32'h12345678;
    #10;
    assert (rd1 == 32'h12345678)
    else $error("Write to register 1 failed");

    // Test read from register 1
    we3 = 0;
    a1  = 1;
    #10;
    assert (rd1 == 32'h12345678)
    else $error("Read from register 1 failed");

    // Test write to register 2
    we3 = 1;
    a3  = 2;
    wd3 = 32'h87654321;
    #10;
    assert (rd2 == 32'h87654321)
    else $error("Write to register 2 failed");

    // Test read from register 2
    we3 = 0;
    a2  = 2;
    #10;
    assert (rd2 == 32'h87654321)
    else $error("Read from register 2 failed");

    // Test write to register 0 (should not write)
    we3 = 1;
    a3  = 0;
    wd3 = 32'hdeadbeef;
    #10;
    assert (rd1 == 32'h12345678)
    else $error("Write to register 0 failed");

    // Test done signal
    $display("\n\n\nDisplaying all registers");
    done = 1;
    #10;
    assert (done == 1)
    else $error("Done signal failed");

    $dumpoff;
    $finish;
  end
endmodule

