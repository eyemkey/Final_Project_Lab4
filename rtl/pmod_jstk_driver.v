`timescale 1ns / 1ps

module pmod_jstk_driver #(
    parameter integer CLK_HZ = 100_000_000, 
    parameter integer SCK_HZ = 500_000,
    parameter POLL_HZ = 100
)
(
    input clk, 
    
    
    //PMOD I/O
    input miso, 
    output mosi, 
    output sck, 
    output ss_n, 
    
    //Parsed outputs
    output reg [9:0] joy_x, 
    output reg [9:0] joy_y, 
    output reg [2:0] joy_btn, 
    output reg data_valid
);

    //Poll timer: generating 1-cycle tick at POLL_HZ
    
    localparam integer POLL_DIV = CLK_HZ / POLL_HZ;
    reg [$clog2(POLL_DIV)-1:0] poll_cnt;
    reg poll_tick; 
    
    always @(posedge clk) begin
        if(poll_cnt == POLL_DIV - 1) begin
            poll_cnt <= 0; 
            poll_tick <= 1'b1; 
        end else begin
            poll_cnt <= poll_cnt + 1; 
            poll_tick <= 1'b0;
        end
    end
    
    //SPI clock tick generator (half-period tick). Toggle SCK on each tick when active. 
    
    localparam integer HALF_DIV = CLK_HZ / (2 * SCK_HZ); 
    reg [$clog2(HALF_DIV)-1:0] sck_div_cnt; 
    reg sck_tick; 
    
    reg spi_active; 
    
    always @(posedge clk) begin
        
        if(!spi_active) begin
            sck_div_cnt <= 0; 
            sck_tick <= 1'b0; 
        end else begin
        
            if(sck_div_cnt == HALF_DIV - 1) begin
                sck_div_cnt <= 0; 
                sck_tick <= 1'b1; 
            end else begin
                sck_div_cnt <= sck_div_cnt + 1; 
                sck_tick <= 1'b0; 
            end //if(sck_div_cnt)
        
        end //if(!spi_active)
    
    end //always
    
    
    //SPI transaction FSM: shift 40 bits (5 bytes)
    // SCK idle low
    // sample miso on rising edges
    
    reg ss_n_reg, sck_reg, mosi_reg; 
    assign ss_n = ss_n_reg; 
    assign sck = sck_reg; 
    assign mosi = mosi_reg; 
    
    reg [39:0] tx_shift; 
    reg [39:0] rx_shift; 
    
    reg [5:0] bit_count; //counts up to 40
    
    localparam ST_IDLE = 2'd0; 
    localparam ST_SHIFT = 2'd1; 
    localparam ST_DONE = 2'd2; 
    
    reg [1:0] state; 
    
    wire [7:0] rx_b0 = rx_shift[39:32]; 
    wire [7:0] rx_b1 = rx_shift[31:24]; 
    wire [7:0] rx_b2 = rx_shift[23:16]; 
    wire [7:0] rx_b3 = rx_shift[15:8]; 
    wire [7:0] rx_b4 = rx_shift[7:0]; 
    
    reg last_bit;

    always @(posedge clk) begin
      data_valid <= 1'b0;
    
      case(state)
        ST_IDLE: begin
          spi_active <= 1'b0;
          ss_n_reg   <= 1'b1;
          sck_reg    <= 1'b0;
          last_bit   <= 1'b0;
    
          if(poll_tick) begin
            tx_shift   <= {8'h80, 8'h00, 8'h00, 8'h00, 8'h00}; // see note below
            rx_shift   <= 40'd0;
            bit_count  <= 6'd0;
    
            ss_n_reg   <= 1'b0;
            spi_active <= 1'b1;
    
            // NOTE: mosi_reg uses old tx_shift here; set it explicitly:
            mosi_reg   <= 1'b1; // MSB of 8'h80 is 1
            state      <= ST_SHIFT;
          end
        end
    
        ST_SHIFT: begin
          if(sck_tick) begin
            if(sck_reg == 1'b0) begin
              // rising edge: sample
              sck_reg   <= 1'b1;
              rx_shift  <= {rx_shift[38:0], miso};
              bit_count <= bit_count + 1;
    
              if(bit_count == 6'd39)
                last_bit <= 1'b1;  // mark that we just sampled final bit
            end else begin
              // falling edge: shift out next MOSI bit
              sck_reg  <= 1'b0;
              tx_shift <= {tx_shift[38:0], 1'b0};
              mosi_reg <= tx_shift[38];
    
              // only finish once SCK has returned low after last sample
              if(last_bit) begin
                last_bit <= 1'b0;
                state    <= ST_DONE;
              end
            end
          end
        end
    
        ST_DONE: begin
          spi_active <= 1'b0;
          ss_n_reg   <= 1'b1;
          sck_reg    <= 1'b0;
    
          joy_x      <= {rx_b1[1:0], rx_b0};
          joy_y      <= {rx_b3[1:0], rx_b2};
          joy_btn    <= rx_b4[2:0];
          data_valid <= 1'b1;
    
          state      <= ST_IDLE;
        end
      endcase
    end
    
    
endmodule
