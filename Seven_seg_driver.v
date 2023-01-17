`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sourav Das
// 
// Create Date: 16.01.2023 19:49:08
// Design Name: Seven Segment driver
// Module Name: seven_seg_driver
// Project Name: 
// Target Devices: Basys-3 Board
// Tool Versions: 
// Description: Seven Segment driver for Basys-3 FPGA Board
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_driver(
    input clk,
    input [3:0] in0, in1, in2, in3,
    output [0:6] seg,
    output reg[3:0]an
    );
    
    reg [1:0]s = 0;         //Output of counter
    reg [3:0]mux_out = 0;   //Output of MUX
    reg clk_slow = 0;       //Output of Slow clock
    reg [15:0]count = 0;    //16-bit counter
    
    /*
    * Generate slow clk of 1000Hz from 1MHz
    * No of cycles = 0.5*(1MHz/1000Hz)=50,000
    */
    always @(posedge clk) begin 
        count <= count +1;
        if(count==50_000) begin
            count = 0;
            clk_slow <= ~clk_slow; 
        end
    end
    
    /*
    * 2-bit counter depending on clow clock
    */
    always @(posedge clk_slow) s <= s+1;    
    
    /*
    * Depending on counter value, select which segment will be ON and select input lines
    */
    always @(s)
        case(s)
            2'b00: begin an <= 4'b1110; mux_out <= in0; end
            2'b01: begin an <= 4'b1101; mux_out <= in1; end
            2'b10: begin an <= 4'b1011; mux_out <= in2; end
            2'b11: begin an <= 4'b0111; mux_out <= in3; end
        endcase
        
    /*
    * Give input signal to binary to seven segment converter
    */
    seven_segment u0(.data(mux_out), .seg(seg)); 
    
endmodule



// Binary to seven segment converter module
module seven_segment(
    input [3:0] data,		//Input data
    output reg [0:6] seg	//Output to seven segment
    );
    
     parameter    ZERO=7'b000_0001,
                  ONE=7'b100_1111,
                  TWO=7'b001_0010,
                  THREE=7'b000_0110,
                  FOUR=7'b100_1100,
                  FIVE=7'b010_0100,
                  SIX=7'b010_0000,
                  SEVEN=7'b000_1111,
                  EIGHT=7'b000_0000,
                  NINE=7'b000_0100,
                  HEX_A=7'b000_1000,
                  HEX_B=7'b110_0000,
                  HEX_C=7'b011_0001,
                  HEX_D=7'b100_0010,
                  HEX_E=7'b011_0000,
                  HEX_F=7'b011_1000;
    
    // Show output depending on input value        
    always @ (*) begin
        case (data)
            4'h0: seg=ZERO;
            4'h1: seg=ONE;
            4'h2: seg=TWO;
            4'h3: seg=THREE;
            4'h4: seg=FOUR;
            4'h5: seg=FIVE;
            4'h6: seg=SIX;
            4'h7: seg=SEVEN;
            4'h8: seg=EIGHT;
            4'h9: seg=NINE;
            4'ha: seg=HEX_A;
            4'hb: seg=HEX_B;
            4'hc: seg=HEX_C;
            4'hd: seg=HEX_D;
            4'he: seg=HEX_E;
            4'hf: seg=HEX_F;
            default: seg=7'b111_1110;
        endcase     
    end
endmodule
