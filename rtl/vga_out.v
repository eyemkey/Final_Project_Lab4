`timescale 1ns / 1ps

module vga_out(
    input vga_clk, //74.25MHz clock
    input locked, // clk is locked and stable
    
    input [10:0] tlx, 
    input [10:0] tly, 
    input [10:0] brx, 
    input [10:0] bry,
    
    output [3:0] vgaRed, 
    output [3:0] vgaBlue, 
    output [3:0] vgaGreen, 
    output reg Hsync, 
    output reg Vsync
);
    
    localparam H_VISIBLE = 1280;
    localparam H_FRONT   = 110;
    localparam H_SYNC    = 40;
    localparam H_BACK    = 220;
    localparam H_TOTAL   = 1650;

    localparam V_VISIBLE = 720;
    localparam V_FRONT   = 5;
    localparam V_SYNC    = 5;
    localparam V_BACK    = 20;
    localparam V_TOTAL   = 750;
    
    reg [10:0] H_idx; 
    reg [9:0] V_idx;
    
    initial begin
        H_idx = 0; 
        V_idx = 0;
    end

    always @(posedge vga_clk) begin
        if(locked) begin
        
            if (H_idx == H_TOTAL - 1) begin
                H_idx <= 0;
    
                if (V_idx == V_TOTAL - 1)
                    V_idx <= 0;
                else
                    V_idx <= V_idx + 1;
            end else begin
                H_idx <= H_idx + 1;
            end
    
            if (H_idx >= H_VISIBLE + H_FRONT &&
                H_idx <  H_VISIBLE + H_FRONT + H_SYNC)
                Hsync <= 0;
            else
                Hsync <= 1;
    
            if (V_idx >= V_VISIBLE + V_FRONT &&
                V_idx <  V_VISIBLE + V_FRONT + V_SYNC)
                Vsync <= 0;
            else
                Vsync <= 1;
    
//            if (H_idx < H_VISIBLE && V_idx < V_VISIBLE) begin
//                vgaRed   <= 4'b0000;
//                vgaGreen <= 4'b0000;
//                vgaBlue  <= 4'b1111;  // BLUE
                
//                if(H_idx >= tlx && V_idx >= tly && H_idx < brx && V_idx < bry) begin
//                    vgaRed <= 4'b1111; 
//                    vgaGreen <= 4'b0000; 
//                    vgaBlue <= 4'b1111;
//                end
                
//            end else begin
//                vgaRed <= 4'b0000;
//                vgaGreen <= 4'b0000;
//                vgaBlue <= 4'b0000; //black outside of visible
//            end //if(H_idx...
            
        end //if(locked) 
        else begin
            H_idx <= 0; 
            V_idx <= 0; 
            Hsync <= 1; 
            Vsync <= 1; 
//            vgaRed <= 0; 
//            vgaGreen <= 0; 
//            vgaBlue <= 0;
        end
    end

    pixel_info pixel_info (
        .vga_clk(vga_clk), 
        .locked(locked), 
        .H_idx(H_idx),
        .V_idx(V_idx),
        .tlx(tlx),
        .tly(tly),
        .brx(brx),
        .bry(bry),
        .vgaRed(vgaRed),
        .vgaBlue(vgaBlue),
        .vgaGreen(vgaGreen)    
    ); 

endmodule
