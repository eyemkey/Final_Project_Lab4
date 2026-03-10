`timescale 1ns / 1ps

module pixel_info(
    input vga_clk, 
    input locked, 
    input [10:0] H_idx, 
    input [9:0] V_idx, 
    input [10:0] tlx, 
    input [10:0] tly, 
    input [10:0] brx, 
    input [10:0] bry, 
    output reg [3:0] vgaRed, 
    output reg [3:0] vgaBlue, 
    output reg [3:0] vgaGreen
);

    localparam H_VISIBLE = 1280;
    localparam V_VISIBLE = 720;

    reg [3:0] red [0:16383]; 
    reg [3:0] blue [0:16383];
    reg [3:0] green [0:16383];
    
    reg [13:0] counter; 
    
    integer i; 

    initial begin
        counter = 0;
        
        for(i = 0; i < 16384; i = i + 1) begin
            red[i] <= 4'b1111; 
            blue[i] <= 4'b0000;
            green[i] <= 4'b0000;        
        end
    end 

    always @(posedge vga_clk) begin
        if(locked) begin
            if(H_idx < H_VISIBLE && V_idx < V_VISIBLE) begin
                vgaRed <= 4'b0000; 
                vgaBlue <= 4'b1111; 
                vgaGreen <= 4'b0000;
                
                if(H_idx >= tlx && V_idx >= tly && H_idx < brx && V_idx < bry) begin
                    vgaRed <= red[V_idx * V_VISIBLE + H_idx];
                    vgaBlue <= blue[V_idx * V_VISIBLE + H_idx]; 
                    vgaGreen <= green[V_idx * V_VISIBLE + H_idx];
                end
            end else begin
                vgaRed <= 4'b0000;
                vgaBlue <= 4'b0000;
                vgaGreen <= 4'b0000;
            end
            
        end //if(locked)
    end


endmodule
