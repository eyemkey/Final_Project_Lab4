`timescale 1ns / 1ps



module sevenseg_hex10 #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer REFRESH_HZ = 1000
)
(
    input clk, 
    input [9:0] value,
    output reg [3:0] an, 
    output reg [6:0] seg
);

    localparam integer REFRESH_DIV = CLK_HZ / REFRESH_HZ; 
    reg [$clog2(REFRESH_DIV)-1:0] refresh_cnt; 
    reg [1:0] digit_sel; 
    
    always @(posedge clk) begin
        if(refresh_cnt == REFRESH_DIV - 1) begin
            refresh_cnt <= 0; 
            digit_sel <= digit_sel + 1; 
        end else begin
            refresh_cnt <= refresh_cnt + 1; 
        end
    end
    
    wire [11:0] v12 = {2'b00, value}; 
    wire [3:0] d0 = v12[3:0]; 
    wire [3:0] d1 = v12[7:4]; 
    wire [3:0] d2 = v12[11:8];
    
    reg [3:0] hex_digit; 
    reg blank;
    
    always @(*) begin
        an = 4'b1111; 
        hex_digit = 4'h0; 
        blank = 1'b0; 
        
        case (digit_sel) 
            2'd0: begin
                an = 4'b1110; 
                hex_digit = d0; 
            end
            
            2'd1: begin
                an = 4'b1101; 
                hex_digit = d1; 
            end
            
            2'd2: begin
                an = 4'b1011; 
                hex_digit = d2; 
            end
            
            2'd3: begin
                an = 4'b0111; 
                blank = 1; 
            end
        endcase
    end
    
    
    reg [6:0] seg_raw;
    always @* begin
        case (hex_digit)
            4'h0: seg_raw = 7'b1000000;
            4'h1: seg_raw = 7'b1111001;
            4'h2: seg_raw = 7'b0100100;
            4'h3: seg_raw = 7'b0110000;
            4'h4: seg_raw = 7'b0011001;
            4'h5: seg_raw = 7'b0010010;
            4'h6: seg_raw = 7'b0000010;
            4'h7: seg_raw = 7'b1111000;
            4'h8: seg_raw = 7'b0000000;
            4'h9: seg_raw = 7'b0010000;
            4'hA: seg_raw = 7'b0001000;
            4'hB: seg_raw = 7'b0000011;
            4'hC: seg_raw = 7'b1000110;
            4'hD: seg_raw = 7'b0100001;
            4'hE: seg_raw = 7'b0000110;
            4'hF: seg_raw = 7'b0001110;
            default: seg_raw = 7'b1111111;
        endcase
    end
    
    always @* begin
        seg = blank ? 7'b1111111 : seg_raw;
    end
    
endmodule
