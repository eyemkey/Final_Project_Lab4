`timescale 1ns / 1ps

module pixel_info(
    input vga_clk, 
    input locked, 
    input btnC_db,
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
    localparam SPRITE_W = 128;
 
    
    reg [3:0] red1 [0:16383]; 
    reg [3:0] blue1 [0:16383];
    reg [3:0] green1 [0:16383];
    reg [3:0] red2 [0:16383]; 
    reg [3:0] blue2 [0:16383];
    reg [3:0] green2 [0:16383];
    reg [3:0] red3 [0:16383]; 
    reg [3:0] blue3 [0:16383];
    reg [3:0] green3 [0:16383];
    
    
    reg [1:0] sprite_id; 
    
    integer i;     

    wire [10:0] local_x = H_idx - tlx;
    wire [9:0]  local_y = V_idx - tly;
    wire [13:0] addr = local_y * SPRITE_W + local_x;

    initial begin
        $readmemh("red1.mem", red1); 
        $readmemh("green1.mem", green1); 
        $readmemh("blue1.mem", blue1);
        
        $readmemh("red2.mem", red2); 
        $readmemh("green2.mem", green2); 
        $readmemh("blue2.mem", blue2);
        
        $readmemh("red3.mem", red3); 
        $readmemh("green3.mem", green3); 
        $readmemh("blue3.mem", blue3);
        
        sprite_id = 1; 
        
    end

//    initial begin
//        counter = 0;
        
//        for(i = 0; i < 16384; i = i + 1) begin
//            red[i] <= 4'b1111; 
//            blue[i] <= 4'b0000;
//            green[i] <= 4'b0000;        
//        end
//    end 


    always @(posedge vga_clk) begin
        if(locked) begin
            if(H_idx < H_VISIBLE && V_idx < V_VISIBLE) begin
                vgaRed <= 4'b0000; 
                vgaBlue <= 4'b1111; 
                vgaGreen <= 4'b0000;
                
                if(H_idx >= tlx && V_idx >= tly && H_idx < brx && V_idx < bry) begin
                
                    case(sprite_id) 
                        1: begin
                            vgaRed <= red1[addr];
                            vgaBlue <= blue1[addr]; 
                            vgaGreen <= green1[addr];
                        end
                        
                        2: begin
                            vgaRed <= red2[addr];
                            vgaBlue <= blue2[addr]; 
                            vgaGreen <= green2[addr];
                        end
                        
                        3: begin
                            vgaRed <= red3[addr];
                            vgaBlue <= blue3[addr]; 
                            vgaGreen <= green3[addr];
                        end
                        default: begin
                            vgaRed <= 4'b0000;
                            vgaBlue <= 4'b0000;
                            vgaGreen <= 4'b0000;
                        end
                    endcase
                end
            end else begin
                vgaRed <= 4'b0000;
                vgaBlue <= 4'b0000;
                vgaGreen <= 4'b0000;
            end
        end //if(locked)
        else begin
            vgaRed <= 4'b0000;
            vgaBlue <= 4'b0000;
            vgaGreen <= 4'b0000;
        end
    end
    
    always @(posedge vga_clk) begin
        if(btnC_db) begin
            if(sprite_id == 3) begin
                sprite_id <= 1; 
            end else sprite_id <= sprite_id + 1;
        end
    end


endmodule
