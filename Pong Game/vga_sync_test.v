`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 04:08:06 PM
// Design Name: 
// Module Name: vga_sync_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync_test;
    reg         clk    , reset ;
    reg  [11:0] sw     ;
    wire        hsync  , vsync;
    //wire [ 9:0] pixel_x, pixel_y;
    wire [11:0] rgb    ;
    integer i;


    //instaniate the vga sync
    //inputs clk, reset, sw, p_tick
    //ouputs hsync, vsync, video_on, pixel_x, pixel_y, rgb
    VGA_sync_top1 utt( .clk(clk),
                          .reset(reset),
                          .hsync(hsync),
                          .vsync(vsync),
                          //.p_tick(p_tick),
                          .sw(sw),
                          //.video_on(video_on),
                          //.pixel_x(pixel_x),
                          //.pixel_y(pixel_y),
                          .rgb(rgb)
                          );
    
    always #5 clk =  ~clk;
    initial begin
    #0
    clk = 0;
    reset = 1;
   // sw = 0;
    
    #10
    reset = 0;
    
    #100;
    sw = 12'h0;
    $display("NO COLOR",sw);             
    
    #100;
    sw = 12'h00F;
    $display("RED",sw);
    
    #100;
    sw = 12'h0F0;
    $display("GREEN",sw);   
    
    #100;
    sw = 12'hF00;
    $display("BLUE",sw);
    
    #100;
    sw = 12'hFFF;
    $display("WHITE ",sw);
    
    end  
endmodule
