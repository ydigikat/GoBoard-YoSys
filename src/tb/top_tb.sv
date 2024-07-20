/*
* Testbench entry point 
*/

`default_nettype none
`timescale 10ns/10ps
`define DUMPSTR(x) `"x.vcd`"

`ifndef VCD_OUTPUT
`define VCD_OUTPUT vcd.out
`endif

module mod_top_tb;

localparam CLK_PERIOD = 100;    
localparam DURATION = 100000;

logic clk = 1'b0;

always #(CLK_PERIOD/2) clk=~clk;

/* VCD output */
initial 
begin      
    $dumpfile(`DUMPSTR(`VCD_OUTPUT));
    $dumpvars(0, mod_top_tb); 
end
  

/*
* Test runs for 1ms.  During that time
*/
initial begin    

  /* 1ms run time */
  #(DURATION);

  $display("\n--- PASS: TESTS ---\n");
  $finish();
end

endmodule