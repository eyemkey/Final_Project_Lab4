`timescale 1ns / 1ps

module enable_gen(
    input clk, 
    output reg sample_en, //100Hz pulse
    output reg move_en
);  

    localparam SAMPLE_EN_CNT_MAX = 1_000_000;
    localparam MOVE_EN_CNT_MAX = 1_666_667;
    
    reg [19:0] sample_en_cnt;
    reg [20:0] move_en_cnt;
    
    initial sample_en_cnt = 0; 
     
    always @(posedge clk) begin
        sample_en <= 0; 
        if(sample_en_cnt == SAMPLE_EN_CNT_MAX-1) begin
            sample_en <= 1; 
            sample_en_cnt <= 0; 
        end else sample_en_cnt <= sample_en_cnt + 1;     
    end
    
    always @(posedge clk) begin
        move_en <= 0; 
        if(move_en_cnt == MOVE_EN_CNT_MAX - 1) begin
            move_en <= 1; 
            move_en_cnt <= 0; 
        end else move_en_cnt <= move_en_cnt + 1;
    end

endmodule
