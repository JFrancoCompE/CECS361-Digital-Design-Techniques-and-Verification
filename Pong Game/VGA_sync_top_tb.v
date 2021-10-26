`timescale 1ns / 1ps
//***************************************************************//
// File name: VGA_sync_top_tb_.v                                 //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 02:40:10 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module VGA_sync_top_tb;
    reg clk;
    reg reset;
    reg [11:0] sw;
    wire hsync;
    wire vsync;
    wire [11:0] rgb;

    wire p_tick;
    
VGA_sync_top1 uut(
    .clk(clk), 
    .reset(reset), 
    .sw(sw),
    .hsync(hsync),
    .vsync(vsync), 
    .rgb(rgb)
    );

always #5 clk = ~clk;

initial begin
  #0
  clk = 0;
  reset = 1;
  sw = 12'h00F;
  #10
  reset = 0;

  
end    
endmodule
