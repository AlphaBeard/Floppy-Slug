`timescale 1ns / 1ps


module Row_Counter(
    input clk, up, reset,
    output UTC, Vsync, activeRegionY,
    output [9:0] row
    );
    
    wire [15:0] fullQ;
    
    
    
    countUD16L row_counter( .clk(clk), .up(up), .down(1'b0), .loadControl(1'b0), .reset(UTC), .loadData(16'h0000), .upperLimit(), .lowerLimit(), .outQ(fullQ));
    
    assign row = fullQ[9:0]; // Turn 16-bit output from counter to 10-bit output
    
    assign UTC = &{row[9], ~row[8], ~row[7], ~row[6], ~row[5], ~row[4], row[3], row[2], ~row[1], ~row[0] };     // Want top value to be 524 = 1000001100, UTC set to 525
    
    assign Vsync = ~(  (row > 10'd488) & (row < 10'd491) ); //Vsync set to low when in region
    
    assign activeRegionY = ~( (row > 10'd479) & (row < 10'd525) ); //Active region only inactive in this specified range; NOT to get active region. 
    
endmodule

