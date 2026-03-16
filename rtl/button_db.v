`timescale 1ns / 1ps


module button_db(
    input vga_clk, 
    input btnC,
    input sample_en, 
    output reg btnC_db
);

    reg [2:0] btnC_buff; 
    reg sample_en_d; 
        
    always @(posedge vga_clk) begin
        sample_en_d <= sample_en; 
        if(sample_en) begin
            btnC_buff <= {btnC, btnC_buff[2:1]};
        end //if(sample_en)
        
        btnC_db <= sample_en_d & btnC_buff[1] & !btnC_buff[0];
    end //always @

endmodule

