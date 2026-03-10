`timescale 1ns / 1ps

module sprite_pos(
    input vga_clk, 
    input locked,
    input move_en,
    input up, //btn0
    input down, //btn3
    input right, //btn1
    input left, //btn2
    
    
    output [10:0] tlx, 
    output [10:0] tly, 
    output [10:0] brx, 
    output [10:0] bry
);

    localparam H_VISIBLE = 1280;
    localparam V_VISIBLE = 720;

    reg [10:0] tl [0:1]; //xy
    reg [10:0] br [0:1]; //xy
    
    
    initial begin
        tl[0] = 60; 
        tl[1] = 60; 
        br[0] = 188; 
        br[1] = 188;
    end
    
    always @(posedge vga_clk) begin
        if(move_en && locked) begin
            if(br[0] + 10 * (right - left) > H_VISIBLE - 1) begin //right 
                  br[0] <= H_VISIBLE - 1;
                  tl[0] <= H_VISIBLE - 128;
            end else if($signed(tl[0] + 10 * (right - left)) < 0) begin //left 
                tl[0] <= 0;
                br[0] <= 127;
            end else begin
                tl[0] <= tl[0] + 10 * (right - left); 
                br[0] <= br[0] + 10 * (right - left); 
            end
            
            if(br[1] + 10 * (down - up) > V_VISIBLE - 1) begin //bottom 
                br[1] <= V_VISIBLE - 1; 
                tl[1] <= V_VISIBLE - 128;
            end else if($signed(tl[1] + 10 * (down - up)) < 0) begin //top
                tl[1] <= 0; 
                br[1] <= 127;
            end else begin
                tl[1] <= tl[1] + 10 * (down - up); 
                br[1] <= br[1] + 10 * (down - up);
            end
        end //if(move_en)
    end  
    
    
    assign tlx = tl[0]; 
    assign tly = tl[1]; 
    assign brx = br[0]; 
    assign bry = br[1];


endmodule
