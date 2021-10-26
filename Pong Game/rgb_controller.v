`timescale 1ns / 1ps
//***************************************************************//
// File name: rgb_controller.v                                   //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 12:55:25 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module rgb_controller(
    input clk, reset, video_on,
    input [11:0] sw,
    output [11:0] rgb
    );
    reg [11:0] rgb_reg; 
    
    always@(posedge clk, posedge reset)
        if(reset)
            rgb_reg <= 12'b0;
        else
            rgb_reg <= sw;
                 
    assign rgb = (video_on) ? rgb_reg:12'b0;

endmodule
