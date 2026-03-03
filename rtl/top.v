`timescale 1ns / 1ps


module top(
    input clk, //100MHz clock
    output [3:0] vgaRed, 
    output [3:0] vgaBlue, 
    output [3:0] vgaGreen, 
    output Hsync, 
    output Vsync
);

    //CLK_WIZ I/O
    wire vga_clk;
    wire reset, locked;  
    
    assign reset = 0; 
    
    clk_wiz_0 clk_gen (
        .clk_in1(clk), 
        .reset(reset),
        .clk_out1(vga_clk),
        .locked(locked)
    );  
    
    vga_out vga_out (
        .vga_clk(vga_clk), 
        .locked(locked),
        .vgaRed(vgaRed), 
        .vgaBlue(vgaBlue), 
        .vgaGreen(vgaGreen), 
        .Hsync(Hsync), 
        .Vsync(Vsync)
    );     

endmodule
