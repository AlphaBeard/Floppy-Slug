`timescale 1ns / 1ps

module LCD_Display(
    input clk,
    output [9:0] row, column,
    output Hsync, Vsync, activeRegion, frame
    );
    
    wire maxColumn, maxRow;
   
    assign activeRegion = activeRegionX & activeRegionY;
    
    Column_Counter Columns( .clk(clk), .up(1'b1), .Hsync(Hsync), .activeRegionX(activeRegionX), .column(column), .UTC(maxColumn));
    Row_Counter Rows(.clk(clk), .up(1'b1 & maxColumn), .Vsync(Vsync), .activeRegionY(activeRegionY), .row(row), .UTC(maxRow)); // Start a new row after reaching the max columns


    assign frame = &( {column[9], ~column[8], column[7], ~column[6], ~column[5], ~column[4], ~column[3], ~column[2], ~column[1], column[0]} & 
                     { ~row[9], row[8], row[7], row[6], row[5], ~row[4], ~row[3], ~row[2], ~row[1], ~row[0] } ); //binary 480
    
  

endmodule
