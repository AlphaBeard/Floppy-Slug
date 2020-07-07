`timescale 1ns / 1ps

module LFSR(
    input clk,
    output [7:0] Q
    );
    
    wire [7:0] rnd;
    
    assign Q = rnd;
    
    wire in;
    
    assign in = rnd[0]^rnd[5]^rnd[6]^rnd[7];
    
      FDRE #(.INIT(1'b0) ) FF7to1[7:1]         (.C( {7{clk}} ), .R({7{1'b0}}),  .CE({7{1'b1}}),   .D(rnd[6:0]),        .Q(rnd[7:1]));
      FDRE #(.INIT(1'b1) ) FF0                 (.C(    clk   ), .R(1'b0),       .CE(1'b1),        .D(in),                .Q(rnd[0]));
      
endmodule
