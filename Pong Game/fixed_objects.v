`timescale 1ns / 1ps
//***************************************************************//
// File name: fixed_objects.v                                    //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 03/23/2020 05:04:34 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module fixed_objects( 
    input wire            video_on,
    input wire     [ 9:0] pixel_x , pixel_y,
    output reg [11:0] rgb
    );

    wire wall_on, bar_on, ball_on, H_wall_one, H_wall_two;
    wire [11:0] wall_rgb, bar_rgb, ball_rgb, H1_rgb, H2_rgb, bg_rgb;
//****************************************************//
    //WALL   
    assign wall_on = (32 <= pixel_x && pixel_x <= 35); 
    assign wall_rgb = 12'hF00; //blue

//****************************************************//    
//BAR
    assign bar_on  = (600 <= pixel_x) && (pixel_x <= 603) &&
                     (204 <= pixel_y) && (pixel_y <= 276); 
    assign bar_rgb = 12'h0F0; //green
    
//****************************************************//
//BALL
    assign ball_on  = (580 <= pixel_x) && (pixel_x <= 588) &&
                      (238 <= pixel_y) && (pixel_y <= 246);
    assign ball_rgb = 12'h00F; //red
//****************************************************//
//Horizontal Walls
    assign H_wall_one = (0 <= pixel_x) && (pixel_x <= 640) &&
                        (0 <= pixel_y) && (pixel_y <= 5);
    assign H1_rgb = 12'h00F; //red 
    assign H_wall_two = (0 <= pixel_x) && (pixel_x <= 640) &&
                        (475 <= pixel_y) && (pixel_y <= 480);
    assign H2_rgb = 12'h00F; //red

    assign bg_rgb =12'hFF0; //cyan for background rgb
//Combo Logic
    always@(*)
        if(~video_on)begin
            rgb = 12'b0;
            end
        else begin
            if(wall_on)
                rgb = wall_rgb;
            else if(bar_on)
                rgb = bar_rgb;
            else if(ball_on)
                rgb = ball_rgb;
            else if(H_wall_one)
                rgb = H1_rgb;
            else if(H_wall_two)
                rgb = H2_rgb;
            else
                rgb = bg_rgb; //cyan
                end       
endmodule
