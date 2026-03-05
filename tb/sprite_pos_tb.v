`timescale 1ns / 1ps

module sprite_pos_tb;

    reg clk; 
    reg move_en; 
    reg up, down, right, left; 
    
    
    wire [10:0] tlx, tly, brx, bry;
    
    
    always #5 clk = ~clk; 
    
    sprite_pos sp_pos (
        .clk(clk), 
        .move_en(move_en), 
        .up(up), 
        .down(down), 
        .left(left),
        .right(right),
        .tlx(tlx),
        .tly(tly),
        .brx(brx),
        .bry(bry)
    ); 
    
    
    initial begin
        clk = 0; 
        move_en = 0; 
        up = 0; 
        down = 0; 
        right = 0; 
        left = 0; 
        move_en = 1;
        #50;
        
        right = 1; 
        @(posedge clk); 
        $display("Test 1, Press Right");
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);
        
        right = 0; 
        left = 1; 
        @(posedge clk); 
        $display("Test 2, Press Left");
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);

        left = 0; 
        up = 1; 
        @(posedge clk);
        #1;
        $display("Test 3, Press Up");
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);
       
       
        up = 0; 
        down = 1; 
        @(posedge clk);
        $display("Test 4, Press Down"); 
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);



        up = 1; 
        down = 0; 
        right = 1; 
        @(posedge clk);
        $display("Test 5, Up Right"); 
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);
        
        up = 0; 
        down = 1; 
        right = 1; 
        @(posedge clk);
        $display("Test 6, Down Right"); 
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);
        
        up = 1; 
        down = 0; 
        left = 1; 
        right = 0; 
        @(posedge clk);
        $display("Test 7, Up Left"); 
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);


        up = 0; 
        down = 1; 
        left = 1; 
        right = 0; 
        @(posedge clk);
        $display("Test 8, Down Left"); 
        #1;
        $display("tl = (%0d, %0d) | br = (%0d, %0d)", tlx, tly, brx, bry);        
        
        #100; 
        $display("[DONE]");
        $finish;
    end
    
    
    

endmodule
