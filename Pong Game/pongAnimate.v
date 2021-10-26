`timescale 1ns / 1ps
//***************************************************************//
// File name: pongAnimate.v                                      //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 04/24/2020 10:24:25 AM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//
module pongAnimate(
    input clk, reset,
    input sw,
    input video_on,
    input [1:0] button,
    input [9:0] pixel_x, pixel_y,
    output reg [11:0] rgb
    );    
    reg r_tick;
    

/**********************************************/
//PIXEL GENERATOR for 60 Hz
    reg [20:0] D;
    reg [20:0] Q;  
    always@(posedge clk, posedge reset)
        if(reset)
            Q <= 20'b0;
        else
            Q <= D;
    always@(*)         
        D = r_tick ? 20'b0: Q + 20'b1;
   
    assign r_tick_PG =(Q == ((100_000_000/60)-1));//Pulse Generator 60Hz
    assign r_tick_PC = (pixel_x==0) && (pixel_y==481);//Pong Chu's version of 60Hz
/********************************************************/
//Option to change speed
    always@(*)
        if(sw == 1'b0)//Pulse Generator 60Hz
            r_tick <= r_tick_PG;
        else if(sw == 1'b1)//Pong Chu's version of 60Hz
            r_tick <= r_tick_PC;

/******************************************************/
    wire wall_on, bar_on, ball_on, H_wall_one, H_wall_two;
    wire [11:0] wall_rgb, bar_rgb, ball_rgb, bg_rgb;
    localparam BAR_X_L = 600;
    localparam BAR_X_R = 603;
    localparam BAR_Y_SIZE = 72;
    localparam BAR_V = 4;   
    localparam WALL_X_L = 32;
    localparam WALL_X_R = 35; 
    wire [9:0] bar_y_t, bar_y_b;
    reg [9:0] bar_y_reg, bar_y_next;       
//****************************************************//
//BALL
    localparam BALL_SIZE = 16;
    wire [9:0] ball_x_l, ball_x_r;
    wire [9:0] ball_y_t, ball_y_b;
    reg  [9:0] ball_x_reg, ball_y_reg;
    wire [9:0] ball_x_next, ball_y_next;
    reg  [9:0] x_delta_reg, x_delta_next;
    reg  [9:0] y_delta_reg, y_delta_next;
    localparam BALL_V_P = 1;
    localparam BALL_V_N = -1;
    localparam MAX_X = 640;
    localparam MAX_Y = 475;
    localparam MIN_Y = 5;
    
//initializing registers
    always@(posedge clk, posedge reset)
        if(reset)begin
            bar_y_reg <= 0;
            ball_x_reg <= 0;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h001;
            y_delta_reg <= 10'h001;
        end
        else begin
            bar_y_reg <= bar_y_next;
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
        end   
/***************************************************************************************************/
//SQUARE BALL
    /*assign ball_on  = (580 <= pixel_x) && (pixel_x <= 588) &&
                      (238 <= pixel_y) && (pixel_y <= 246);*/
    assign ball_rgb = 12'hC0F; //pink
//boundary    
    assign ball_x_l = ball_x_reg;
    assign ball_y_t = ball_y_reg;
    assign ball_x_r = ball_x_l + BALL_SIZE - 1;
    assign ball_y_b = ball_y_t + BALL_SIZE - 1;
//pixels for ball
    assign ball_on = (ball_x_l <= pixel_x) && (pixel_x <= ball_x_r) &&
                     (ball_y_t <= pixel_y) && (pixel_y <= ball_y_b);    
//new ball position
    assign ball_x_next = (r_tick) ? ball_x_reg + x_delta_reg: ball_x_reg;
    assign ball_y_next = (r_tick) ? ball_y_reg + y_delta_reg: ball_y_reg;
//new ball velocity
    always@(*)begin
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
        if (ball_y_t <= (MIN_Y))//top
            y_delta_next = BALL_V_P;
        else if(ball_y_b > (MAX_Y-1))//bottom
            y_delta_next = BALL_V_N;
        else if(ball_x_l <= WALL_X_R)//wall
            x_delta_next = BALL_V_P;//bounce back
        else if((BAR_X_L <= ball_x_r) && (ball_x_r <= BAR_X_R) &&
                (bar_y_t <= ball_y_b) && (ball_y_t <= bar_y_b))//hit bounce back
            x_delta_next = BALL_V_N;
    end   
/*************************************************************************************************/    
//ROUND BALL
    wire [2:0] rom_addr, rom_col;
    reg [7:0] rom_data;
    wire rom_bit;
    wire round_ball_on;  
    always@(*)
        case(rom_addr)
             3'h0: rom_data = 8'b0011_1100;
             3'h1: rom_data = 8'b0111_1110;
             3'h2: rom_data = 8'b1101_1011;
             3'h3: rom_data = 8'b1110_0111;
             3'h4: rom_data = 8'b1110_0111;
             3'h5: rom_data = 8'b1101_1011;
             3'h6: rom_data = 8'b0111_1110;
             3'h7: rom_data = 8'b0011_1100;
        endcase
   assign rom_addr = pixel_y[2:0] - ball_y_t[2:0];
   assign rom_col = pixel_x[2:0] - ball_x_l[2:0];
   assign rom_bit = rom_data[rom_col];
   assign round_ball_on = ball_on & rom_bit;
//****************************************************//
//WALL
    assign wall_on = (32 <= pixel_x && pixel_x <= 35);//position
    assign wall_rgb = 12'h00F; //red
//****************************************************//    
//BAR
//pixel within bar                    
    assign bar_on = (BAR_X_L <= pixel_x) && (pixel_x <= BAR_X_R) &&
                    (bar_y_t <= pixel_y) && (pixel_y <= bar_y_b);
    assign bar_rgb = 12'h0F0; //green
//boundary
    assign bar_y_t = bar_y_reg;
    assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1;
//movement
    always@(*)begin
        bar_y_next = bar_y_reg;//no movement
        if(r_tick)
            if(button[0] & (bar_y_b < (MAX_Y-1-BAR_V)))
                bar_y_next = bar_y_reg + BAR_V;//move down
            else if(button[1] & (bar_y_t > BAR_V))
                bar_y_next = bar_y_reg - BAR_V;//move up
    end    
//****************************************************//
//Horizontal Walls
    assign H_wall_one = (0 <= pixel_x) && (pixel_x <= 640) &&
                        (0 <= pixel_y) && (pixel_y <= 5);
    assign H_wall_two = (0 <= pixel_x) && (pixel_x <= 640) &&
                        (475 <= pixel_y) && (pixel_y <= 480);
//****************************************************//
//BackGround
    assign bg_rgb =12'h000; //cyan for background rgb
/********************************************************/
//TREMEL
//T    
     wire [2:0] rom_addr_T, rom_col_T;
     reg [7:0] rom_data_T;
     wire rom_bit_T;      
     always@(*)
         case(rom_addr_T)           
              3'h0: rom_data_T = 8'b0111_1110;
              3'h1: rom_data_T = 8'b0111_1110;
              3'h2: rom_data_T = 8'b0001_1000;
              3'h3: rom_data_T = 8'b0001_1000;
              3'h4: rom_data_T = 8'b0001_1000;
              3'h5: rom_data_T = 8'b0001_1000;
              3'h6: rom_data_T = 8'b0001_1000;
              3'h7: rom_data_T = 8'b0001_1000;
         endcase
    wire T_on;
    assign rom_addr_T = pixel_y[2:0];
    assign rom_col_T = pixel_x[2:0];
    assign rom_bit_T = rom_data_T[rom_col_T];
    assign T_on = (280 <= pixel_x) && (pixel_x <= 287) &&
                  (200 <= pixel_y) && (pixel_y <= 207);
//R              
    wire [2:0] rom_addr_R, rom_col_R;
    reg [7:0] rom_data_R;
    wire rom_bit_R;       
      always@(*)
          case(rom_addr_R)
               3'h0: rom_data_R = 8'b1111_1110;
               3'h1: rom_data_R = 8'b1100_0110;
               3'h2: rom_data_R = 8'b1100_0110;
               3'h3: rom_data_R = 8'b0111_1110;
               3'h4: rom_data_R = 8'b0001_1110;
               3'h5: rom_data_R = 8'b0011_0110;
               3'h6: rom_data_R = 8'b0110_0110;
               3'h7: rom_data_R = 8'b1100_0110;
          endcase
     wire R_on;
     assign rom_addr_R = pixel_y[2:0];
     assign rom_col_R = pixel_x[2:0];
     assign rom_bit_R = rom_data_R[rom_col_R];
     assign R_on = (288 <= pixel_x) && (pixel_x <= 296) &&
                   (200 <= pixel_y) && (pixel_y <= 207);
//E              
    wire [2:0] rom_addr_E, rom_col_E;
    reg [7:0] rom_data_E;
    wire rom_bit_E;       
     always@(*)
         case(rom_addr_E)
              3'h0: rom_data_E = 8'b1111_1110;
              3'h1: rom_data_E = 8'b1111_1110;
              3'h2: rom_data_E = 8'b0000_0110;
              3'h3: rom_data_E = 8'b0000_0110;
              3'h4: rom_data_E = 8'b1111_1110;
              3'h5: rom_data_E = 8'b0000_0110;
              3'h6: rom_data_E = 8'b0000_0110;
              3'h7: rom_data_E = 8'b1111_1110;
         endcase
    wire E_on;
    assign rom_addr_E = pixel_y[2:0];
    assign rom_col_E = pixel_x[2:0];
    assign rom_bit_E = rom_data_E[rom_col_E];
    assign E_on = ((297 <= pixel_x) && (pixel_x <= 304) &&
                  (200 <= pixel_y) && (pixel_y <= 207))||
                  ((313 <= pixel_x) && (pixel_x <= 320) &&
                  (200 <= pixel_y) && (pixel_y <= 207));
//M              
    wire [2:0] rom_addr_M, rom_col_M;
    reg [7:0] rom_data_M;
    wire rom_bit_M;       
     always@(*)
         case(rom_addr_M)
              3'h0: rom_data_M = 8'b1000_0010;
              3'h1: rom_data_M = 8'b1100_0110;
              3'h2: rom_data_M = 8'b1100_0110;
              3'h3: rom_data_M = 8'b1110_1110;
              3'h4: rom_data_M = 8'b1010_1010;
              3'h5: rom_data_M = 8'b1011_1010;
              3'h6: rom_data_M = 8'b1001_0010;
              3'h7: rom_data_M = 8'b1001_0010;
         endcase
    wire M_on;
    assign rom_addr_M = pixel_y[2:0];
    assign rom_col_M = pixel_x[2:0];
    assign rom_bit_M = rom_data_M[rom_col_M];
    assign M_on = (305 <= pixel_x) && (pixel_x <= 312) &&
                  (200 <= pixel_y) && (pixel_y <= 207);
              
//L            
    wire [2:0] rom_addr_L, rom_col_L;
    reg [7:0] rom_data_L;
    wire rom_bit_L;       
    always@(*)
       case(rom_addr_L)
            3'h0: rom_data_L = 8'b0000_0110;
            3'h1: rom_data_L = 8'b0000_0110;
            3'h2: rom_data_L = 8'b0000_0110;
            3'h3: rom_data_L = 8'b0000_0110;
            3'h4: rom_data_L = 8'b0000_0110;
            3'h5: rom_data_L = 8'b0000_0110;
            3'h6: rom_data_L = 8'b0111_1110;
            3'h7: rom_data_L = 8'b0111_1110;
       endcase
    wire L_on;
    assign rom_addr_L = pixel_y[2:0];
    assign rom_col_L = pixel_x[2:0];
    assign rom_bit_L = rom_data_L[rom_col_L];
    assign L_on = (321 <= pixel_x) && (pixel_x <= 328) &&
                (200 <= pixel_y) && (pixel_y <= 207);
/*********************************************************/              
//HEART           
    wire [2:0] rom_addr_H, rom_col_H;
    reg [7:0] rom_data_H;
    wire rom_bit_H;       
    always@(*)
       case(rom_addr_H)
            3'h0: rom_data_H = 8'b0110_1100;
            3'h1: rom_data_H = 8'b1111_1110;
            3'h2: rom_data_H = 8'b1111_1110;
            3'h3: rom_data_H = 8'b1111_1110;
            3'h4: rom_data_H = 8'b1111_1110;
            3'h5: rom_data_H = 8'b0111_1100;
            3'h6: rom_data_H = 8'b0011_1000;
            3'h7: rom_data_H = 8'b0001_0000;
       endcase
    wire H_on;
    assign rom_addr_H = pixel_y[2:0];
    assign rom_col_H = pixel_x[2:0];
    assign rom_bit_H = rom_data_H[rom_col_H];
    assign H_on = (329 <= pixel_x) && (pixel_x <= 336) &&
                (200 <= pixel_y) && (pixel_y <= 207); 
/**********************************************************/
//WAY
//W          
    wire [2:0] rom_addr_W, rom_col_W;
    reg [7:0] rom_data_W;
    wire rom_bit_W;       
    always@(*)
       case(rom_addr_W)
            3'h0: rom_data_W = 8'b1001_0010;
            3'h1: rom_data_W = 8'b1001_0010;
            3'h2: rom_data_W = 8'b1011_1010;
            3'h3: rom_data_W = 8'b1110_1110;
            3'h4: rom_data_W = 8'b1110_1110;
            3'h5: rom_data_W = 8'b1100_0110;
            3'h6: rom_data_W = 8'b1100_0110;
            3'h7: rom_data_W = 8'b1000_0010;
       endcase
    wire W_on;
    assign rom_addr_W = pixel_y[2:0];
    assign rom_col_W = pixel_x[2:0];
    assign rom_bit_W = rom_data_W[rom_col_W];
    assign W_on = (337 <= pixel_x) && (pixel_x <= 344) &&
                (200 <= pixel_y) && (pixel_y <= 207);    

//A         
    wire [2:0] rom_addr_A, rom_col_A;
    reg [7:0] rom_data_A;
    wire rom_bit_A;       
    always@(*)
       case(rom_addr_A)
            3'h0: rom_data_A = 8'b1111_1110;
            3'h1: rom_data_A = 8'b1111_1110;
            3'h2: rom_data_A = 8'b1100_0110;
            3'h3: rom_data_A = 8'b1100_0110;
            3'h4: rom_data_A = 8'b1111_1110;
            3'h5: rom_data_A = 8'b1111_1110;
            3'h6: rom_data_A = 8'b1100_0110;
            3'h7: rom_data_A = 8'b1100_0110;
       endcase
    wire A_on;
    assign rom_addr_A = pixel_y[2:0];
    assign rom_col_A = pixel_x[2:0];
    assign rom_bit_A = rom_data_A[rom_col_A];
    assign A_on = (345 <= pixel_x) && (pixel_x <= 352) &&
                (200 <= pixel_y) && (pixel_y <= 207);  
  
//Y         
    wire [2:0] rom_addr_Y, rom_col_Y;
    reg [7:0] rom_data_Y;
    wire rom_bit_Y;       
    always@(*)
       case(rom_addr_Y)
            3'h0: rom_data_Y = 8'b1100_0110;
            3'h1: rom_data_Y = 8'b1100_0110;
            3'h2: rom_data_Y = 8'b0110_1100;
            3'h3: rom_data_Y = 8'b0111_1100;
            3'h4: rom_data_Y = 8'b0011_1000;
            3'h5: rom_data_Y = 8'b0011_1000;
            3'h6: rom_data_Y = 8'b0011_1000;
            3'h7: rom_data_Y = 8'b0011_1000;
       endcase
    wire Y_on;
    assign rom_addr_Y = pixel_y[2:0];
    assign rom_col_Y = pixel_x[2:0];
    assign rom_bit_Y = rom_data_Y[rom_col_Y];
    assign Y_on = (353 <= pixel_x) && (pixel_x <= 360) &&
                (200 <= pixel_y) && (pixel_y <= 207);    
/************************************************************/   
//assigning Text objects            
    wire Tremel_on_T;
    wire Tremel_on_R;              
    wire Tremel_on_E; 
    wire Tremel_on_M; 
    wire Tremel_on_L; 
    wire Heart_on;         
    wire Way_on_W;
    wire Way_on_A;
    wire Way_on_Y;           
    assign Tremel_on_T = T_on & rom_bit_T;
    assign Tremel_on_R = R_on & rom_bit_R;    
    assign Tremel_on_E = E_on & rom_bit_E;
    assign Tremel_on_M = M_on & rom_bit_M;  
    assign Tremel_on_L = L_on & rom_bit_L;  
    assign Heart_on = H_on & rom_bit_H;
    assign Way_on_W = W_on & rom_bit_W;
    assign Way_on_A = A_on & rom_bit_A;
    assign Way_on_Y = Y_on & rom_bit_Y; 
/**********************************************/    
/*
//SWAG PONG

    wire [3:0] rom_addr_S, rom_col_S; 
    reg [6:0] char;
    wire rom_bit_S;
    wire S_on;
    assign rom_addr_S = pixel_y[3:0];
    assign rom_col_S = pixel_x[3:0];
    assign rom_bit_S = char[rom_col_S];
    assign S_on = (80 <= pixel_x) && (pixel_x <= 224) &&
                     (80 <= pixel_y) && (pixel_y <= 96);
    wire SWAG_on;
    assign SWAG_on = S_on && rom_bit_S;    
                     
    always@(*)
        case(rom_addr_S)
            4'b0000: char = 7'h53; //S
            4'b0001: char = 7'h57; //W
            4'b0010: char = 7'h41; //A
            4'b0011: char = 7'h47; //G
            4'b0100: char = 7'h00; //space
            4'b0101: char = 7'h50; //P
            4'b0110: char = 7'h4f; //O
            4'b0111: char = 7'h4e; //N
            4'b1000: char = 7'h47; //G
            default: char = 7'h00;
         endcase   */
            


//Combo Logic for all RGB objects
    always@(*)
        if(~video_on)
            rgb = 12'hFFF; //white
        else if(wall_on || H_wall_one || H_wall_two)
            rgb = wall_rgb;//red
        else if(bar_on)
            rgb = bar_rgb;//green
        else if(round_ball_on)
            rgb = ball_rgb;//pink
        else if(Tremel_on_T || Tremel_on_R || Tremel_on_E || Tremel_on_M || Tremel_on_L)
            rgb = 12'hF0F;//purple
        else if(Heart_on)
            rgb = 12'hFFF;//white
        else if(Way_on_W || Way_on_A || Way_on_Y)
            rgb = 12'hFF0;//cyan
        else
            rgb = bg_rgb; //black  
            
endmodule