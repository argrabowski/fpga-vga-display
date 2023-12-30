`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Worcester Polytechnic Institute
// Engineer: 
//  Adam Grabowski
// Create Date: 09/09/2022 10:25:17 PM
// Design Name: ECE 3829 Lab 2
// Module Name: vga_display
// Project Name: ECE 3829 Lab 2
// Target Devices: Basys 3 Artix-7 Development Board
// Tool Versions: Verilog 2021.1
// Description: 
//  Specifies the inputs and outputs for VGA display generation
// Dependencies: 
//  None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  None
//////////////////////////////////////////////////////////////////////////////////


module vga_display(
    input clk, // 25 MHz clock
    input move, // move block
    input [1:0] sw, // mode selection
    input [10:0] hcount, // VGA hcount
    input [10:0] vcount, // VGA vcount
    input blank, // VGA blank
    output [3:0] vgaRed, // VGA red
    output [3:0] vgaGreen, // VGA green
    output [3:0] vgaBlue // VGA blue
    );
    
    // Define parameters
    parameter max_count = 50_000_000 - 1;
    parameter white = 12'b000000000000;
    parameter black = 12'b111111111111;
    parameter red = 12'b111100000000;
    parameter green = 12'b000011110000;
    parameter blue = 12'b000000001111;
    parameter yellow = 12'b111100001111;
    parameter block_x = 10'd304;
    parameter block_width = 10'd32;
    parameter lower_bound = 10'd448;
    
    // Declare internal signals
    wire [11:0] allYellow; // all yellow pixel RGB color
    wire [11:0] verticalBars; // vertical bars pixel RGB color
    wire [11:0] greenBlock; // green block pixel RGB color
    wire [11:0] blueStripe; // blue stripe pixel RGB color
    reg [11:0] moveBlock = blue; // move block pixel RGB color
    wire [11:0] rgb; // final pixel RGB color
    wire update_en; // high changes block position
    reg [31:0] count = 32'd0; // timer count
    reg [9:0] block_y = 10'd0; // vertical coortinate of block
    
    // Assign red and white vertical bars mode
    assign verticalBars = (vcount[4] == 1'b0) ? red : white;
    
    // Assign right hand corner green block mode
    assign greenBlock = (hcount > 512 && vcount < 128) ? green : black;
    
    // Assign bottom blue stripe mode
    assign blueStripe = (vcount < 448) ? blue : black;
    
    // Determine whether to move block
    assign update_en = (count == max_count) ? 1'b1 : 1'b0;
    
    // Get count from timer with 32 bit counter
    always @ (posedge clk) begin
        if (move == 1'b0) begin
            count <= 32'd0;
        end else if (count == max_count) begin
            count <= 32'd0;
        end else begin
            count <= count + 32'd1;
        end
    end
    
    // Update move block pixel RGB color and vertical position
    always @ (posedge clk) begin
        if (move == 1'b0) begin
            block_y = 10'd0;
        end else if (update_en == 1'b1) begin
            moveBlock <= (hcount > block_x && hcount < (block_x + block_width) &&
                vcount > block_y && vcount < (block_y + block_width)) ? red : blue;
            block_y = (block_y < lower_bound) ? block_y + block_width : 10'd0;
        end
    end
    
    // Mux for assigning RGB color
    assign rgb = (blank == 1'b0) ? black :
        (move == 1'b1) ? moveBlock :
        (sw == 2'b00) ? yellow :
        (sw == 2'b01) ? verticalBars :
        (sw == 2'b10) ? greenBlock : blueStripe;
    
    // Assign final RGB color with part selects
    assign vgaRed = rgb[11:8];
    assign vgaGreen = rgb[7:4];
    assign vgaBlue = rgb[3:0];
    
endmodule
