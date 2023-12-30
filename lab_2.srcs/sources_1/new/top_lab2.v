`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Worcester Polytechnic Institute
// Engineer: 
//  Adam Grabowski
// Create Date: 09/04/2022 09:17:13 PM
// Design Name: ECE 3829 Lab 2
// Module Name: top_lab2
// Project Name: ECE 3829 Lab 2
// Target Devices: Basys 3 Artix-7 Development Board
// Tool Versions: Verilog 2021.1
// Description: 
//  Specifies the inputs and outputs for the top module
// Dependencies: 
//  None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  None
//////////////////////////////////////////////////////////////////////////////////


module top_lab2(
    input clk, // 100 MHz clock
    input [1:0] sw, // mode selection
    input btnC, // active high reset
    input btnU, // move block
    output [6:0] seg, // seven segment display
    output [3:0] an, // anodes for display
    output Hsync, // VGA HS
    output Vsync, // VGA VS
    output [3:0] vgaRed, // VGA red
    output [3:0] vgaGreen, // VGA green
    output [3:0] vgaBlue // VGA blue
    );
    
    // Initialize display value parameters
    parameter [3:0] A = 4'b0110; // display A value
    parameter [3:0] B = 4'b0101; // display B value
    parameter [3:0] C = 4'b1000; // display C value
    parameter [3:0] D = 4'b0110; // display D value
    
    // Declare internal signals
    wire clk_25MHz; // 25 MHz clock
    wire reset_n; // active low reset
    wire reset; // active high reset
    wire [10:0] hcount; // VGA hcount
    wire [10:0] vcount; // VGA vcount
    wire blank; // VGA blank
    wire [1:0] sw_d; // debounced mode selection
    wire pb_d; // debounced move block
    
    // Instantiate MMCM module
    clk_mmcm_wiz clk_mmcm_wizi(
    .clk_in1(clk), // 100 MHz clock
    .reset(btnC), // active high reset
    .clk_25MHz(clk_25MHz), // 25 MHz clock
    .locked(reset_n)); // locked reset
    
    // Instantiate seven segment display module
    seven_seg seven_segi(
    .clk(clk_25MHz), // 25 MHz clock
    .reset_n(reset_n), // active low reset
    .A(A), // display A value
    .B(B), // display B value
    .C(C), // display C value
    .D(D), // display D value
    .seg(seg), // seven segment display
    .an(an)); // anode signals for display
    
    // Invert reset signal for VGA controller
    assign reset = ~reset_n;
    
    // Instantiate VGA controller module
    vga_controller_640_60 vga_controller_640_60i(
    .rst(reset), // active high reset
    .pixel_clk(clk_25MHz), // 25 MHz clock
    .HS(Hsync), // VGA HS
    .VS(Vsync), // VGA VS
    .hcount(hcount), // VGA hcount
    .vcount(vcount), // VGA vcount
    .blank(blank)); // VGA blank
    
    // Instantiate debounce circuit for mode selection
    debounce debouncei(
    .din(sw[0]), // mode selection
    .clk(clk_25MHz), // 25 MHz clock
    .reset_n(reset_n), // active low reset
    .dout(sw_d[0]) // debounced mode selection
    );
    
    // Instantiate debounce circuit for mode selection
    debounce debouncej(
    .din(sw[1]), // mode selection
    .clk(clk_25MHz), // 25 MHz clock
    .reset_n(reset_n), // active low reset
    .dout(sw_d[1]) // debounced mode selection
    );
    
    // Instantiate debounce circuit for move block
    debounce debouncek(
    .din(btnU), // move block
    .clk(clk_25MHz), // 25 MHz clock
    .reset_n(reset_n), // active low reset
    .dout(pb_d) // debounced move block
    );
    
    // Instantiate VGA display generation module
    vga_display vga_displayi(
    .clk(clk_25MHz), // 25 MHz clock
    .move(pb_d), // debounced move block
    .sw(sw_d), // debounced mode selection
    .hcount(hcount), // VGA hcount
    .vcount(vcount), // VGA vcount
    .blank(blank), // VGA blank
    .vgaRed(vgaRed), // VGA reg
    .vgaGreen(vgaGreen), // VGA green
    .vgaBlue(vgaBlue)); // VGA blue
    
endmodule
