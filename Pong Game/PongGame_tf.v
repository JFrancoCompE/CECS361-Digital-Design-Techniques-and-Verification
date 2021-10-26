`timescale 1ns / 1ps
//***************************************************************//
// File name: PongGame_tf.v                                      //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/26/2020 06:27:41 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module PongGame_tf;
    reg clk, reset, sw;
    reg [1:0] button;
    wire hsync, vsync;
    wire [11:0] rgb;
      
    PongGame pong( .clk(clk),
                   .reset(reset),
                   .sw(sw),
                   .button(button),
                   .hsync(hsync),
                   .vsync(vsync),
                   .rgb(rgb)
                   );
   
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        button = 2'b0;
        sw = 0;
        #10 reset = 1;
        #10 reset = 0;
        button = 2'b01;//hold button to go UP for 50ms. counts down
        #50000000;
        button = 2'b00;//hold button to stay in place for 25ms.
        #50000000;
        button = 2'b10;//hold button to go DOWN for 50ms. counts up
        #50000000;

    end


endmodule
