`timescale 1ns / 1ps


module top(
    input clk, //100MHz clock
    input btn0, 
    input btn1, 
    input btn2, 
    input btn3,
    output [3:0] vgaRed, 
    output [3:0] vgaBlue, 
    output [3:0] vgaGreen, 
    output Hsync, 
    output Vsync,
    
    output [3:0] led
);

    //CLK_WIZ I/O
    wire vga_clk;
    wire reset, locked;  
    
    //I/O pmod_button_debouncer
    wire sample_en;
    wire btn0_db, btn1_db, btn2_db, btn3_db; 
    
    //I/O sprite_pos
    wire move_en;
    wire [10:0] tlx, tly, brx, bry;
    
    assign reset = 0; 
    
    
    assign led = {btn3, btn2, btn1, btn0};
    
    clk_wiz_0 clk_gen (
        .clk_in1(clk), 
        .reset(reset),
        .clk_out1(vga_clk),
        .locked(locked)
    );  
    
    
    enable_gen en_gen (
        .clk(clk), 
        .sample_en(sample_en), 
        .move_en(move_en)
    ); 
    
    pmod_button_debouncer btn_db (
        .clk(clk), 
        .sample_en(sample_en),
         
        .btn0(btn0), 
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        
        .btn0_db(btn0_db),
        .btn1_db(btn1_db),
        .btn2_db(btn2_db),
        .btn3_db(btn3_db)
    ); 
    
    sprite_pos sprite_pos (
        .vga_clk(vga_clk), 
        .locked(locked),
        .move_en(move_en),
        .up(btn0), 
        .down(btn3), 
        .right(btn1), 
        .left(btn2),
             
        .tlx(tlx), 
        .tly(tly), 
        .brx(brx),
        .bry(bry)
    ); 
    
    vga_out vga_out (
        .vga_clk(vga_clk), 
        .locked(locked),
        
        .tlx(tlx),
        .tly(tly),
        .brx(brx),
        .bry(bry),
        
        .vgaRed(vgaRed), 
        .vgaBlue(vgaBlue), 
        .vgaGreen(vgaGreen), 
        .Hsync(Hsync), 
        .Vsync(Vsync)
    );     

endmodule
