`timescale 1ns / 1ps
//***************************************************************//
// File name: pulse_generator.v                                  //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/18/2020 05:22:55 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module pulse_generator(clk,reset,pulse);
    input clk, reset;
    output pulse;

    reg [1:0] D;
    reg [1:0] Q;
    wire pulse;
    
    assign pulse =(Q == 3);
    
    always@(posedge clk, posedge reset)
        if(reset)
            Q <= 2'b0;
        else
            Q <= D;
            
    always@(*)
        D = pulse ? 2'b0: Q + 2'b1;
endmodule
