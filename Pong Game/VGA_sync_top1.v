`timescale 1ns / 1ps
//***************************************************************//
// File name: VGA_sync_top1.v                                    //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/18/2020 12:28:56 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module VGA_sync_top1(
    input         clk  , reset,
    input  [11:0] sw   ,
    output        hsync, vsync,
    output [11:0] rgb
    );
    wire [9:0] pixel_x , pixel_y;//wire pixel count x & pixel count y
    wire       video_on         ;//wire video on
    wire       p_tick           ;//wire for 25Hz tick           
    wire       resetNew         ;//wire for AISO output
    
    
    //instantiation
    //inputs clk, reset
    //outputs resetNew
     AISO asio( .clk     ( clk      ),
                .reset   ( reset    ),
                .resetNew( resetNew )
               );    

    //instantiation for VGA Sync
    //inputs clk, reset, sw, p_tick
    //outputs hsync, vsync, video_on, pixel_x, pixel_y, rgb
    vga_sync vgaObject( .clk      ( clk      ),
              .reset    ( resetNew ),
              .hsync    ( hsync    ),
              .vsync    ( vsync    ), 
              .video_on ( video_on ),
              .pixel_x  ( pixel_x  ),
              .pixel_y  ( pixel_y  )
             );
    //instantiation for rgb_controller
    //input clk, reset, video_on, sw
    //output rgb         
    /*rgb_controller color( .clk(clk),
                          .reset(resetNew),
                          .video_on(video_on),
                          .sw(sw),
                          .rgb(rgb)
                          );*/
                          
    //instantiation for fixed_objects
    //input video_on, pixel_x, pixel_y
    //output rgb         
    fixed_objects fo( .video_on(video_on),
                      .pixel_x(pixel_x),
                      .pixel_y(pixel_y),
                      .rgb(rgb)
                     );

endmodule    