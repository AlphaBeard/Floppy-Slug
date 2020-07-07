`timescale 1ns / 1ps
//UP REGISTER
module Register_4bit(
    input [3:0] inData,
    input clk,
    input enable,
    input reset,
    output [3:0] outQ
    );
    
    FDRE #(.INIT(1'b0) ) register0(.C(clk), .R(reset), .CE(enable), .D(inData[0]), .Q(outQ[0]));
    FDRE #(.INIT(1'b0) ) register1(.C(clk), .R(reset), .CE(enable), .D(inData[1]), .Q(outQ[1]));
    FDRE #(.INIT(1'b0) ) register2(.C(clk), .R(reset), .CE(enable), .D(inData[2]), .Q(outQ[2]));
    FDRE #(.INIT(1'b0) ) register3(.C(clk), .R(reset), .CE(enable), .D(inData[3]), .Q(outQ[3]));

endmodule
