`timescale 1ns / 1ps

module countUD16L(
    input clk, up, down, loadControl, reset,
    input [15:0] loadData,
    output upperLimit, lowerLimit,
    output [15:0] outQ
    );
    wire [3:0] p, q;
    
    assign lowerLimit = q[0] & q[1] & q[2] & q[3];
    assign upperLimit = p[0] & p[1] & p[2] & p[3];
    
    countUD4L count0(.clk(clk), .down(down),                      .lowerLimit(q[0]),       .up(up),                      .upperLimit(p[0]),       .outQ(outQ[3:0]),    .loadData(loadData[3:0]),    .loadControl(loadControl), .reset(reset));
    countUD4L count1(.clk(clk), .down(down & q[0]),               .lowerLimit(q[1]),       .up(up & p[0]),               .upperLimit(p[1]),       .outQ(outQ[7:4]),    .loadData(loadData[7:4]),    .loadControl(loadControl), .reset(reset));
    countUD4L count2(.clk(clk), .down(down & q[1] & q[0]),        .lowerLimit(q[2]),       .up(up & p[1] & p[0]),        .upperLimit(p[2]),       .outQ(outQ[11:8]),   .loadData(loadData[11:8]),   .loadControl(loadControl), .reset(reset) );
    countUD4L count3(.clk(clk), .down(down & q[2] & q[1] & q[0]), .lowerLimit(q[3]),       .up(up & p[2] & p[1] & p[0]), .upperLimit(p[3]),       .outQ(outQ[15:12]),  .loadData(loadData[15:12]),  .loadControl(loadControl), .reset(reset));
                
endmodule
