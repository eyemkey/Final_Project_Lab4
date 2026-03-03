`timescale 1ns / 1ps

module top(
    input clk, 
    
    input miso, 
    output ss_n, 
    output mosi, 
    output sck, 
    
    output [6:0] seg, 
    output [3:0] an
);


    wire [9:0] joy_x; 
    wire [9:0] joy_y; 
    wire [2:0] joy_btn; 
    wire joy_valid; 
    
    pmod_jstk_driver #(
        .CLK_HZ(100_000_000), 
        .SCK_HZ(500_000), 
        .POLL_HZ(5)
    ) jstk (
        .clk(clk), 
        .miso(miso), 
        .mosi(mosi), 
        .sck(sck), 
        .ss_n(ss_n),
        
        .joy_x(joy_x),
        .joy_y(joy_y),
        .joy_btn(joy_btn),
        .data_valid(joy_valid)
    );
    
    sevenseg_hex10 #(
        .CLK_HZ(100_000_000), 
        .REFRESH_HZ(1000)
    ) disp_x (
        .clk(clk),
        .value(joy_x),   // 10-bit from your JSTK driver
        .an(an),
        .seg(seg)
    ); 

endmodule
