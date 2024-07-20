`default_nettype none
`timescale 10ns/1ps

/*
* Top (main) module
*/

module mod_top
(
  input wire logic i_clk,
  output logic o_LED_1
);

logic [31:0] counter;


/* Clock divider */
always_ff @(posedge i_clk)  
    counter <= counter + 1;  


/* The ubiquitous Mr Blinky once again graces us with its presence */
assign o_LED_1 = counter[22];


endmodule