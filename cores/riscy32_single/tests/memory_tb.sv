/*
Memory Testbench
*/

module memory_tb;

  reg clk;
  reg write_enable;
  reg [31:0] address;
  reg [31:0] data_in;
  wire [31:0] data_out;

  memory memory (
      .clk(clk),
      .write_enable(write_enable),
      .address(address),
      .data_in(data_in),
      .data_out(data_out)
  );

  always #1 clk <= ~clk;

  initial begin
    //$dumpfile(memory.vcd");
    //$dumpvars(0, clk, write_enable, address, data_in, data_out);

    for (int i = 0; i < 4096; i++) begin
      address = i;
      write_enable = 1;
      data_in = i;
      repeat (1) @(posedge clk);
    end

    // Test read
    address = 32'h00000001;
    write_enable = 0;
    repeat (1) @(posedge clk);
    assert (data_out == 0)
    else $error("Read failed");

    // Test write
    address = 32'h8542391A;
    write_enable = 1;
    data_in = 32'hdeadbeef;
    repeat (1) @(posedge clk);
    address = 32'h8542391A;
    write_enable = 0;
    repeat (1) @(posedge clk);
    assert (data_out == 32'hdeadbeef)
    else $error("Write failed");

    // Test multiple writes
    for (int i = 2; i < 10; i++) begin
      address = 32'h00000010 | i;
      write_enable = 1;
      data_in = i * 2;
      repeat (1) @(posedge clk);
    end
    for (int i = 2; i < 10; i++) begin
      address = 32'h00000010 | i;
      write_enable = 0;
      repeat (1) @(posedge clk);
      assert (data_out == i * 2)
      else $error("Multiple writes failed");
    end

    // Test read from unwritten location
    address = 32'h00001000;
    write_enable = 0;
    repeat (1) @(posedge clk);
    assert (data_out == 0)
    else $error("Read from unwritten location failed");

    $finish;
  end
endmodule
