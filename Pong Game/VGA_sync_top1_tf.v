//***************************************************************//
// File name: VGA_sync_top1_tf.v                                 //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/18/2020 12:28:56 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module VGA_sync_top1_tf;
    reg clk;
    reg reset;
    reg [11:0] sw;
    
    wire hsync;
    wire vsync;
    wire [11:0] rgb;

    vga_sync_top1 uut (
        .clk(clk), 
        .reset(reset), 
        .sw(sw),
        .rgb(rgb),
        .hsync(hsync), 
        .vsync(vsync), 
    );

   always #5 clk = ~clk;

    initial begin
      clk = 0;
      reset = 1;
      #10
      reset = 0;
    end


endmodule