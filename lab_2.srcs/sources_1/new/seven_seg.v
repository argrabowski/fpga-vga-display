`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Worcester Polytechnic Institute
// Engineer: 
//  Adam Grabowski
// Create Date: 09/04/2022 08:41:15 PM
// Design Name: ECE 3829 Lab 2
// Module Name: seven_seg
// Project Name: ECE 3829 Lab 2
// Target Devices: Basys 3 Artix-7 Development Board
// Tool Versions: Verilog 2021.1
// Description: 
//  Specifies the inputs and outputs for the seven segment display
// Dependencies: 
//  None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  None
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input clk, // 25 MHz clock
    input reset_n, // active low reset
    input [3:0] A, // value for display A
    input [3:0] B, // value for display B
    input [3:0] C, // value for display C
    input [3:0] D, // value for display D
    output reg [6:0] seg, // seven segment display
    output reg [3:0] an // anodes for display
    );
    
    // Define parameters
    parameter max_count = 8'd255;
    parameter zero = 7'b0000001;
    parameter one = 7'b1001111;
    parameter two = 7'b0010010;
    parameter three = 7'b0000110;
    parameter four = 7'b1001100;
    parameter five = 7'b0100100;
    parameter six = 7'b0100000;
    parameter seven = 7'b0001111;
    parameter eight = 7'b0000000;
    parameter nine = 7'b0000100;
    parameter ten = 7'b0001000;
    parameter eleven = 7'b1100000;
    parameter twelve = 7'b0110001;
    parameter thirteen = 7'b1000010;
    parameter fourteen = 7'b0110000;
    parameter fifteen = 7'b0111000;
    
    // Declare internal signals
    wire update_en; // high changes display
    reg [7:0] count = 8'd0; // timer count
    reg [2:0] dis = 4'b110; // selected display
    reg [3:0] sv; // selected value
    
    // Determine whether to update display
    assign update_en = (count == max_count) ? 1'b1 : 1'b0;
    
    // Get count from timer with 8 bit counter
    always @ (posedge clk) begin
        if (reset_n == 1'b0) begin
            count <= 8'd0;
        end else if (count == max_count) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end
    
    // Change display if update signal set
    always @ (posedge clk) begin
        if (update_en == 1'b1) begin
            case (dis)
                4'b100: dis <= 4'b101;
                4'b101: dis <= 4'b110;
                4'b110: dis <= 4'b111;
                4'b111: dis <= 4'b100;
                default: dis <= 4'b100;
            endcase
        end
    end
    
    always @ (dis or reset_n or A or B or C or D) begin
        // Muxs for selecting which value to display and which display is lit using anode signals
        if (reset_n == 1'b0) begin
            an = 4'b1111;
            sv = 4'b0000;
        end else if (dis == 4'b100) begin
            an = 4'b0111;
            sv = A;
        end else if (dis == 4'b101) begin
            an = 4'b1011;
            sv = B;
        end else if (dis == 4'b110) begin
            an = 4'b1101;
            sv = C;
        end else if (dis == 4'b111) begin
            an = 4'b1110;
            sv = D;
        end else begin
            an = 4'b1111;
            sv = 4'b0000;
        end
        
        // Decoder to convert four-bit input hexadecimal value to display segment values
        case (sv)
            4'b0000: seg = zero;
            4'b0001: seg = one;
            4'b0010: seg = two;
            4'b0011: seg = three;
            4'b0100: seg = four;
            4'b0101: seg = five;
            4'b0110: seg = six;
            4'b0111: seg = seven;
            4'b1000: seg = eight;
            4'b1001: seg = nine;
            4'b1010: seg = ten;
            4'b1011: seg = eleven;
            4'b1100: seg = twelve;
            4'b1101: seg = thirteen;
            4'b1110: seg = fourteen;
            4'b1111: seg = fifteen;
        endcase
    end
    
endmodule
