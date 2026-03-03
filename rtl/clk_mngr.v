`timescale 1ns / 1ps

module clk_mngr(
    input clk,
    output reg jstk_poll_en //100Hz pulse
);

    reg [6:0] jstk_poll_en_cnt; //counts 0-99
    
    always @(posedge clk) begin
        jstk_poll_en <= 0; 
        if(jstk_poll_en_cnt == 99) begin
            jstk_poll_en_cnt <= 0; 
            jstk_poll_en <= 1;
        end else jstk_poll_en_cnt <= jstk_poll_en_cnt + 1; 
    end 
    

endmodule
