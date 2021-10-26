`timescale 1ns / 1ps
//***************************************************************//
// File name: PongGame.v                                         //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/24/2020 10:37:10 AM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module PongGame(
    input         clk   , reset, sw,
    input  [ 1:0] button,
    output        hsync , vsync,
    output [11:0] rgb
    );
    wire [9:0] pixel_x , pixel_y;//wire pixel count x & pixel count y
    wire       video_on         ;//wire video on
    wire       p_tick           ;//wire for 25MHz tick           
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
                         
    //instantiation for pongAnimate
    //input clk, reset, sw, button, video_on, pixel_x, pixel_y
    //output rgb         
    pongAnimate pa( .clk      ( clk      ),
                    .reset    ( reset    ),
                    .sw       ( sw       ),
                    .button   ( button   ),                 
                    .video_on ( video_on ),
                    .pixel_x  ( pixel_x  ),
                    .pixel_y  ( pixel_y  ),
                    .rgb      ( rgb      )
                   );

endmodule    