`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2020 11:30:40 PM
// Design Name: 
// Module Name: font_rom
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


module font_rom(
    input wire clk,
    input wire [10:0] addr,
    output reg [7:0] data
    );
    reg [10:0] addr_reg;
    always@(posedge clk)
        addr_reg <= addr;
        
    always@*
        case(addr_reg)
            11'h000: data = 8'b00000000;
            11'h000: data = 8'b00000000;
            11'h000: data = 8'b00000000;
            11'h000: data = 8'b00000000;
        endcase
endmodule
