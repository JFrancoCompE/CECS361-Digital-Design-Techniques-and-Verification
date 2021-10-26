`timescale 1ns / 1ps
//***************************************************************//
// File name: pulse generator_tf.v                               //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/17/2020 04:27:32 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module pulse_generator_tf;   
    reg clk, reset;
    wire pulse;
     
    pulse_generator dut( .clk  ( clk   ),
                         .reset( reset ),
                         .pulse( pulse )
                         );
                     
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
endmodule
