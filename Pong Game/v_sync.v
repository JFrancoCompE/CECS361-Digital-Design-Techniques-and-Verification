`timescale 1ns / 1ps
//***************************************************************//
// File name: v_sync.v                                           //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 12:45:12 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module v_sync(
    input clk, reset, p_tick,
    input wire h_end,
    output reg [9:0] pixel_y,
    output wire vsync,
    output wire v_scan_on
    );
    reg [9:0] V_count, nV_count;
    reg       V_sync;
    wire      nV_sync;
    wire v_end;
    
    always @(posedge clk, posedge reset)//register initialization
        if(reset) begin
             V_count <= 10'b0;
             V_sync <= 1'b0;
        end
    else
        begin
             V_count <= nV_count;
             V_sync  <= nV_sync;
        end
    
    assign v_end = (V_count == 524) ? 1'd1: 1'd0;//vertical max counter 525-1=524
    always @ (*) 
        if(p_tick & h_end) //only ON when both h_end and p_tick are the same
            if (v_end) nV_count = 1'b0;
                else    nV_count = V_count + 1'b1;
        else
            nV_count = V_count;
            
    assign nV_sync = (V_count >= 490 && V_count <= 491);//490-491
	always @(posedge clk, posedge reset)
        if (reset) begin 
            pixel_y <= 10'b0;
            end
        else begin
        pixel_y <= V_count; 
        end
        
    // assigning  VERTICAL scanner
    assign v_scan_on = (0<= pixel_y && pixel_y <= 479);//0-479
    assign vsync   = ~V_sync;//assigning vsync to be LOW ACTIVE

endmodule