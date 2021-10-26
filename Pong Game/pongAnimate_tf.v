`timescale 1ns / 1ps
//***************************************************************//
// File name: pongAnimate_tf.v                                   //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/26/2020 05:46:00 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module pongAnimate_tf;
    reg clk, reset, sw, video_on;
    reg [1:0] button;
    reg [9:0] pixel_x, pixel_y;
    wire [11:0] rgb;

    pongAnimate utt( .clk(clk),
                     .reset(reset),
                     .sw(sw),
                     .video_on(video_on),
                     .button(button),
                     .pixel_x(pixel_x),
                     .pixel_y(pixel_y),
                     .rgb(rgb)
                     );
   
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        video_on = 0;
        button = 0;
        pixel_x = 0;
        pixel_y = 0;
        sw = 0;//Testing for Pong Chu's 60Hz
        video_on = 1;
        reset = 1;
        #10 reset = 0;//Testing for Pulse generator 60Hz
        
        //When ball hits the bottom wall
        //Ball comes from origin
        //Ball is coming at a down-right  direction
        utt.ball_x_reg = 400; //Left ball is 400, right ball is 415
        utt.ball_y_reg = 455; //top ball is 450, bot ball is 465
        #200000000;//run for 200 ms
    
        //When ball hits paddle
        //Paddle is currently stationed at the top
        //ball is coming at a up-right direction
        utt.ball_x_reg = 580;
        utt.ball_y_reg = 50;
        #200000000;//run for 100ms
        
        //When ball hits top wall
        //ball is coming at a up-left direcion
        utt.ball_x_reg = 200; //left side of ball
        utt.ball_y_reg = 8;
        #100000000;//run for 100ms
        
        //When ball hits left wall
        //ball is coming at a down-left direction
        utt.ball_x_reg = 38;
        utt.ball_y_reg = 200;
        #100000000;//run for 100ms
        
        //Test When ball hits bottom wall again
        //ball is coming at a down-right location
        utt.ball_x_reg = 200;
        utt.ball_y_reg = 457;
        #100000000;//run for 100ms
        
        //Test When the game will restart
        //My x register will count to 1024 since
        //they are 10 bits in order to reset
        //This will give the player some breathing me
        utt.ball_x_reg = 1022;
        utt.ball_y_reg = 200;
    end
endmodule
