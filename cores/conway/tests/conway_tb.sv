module conway_tb;

  logic clk;

  conway conway (.clk(clk));

  initial begin
    int iterations = 475;
    for (integer i = 0; i < iterations; i++) begin
      repeat (1) @(posedge clk);
    end
    $finish;  // Remove if you want it to run forever
  end


  always #2s clk <= ~clk;
endmodule

