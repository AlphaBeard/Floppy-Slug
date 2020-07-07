`timescale 1ns / 1ps

module edgeDetector(
    input in, clk, reset,
    output out
    );
    
    FDRE #(.INIT(1'b0) ) registerw(.C(clk), .R(reset), .CE(in), .D(in), .Q(out));

endmodule
