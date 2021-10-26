`timescale 1ns / 1ps
//***************************************************************//
// File name: vga_sync.v                                         //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/18/2020 02:55:21 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module vga_sync( clk     , reset  , hsync  , vsync,
			     video_on, pixel_x, pixel_y
			   );
	input          clk    , reset;
	output  [ 9:0] pixel_x, pixel_y;
	output         hsync  , vsync;
    output wire    video_on;
    
	wire h_end;
	wire h_scan_on;
	wire v_scan_on;
    wire p_tick;      

     //instaniation for Pulse Generator
     //inputs clk, reset
     //ouputs pulse
     pulse_generator tick( .clk  ( clk      ),
                      .reset( reset ),
                      .pulse( p_tick    )
                     );
	
	//instantiation for Hsync
	//input clk, reset, p_tick
	//output pixel_x, h_end, hsync, h_scan_on
    Hsync hcounter( .clk(clk),
                    .reset(reset),
                    .p_tick(p_tick),
                    .pixel_x(pixel_x),
                    .h_end(h_end),
                    .hsync(hsync),
                    .h_scan_on(h_scan_on)
                    );
    
    //instantiation for v_sync
    //input clk, reset, p_tick, h_end
    //output pixel_y, vsync, v_scan_on               
    v_sync vcounter( .clk(clk),
                     .reset(reset),
                     .p_tick(p_tick),
                     .pixel_y(pixel_y),
                     .h_end(h_end),
                     .vsync(vsync),
                     .v_scan_on(v_scan_on)
                     );
                     
	//assigning video_on
	assign video_on = h_scan_on && v_scan_on;// Only ON if both scanners are ON

endmodule
