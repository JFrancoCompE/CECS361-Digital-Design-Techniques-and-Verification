`timescale 1ns / 1ps
//***************************************************************//
// File name: fixed_objects_tf.v                                 //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/17/2020 02:20:18 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module fixed_objects_tf;
    reg         video_on;
    reg  [ 9:0] pixel_x, pixel_y;
    wire [11:0] rgb;
    
    integer i;

    fixed_objects dut( .video_on( video_on ),
                       .pixel_x ( pixel_x  ),
                       .pixel_y ( pixel_y  ),
                       .rgb     ( rgb      )
                       );
initial begin
video_on = 0;
pixel_y = 0;

//Verifying Left Wall
pixel_x = 30;
$display("CHECKING FOR LEFT WALL");
for(i = 0; i < 10; i = i + 1)begin //checks pixel x count numbers 31-40
    pixel_x = pixel_x + 1;
    if( 32 <= pixel_x && pixel_x <= 35)
        $display("Correct at pixel x count: %d and BLUE RGB: %h", pixel_x, dut.wall_rgb);        
    else
        $display("WRONG at pixel x count: %d", pixel_x);
end

/*********************************************************************************/
//Verifying Right Bar
pixel_x = 599;
pixel_y = 200;
$display("CHECKING FOR RIGHT BAR");
for(i = 0; i < 5; i = i + 1)begin //checks pixel x count numbers 600-605
    pixel_x = pixel_x + 1;
    if( 600 <= pixel_x && pixel_x <= 603)
        $display("Correct at pixel x count: %d and GREEN RGB: %h", pixel_x, dut.bar_rgb);        
    else
        $display("WRONG at pixel x count: %d", pixel_x);
end
for(i = 0; i < 100; i = i + 1)begin //checks pixel y count numbers 201-300
    pixel_y = pixel_y + 1;
    if( 204 <= pixel_y && pixel_y <= 276)
        $display("Correct at pixel y count: %d and GREEN RGB: %h", pixel_y, dut.bar_rgb);        
    else
        $display("WRONG at pixel y count: %d", pixel_y);
end

/***************************************************************************/    
//Verifying Ball
pixel_x = 575;
pixel_y = 235;
$display("CHECKING FOR Ball");
for(i = 0; i < 15; i = i + 1)begin //checks pixel x count numbers 576-590
    pixel_x = pixel_x + 1;
    if( 580 <= pixel_x && pixel_x <= 588)
        $display("Correct at pixel x count: %d and RED RGB: %h", pixel_x, dut.ball_rgb);        
    else
        $display("WRONG at pixel x count: %d", pixel_x);
end
for(i = 0; i < 15; i = i + 1)begin //checks pixel y count numbers 236-250
    pixel_y = pixel_y + 1;
    if( 238 <= pixel_y && pixel_y <= 246)
        $display("Correct at pixel y count: %d and RED RGB: %h", pixel_y, dut.ball_rgb);        
    else
        $display("WRONG at pixel y count: %d", pixel_y);
end

/****************************************************************************/
//Verifying Horizontal Walls 1
$display("CHECKING FOR HORIZONTAL WALL 1");
pixel_x = 0;
if (pixel_x == 0) //checking if pixel_count is 0. should be correct
    $display("Correct at pixel x count: %d and RED RGB: %h", pixel_x, dut.H1_rgb);   
else
    $display("WRONG");  
       
pixel_x = 640;
if (pixel_x == 640) //checking if pixel_count is 640. should be correct
    $display("Correct at pixel x count: %d and RED RGB: %h", pixel_x, dut.H1_rgb);   
else
    $display("WRONG");  
    
pixel_x = 641;
    if (pixel_x == 641) //checking if pixel_count is 640. should be wrong
        $display("WRONG at pixel x count: %d", pixel_x);   
    else
        $display("CORRECT");
          
pixel_y = 0;         
for(i = 0; i < 10; i = i + 1)begin //checks pixel y count numbers 0-10
    if( 0 <= pixel_y && pixel_y <= 5)
        $display("Correct at pixel y count: %d and RED RGB: %h", pixel_y, dut.H1_rgb);        
    else begin
        $display("WRONG at pixel y count: %d", pixel_y);
    end
    
    pixel_y = pixel_y + 1;
end

/**************************************************************************/
//Verifying Horizontal Wall 2
$display("CHECKING FOR HORIZONTAL WALL 2");
pixel_x = 0;
if (pixel_x == 0) //checking if pixel_count is 0. should be correct
    $display("Correct at pixel x count: %d and RED RGB: %h", pixel_x, dut.H2_rgb);   
else
    $display("WRONG");  
       
pixel_x = 640;
if (pixel_x == 640) //checking if pixel_count is 640. should be correct
    $display("Correct at pixel x count: %d and RED RGB: %h", pixel_x, dut.H2_rgb);   
else
    $display("WRONG");  
    
pixel_x = 641;
    if (pixel_x == 641) //checking if pixel_count is 640. should be wrong
        $display("WRONG at pixel x count: %d", pixel_x);   
    else
        $display("CORRECT");
          
pixel_y = 475;         
for(i = 0; i < 10; i = i + 1)begin //checks pixel y count numbers 470-480
    if( 475 <= pixel_y && pixel_y <= 480)
        $display("Correct at pixel y count: %d and RED RGB: %h", pixel_y, dut.H2_rgb);        
    else begin
        $display("WRONG at pixel y count: %d", pixel_y);
    end
    pixel_y = pixel_y + 1;
end

/***************************************************************************************/
//Verifying background rgb
$display("BACKGROUND RGB IS CYAN: %h", dut.bg_rgb);         

end
endmodule