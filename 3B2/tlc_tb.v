// Testbench for basic Traffic Light Controller (tlc.v)
// Uses force/release on internal counter to skip long timer waits.
`timescale 1ns / 1ps

module tlc_tb;

  reg clk, request, reset;
  wire [4:0] out;

  tlc uut (.clk(clk), .request(request), .reset(reset), .\output (out));

  initial clk = 0;
  always #10 clk = ~clk; // 50 MHz

  localparam G = 2'd0, Y = 2'd1, R = 2'd2;
  localparam OUT_G = 5'b10001, OUT_Y = 5'b01001, OUT_R = 5'b00110;
  localparam Y_THRESH = 29'd250_000_000, R_THRESH = 29'd500_000_000;

  integer pass_count = 0, fail_count = 0;

  task check(input [63:0] name, input cond);
    begin
      if (cond) begin $display("  PASS: %0s", name); pass_count = pass_count + 1; end
      else      begin $display("  FAIL: %0s", name); fail_count = fail_count + 1; end
    end
  endtask

  task wait_clks(input integer n);
    integer i;
    begin for (i = 0; i < n; i = i + 1) @(posedge clk); end
  endtask

  // Skip counter to near threshold, then let it trigger naturally
  task skip_counter(input [28:0] thresh);
    begin
      force uut.count = thresh - 2;
      wait_clks(1);
      release uut.count;
      wait_clks(5);
    end
  endtask

  initial begin
    $dumpfile("tlc_tb.vcd");
    $dumpvars(0, tlc_tb);
    request = 1; reset = 1;

    // T1: Reset -> state G
    $display("\n--- T1: Reset ---");
    reset = 0; wait_clks(3);
    check("state=G", uut.state == G);
    check("out=10001", out == OUT_G);
    reset = 1; wait_clks(2);

    // T2: Full cycle G -> Y -> R -> G
    $display("\n--- T2: Full cycle ---");
    request = 0; wait_clks(2); request = 1;
    check("G->Y", uut.state == Y);
    check("out=01001", out == OUT_Y);
    skip_counter(Y_THRESH);
    check("Y->R", uut.state == R);
    check("out=00110", out == OUT_R);
    skip_counter(R_THRESH);
    check("R->G", uut.state == G);
    check("out=10001", out == OUT_G);

    // T3: Async reset from Y and R
    $display("\n--- T3: Async reset ---");
    request = 0; wait_clks(2); request = 1;
    check("in Y", uut.state == Y);
    reset = 0; wait_clks(2);
    check("Y reset->G", uut.state == G);
    reset = 1; wait_clks(2);
    // Now reset from R
    request = 0; wait_clks(2); request = 1; wait_clks(1);
    skip_counter(Y_THRESH);
    check("in R", uut.state == R);
    reset = 0; wait_clks(2);
    check("R reset->G", uut.state == G);
    reset = 1; wait_clks(2);

    // T4: Idle stability
    $display("\n--- T4: Idle ---");
    request = 1; wait_clks(100);
    check("stays G", uut.state == G);

    // Summary
    $display("\n== %0d passed, %0d failed ==", pass_count, fail_count);
    if (fail_count == 0) $display("ALL TESTS PASSED");
    else $display("SOME TESTS FAILED");
    $finish;
  end

endmodule
