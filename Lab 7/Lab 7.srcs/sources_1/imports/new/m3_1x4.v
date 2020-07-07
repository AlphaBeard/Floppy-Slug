`timescale 1ns / 1ps

module m3_1x4(
    input [3:0] in0,
    input [3:0] in1, 
    input [3:0] in2,
    input sel2, sel1, sel0,
    output [3:0] o
    );

     assign o[3] =  (in0[3] & (~sel2 & ~sel1 & sel0)) | (in1[3] & (~sel2 & sel1 & ~sel0)) | (in2[3] & (sel2));
     assign o[2] =  (in0[2] & (~sel2 & ~sel1 & sel0)) | (in1[2] & (~sel2 & sel1 & ~sel0)) | (in2[2] & (sel2));
     assign o[1] =  (in0[1] & (~sel2 & ~sel1 & sel0)) | (in1[1] & (~sel2 & sel1 & ~sel0)) | (in2[1] & (sel2));
     assign o[0] =  (in0[0] & (~sel2 & ~sel1 & sel0)) | (in1[0] & (~sel2 & sel1 & ~sel0)) | (in2[0] & (sel2));
endmodule
