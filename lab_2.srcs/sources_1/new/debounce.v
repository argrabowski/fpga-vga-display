`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Worcester Polytechnic Institute
// Engineer: 
//  Adam Grabowski
// Create Date: 09/11/2022 12:20:48 AM
// Design Name: ECE 3829 Lab 2
// Module Name: debounce
// Project Name: ECE 3829 Lab 2
// Target Devices: Basys 3 Artix-7 Development Board
// Tool Versions: Verilog 2021.1
// Description: 
//  Specifies the inputs and outputs for the debounce circuit
// Dependencies: 
//  None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  None
//////////////////////////////////////////////////////////////////////////////////


module debounce(
    input din, // one bit input
    input clk, // 25 MHz clock
    input reset_n, // inverted reset
    output dout // one bit output
    );
    
    // Define parameters
    parameter max_count = 250_000 - 1;
    
    // Declare internal signals
    reg slow_clk = 1'b0; // 10 msec terminal count clock
    reg [23:0] count = 24'd0; // timer count
    reg Q1; // output of first flip flop
    reg Q2; // output of second flip flop
    
    // Get count from timer with 24 bit counter
    always @ (posedge clk) begin
        if (reset_n == 1'b0) begin
            count <= 24'd0;
        end else if (count == max_count) begin
            slow_clk <= 1'b1;
            count <= 24'd0;
        end else begin
            slow_clk <= 1'b0;
            count <= count + 32'd1;
        end
    end
    
    // First flip flop for debounce logic
    always @ (posedge slow_clk) begin
        Q1 <= din;
    end
    
    // Second flip flop for debounce logic
    always @ (posedge slow_clk) begin
        Q2 <= Q1;
    end
    
    // Assign final debounced output
    assign dout = Q1 & ~Q2;
    
endmodule
