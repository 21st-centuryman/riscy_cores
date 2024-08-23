/*
Memory Testbench
*/

module memory_tb;

  reg clk;
  reg write_enable;
  reg [31:0] address;
  reg [31:0] data_in;
  logic [31:0] out;

  memory dut (
      .clk(clk),
      .write_enable(write_enable),
      .address(address),
      .data_in(data_in),
      .data_out(out)
  );

  always #1 clk <= ~clk;

  initial begin
    $dumpfile("memory.vcd");
    $dumpvars(0, memory_tb);

    for (int i = 0; i < 4096; i++) begin
      address = i;
      write_enable = 1;
      data_in = i;
      repeat (2) @(posedge clk);
    end

    // Test read
    address = 32'h00000001;
    write_enable = 0;
    repeat (2) @(posedge clk);
    assert (out == 1)
    else $error("Read failed");

    // Test write
    address = 4096;
    write_enable = 1;
    data_in = 3735928559;
    repeat (2) @(posedge clk);
    write_enable = 0;
    repeat (2) @(posedge clk);
    assert (out == 3735928559)
    else $error("Write failed");

    // Test multiple writes
    for (int i = 2; i < 10; i++) begin
      address = 32'h00000010 | i;
      write_enable = 1;
      data_in = i * 2;
      repeat (2) @(posedge clk);
    end
    for (int i = 2; i < 10; i++) begin
      address = 32'h00000010 | i;
      write_enable = 0;
      repeat (2) @(posedge clk);
      assert (out == i * 2)
      else $error("Multiple writes failed");
    end

    // Test read from unwritten location
    //address = 32'h00001000;
    //write_enable = 0;
    //repeat (2) @(posedge clk);
    //assert (out == 0)
    //else $error("Read from unwritten location failed");

    $dumpoff;
    $finish;
  end
endmodule
