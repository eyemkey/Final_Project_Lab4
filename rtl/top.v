`timescale 1ns / 1ps

module top(
    input clk, 
    
    input miso, 
    output ss_n, 
    output mosi, 
    output sck, 
    
    output [15:0] led
);


    wire [9:0] joy_x; 
    wire [9:0] joy_y; 
    wire [2:0] joy_btn; 
    wire joy_valid; 
    
    pmod_jstk_driver #(
        .CLK_HZ(100_000_000), 
        .SCK_HZ(500_000), 
        .POLL_HZ(100)
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
    
    assign led[9:0] = joy_x; 
    assign led[12:10] = joy_btn; 
    assign led[13] = joy_valid; 
    assign led[15:14] = 2'b00;

endmodule
