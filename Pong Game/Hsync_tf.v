`timescale 1ns / 1ps
//***************************************************************//
// File name: Hsync_tf.v                                         //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 02:16:46 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module Hsync_tf;
        reg clk;
        reg reset;
        reg p_tick;
        wire [9:0] pixel_x;
        wire h_end;
        wire hsync;
        wire h_scan_on;
    
        Hsync uut(
            .clk(clk), 
            .reset(reset), 
            .p_tick(p_tick),
            .pixel_x(pixel_x),
            .h_end(h_end),
            .hsync(hsync), 
            .h_scan_on(h_scan_on)
        );
       always #5 clk = ~clk;
    
        initial begin
          clk = 0;
          reset = 1;
          #10
          reset = 0;
          p_tick = 1;
        end    
 
endmodule
