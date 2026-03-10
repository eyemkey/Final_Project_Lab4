`timescale 1ns / 1ps


module pmod_button_debouncer(
    input clk, 
    input sample_en,
    input btn0, 
    input btn1, 
    input btn2, 
    input btn3, 
    
    output btn0_db, 
    output btn1_db, 
    output btn2_db, 
    output btn3_db
);


    reg [2:0] btn0_buff, btn1_buff, btn2_buff, btn3_buff; 
    reg sample_en_d; 
        
    always @(posedge clk) begin
        sample_en_d <= sample_en; 
        if(sample_en) begin
            btn0_buff <= {btn0, btn0_buff[2:1]};
            btn1_buff <= {btn1, btn1_buff[2:1]};
            btn2_buff <= {btn2, btn2_buff[2:1]};
            btn3_buff <= {btn3, btn3_buff[2:1]};
        end //if(sample_en)
    end //always @


    assign btn0_db = btn0_buff[1] & ~btn0_buff[0] & sample_en_d;
    assign btn1_db = btn1_buff[1] & ~btn1_buff[0] & sample_en_d;
    assign btn2_db = btn2_buff[1] & ~btn2_buff[0] & sample_en_d;
    assign btn3_db = btn3_buff[1] & ~btn3_buff[0] & sample_en_d;

endmodule
