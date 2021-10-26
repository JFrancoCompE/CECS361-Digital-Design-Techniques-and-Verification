`timescale 1ns / 1ps
//***************************************************************//
// File name: Vsync_tf.v                                         //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 03:43:46 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module Vsync_tf;
        reg clk;
        reg reset;
        reg p_tick;
        reg h_end;
        wire [9:0] pixel_y;
        wire vsync;
        wire v_scan_on;
            
        v_sync uut(
            .clk(clk), 
            .reset(reset), 
            .p_tick(p_tick),
            .pixel_y(pixel_y),
            .h_end(h_end),
            .vsync(vsync), 
            .v_scan_on(v_scan_on)
        );
       always #5 clk = ~clk;
        initial begin
          clk = 0;
          reset = 1;
          #10
          reset = 0;
          p_tick = 1;
          h_end = 1;
        end    
endmodule