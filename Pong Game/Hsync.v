`timescale 1ns / 1ps
//***************************************************************//
// File name: Hsync.v                                            //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/24/2020 12:44:12 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module Hsync(
    input clk, reset, p_tick,
    output reg [9:0] pixel_x,
    output wire h_end,
    output wire hsync,
    output wire h_scan_on
    );
    reg [9:0] H_count, nH_count; //register initialization
    reg       H_sync;
    wire      nH_sync;
    
    always @(posedge clk, posedge reset)
        if(reset) begin
             H_count <= 10'b0;
             H_sync <= 1'b0;
        end
    else
        begin
             H_count <= nH_count;
             H_sync  <= nH_sync;
        end

    assign h_end = (H_count == 799) ? 1'd1: 1'd0;//horizontal max counter 800-1=799
            
    always @ (*)
        if(p_tick)
            if (h_end)
                nH_count = 1'b0;
            else
                nH_count = H_count + 1'b1;
        else 
            nH_count = H_count; 
            
	assign nH_sync = (H_count >= 656 && H_count <= 751);//656-751

    always @(posedge clk, posedge reset)
		if (reset) begin 
			pixel_x <= 10'b0;
			end
		else begin
		pixel_x <= H_count;
		end   
     // assigning HORIZONTAL scanner
    assign h_scan_on = (0<= pixel_x && pixel_x <= 639);//0-639
    assign hsync   = ~H_sync;//hsync to be LOW ACTIVE

endmodule