`timescale 1ns / 1ps


module testBench();

reg clkin, btnR, btnD, btnC, btnU; 
wire Hsync, Vsync;
wire [3:0] vgaRed, vgaBlue, vgaGreen;

top_floppy_slug top(.clkin(clkin), .btnR(btnR), .btnC(btnC), .btnD(btnD), .btnU(btnU), .Hsync(Hsync), .Vsync(Vsync) , .vgaRed(vgaRed), .vgaBlue(vgaBlue), .vgaGreen(vgaGreen));


   parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
    
    initial 
    begin
    
    btnR = 1'b0;
    btnD = 1'b0;
    btnC = 1'b1;
    btnU = 1'b0;
    
    
    #1000;
    
    btnC = 1'b0;
    btnD = 1'b1;
    
    #1000;
    
  
    end
    
endmodule
