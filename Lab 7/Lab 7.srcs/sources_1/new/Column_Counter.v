`timescale 1ns / 1ps

module Column_Counter(
    input clk, up, 
    output UTC, Hsync, activeRegionX,
    output [9:0] column
    );

wire [15:0] fullQ;


countUD16L row_counter( .clk(clk), .up(up), .down(1'b0), .loadControl(1'b0), .reset(UTC), .loadData(16'h0000), .upperLimit(), .lowerLimit(), .outQ(fullQ));

assign column = fullQ[9:0]; // Turn 16-bit output from counter to 10-bit output

assign UTC = &{column[9], column[8], ~column[7], ~column[6], ~column[5], column[4], column[3], column[2], column[1], column[0] };     // Want top value to be 799 = 1100011111

assign Hsync = ~(  (column > 10'd654) & (column < 10'd751) ); //Hsync set to low when in region 655-750

assign activeRegionX = ~( (column > 10'd639) & (column < 10'd800) ); //Active region only inactive in this specified range; NOT to get active region. 

endmodule
