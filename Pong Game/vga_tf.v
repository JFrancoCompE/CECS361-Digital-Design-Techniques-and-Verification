`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2020 11:19:27 PM
// Design Name: 
// Module Name: vga_tf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_tf;
    // Inputs
    reg clk;
    reg reset;
    reg [11:0] sw;
    
    // Outputs
    wire [11:0] rgb;
    wire hsync;
    wire vsync;
    //wire video_on;
    //wire [9:0] pixel_x;
    //wire [9:0] pixel_y;

    // Instantiate the Unit Under Test (UUT)
    VGA_sync_top1 uut(
        .clk(clk), 
        .reset(reset), 
        .sw(sw),
        .hsync(hsync), 
        .vsync(vsync), 
        .rgb(rgb)
        //.video_on(video_on), 
        //.pixel_x(pixel_x), 
        //.pixel_y(pixel_y)
    );
    

   always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
      #0
        clk = 0;
        reset = 1;

        // Wait 10 ns for global reset to finish
        #10
      reset = 0;
      end
      
endmodule
