`timescale 1ns / 1ps

module sprite_pos(
    input clk, 
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

    reg [10:0] tl [0:1]; //xy
    reg [10:0] br [0:1]; //xy
    
    
    initial begin
        tl[0] = 60; 
        tl[1] = 60; 
        br[0] = 188; 
        br[1] = 188;
    end
    
    always @(posedge clk) begin
        if(move_en) begin
            tl[0] <= tl[0] + 10 * (right - left); 
            br[0] <= br[0] + 10 * (right - left); 
            
            tl[1] <= tl[1] + 10 * (down - up); 
            br[1] <= br[1] + 10 * (down - up);
            
        end //if(move_en)
    end  
    
    
    assign tlx = tl[0]; 
    assign tly = tl[1]; 
    assign brx = br[0]; 
    assign bry = br[1];


endmodule
