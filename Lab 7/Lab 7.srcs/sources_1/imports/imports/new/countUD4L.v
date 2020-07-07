`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2019 02:23:50 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input clk, up, down, loadControl,
    input [3:0] loadData,
    input reset,
    output upperLimit, lowerLimit,
    output [3:0] outQ
    );
    wire [3:0] q, D, dw, u;
    
  
    assign upperLimit = q[3] & q[2] & q[1] & q[0];
    assign lowerLimit = ~q[3] & ~q[2] & ~q[1] & ~q[0];
 
 
    // Up logic goes into selector 
    assign u[0] = q[0] ^ up;
    assign u[1] = q[1] ^ (up & q[0]);
    assign u[2] = q[2] ^ (up & q[0] & q[1]);
    assign u[3] = q[3] ^ (up & q[0] & q[1] & q[2]);
    
       //down logic goes into selector
     assign dw[0] = q[0] ^ down;
     assign dw[1] = q[1] ^ (down & ~q[0]);
     assign dw[2] = q[2] ^ (down & ~q[0] & ~q[1]);
     assign dw[3] = q[3] ^ (down & ~q[0] & ~q[1] & ~q[2]);
     
     // selector determines which input goes into 4 bit register based on what button pressed
     // Mux is controlled by selector determing add or subtract.
     // Becuase mux is always connected directly to the register, an enable must be tied to everytime an operation is pressed.
     // add 001, sub 010, load 100
     m3_1x4 op(.in0(u), .in1(dw), .in2(loadData), .o(D), .sel2(loadControl), .sel1(down), .sel0(up));
     
     //4 bit register
     // When mux has no inputs selected, it is in invalid state. This means our enable should only be true
     // when pressing a button so the register doesnt enter invalid state
    Register_4bit register  (.reset(reset), .clk(clk), .outQ(q), .inData(D), .enable(up | down | loadControl));
    
    //output comes from output of register
    assign outQ = q; 
 
   
endmodule
