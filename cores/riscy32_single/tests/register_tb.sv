module register_tb;
  reg clk;
  reg we3;
  reg [4:0] a1, a2, a3;
  reg [31:0] wd3;
  wire [31:0] rd1, rd2;
  //logic done = 0;

  register dut (
      .clk(clk),
      .we3(we3),
      .a1 (a1),
      .a2 (a2),
      .a3 (a3),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
      //.done(done)
  );

  always #1 clk <= ~clk;

  initial begin
    $dumpfile("register.vcd");
    $dumpvars(0, register_tb);
    //done = 0;
    clk = 0;
    we3 = 0;
    a1  = 0;
    a2  = 0;
    a3  = 0;
    wd3 = 0;

    // Test write to register 1
    we3 = 1;
    a3  = 1;
    wd3 = 32'h12345678;
    repeat (2) @(posedge clk);
    assert (rd1 == 32'h12345678)
    else $error("Write to register 1 failed");

    // Test read from register 1
    we3 = 0;
    a1  = 1;
    repeat (2) @(posedge clk);
    assert (rd1 == 32'h12345678)
    else $error("Read from register 1 failed");

    // Test write to register 2
    we3 = 1;
    a3  = 2;
    wd3 = 32'h87654321;
    repeat (2) @(posedge clk);
    assert (rd2 == 32'h87654321)
    else $error("Write to register 2 failed");

    // Test read from register 2
    we3 = 0;
    a2  = 2;
    repeat (2) @(posedge clk);
    assert (rd2 == 32'h87654321)
    else $error("Read from register 2 failed");

    // Test write to register 0 (should not write)
    we3 = 1;
    a3  = 0;
    wd3 = 32'hdeadbeef;
    repeat (2) @(posedge clk);
    assert (rd1 == 32'h12345678)
    else $error("Write to register 0 failed");

    $finish;
  end
endmodule
