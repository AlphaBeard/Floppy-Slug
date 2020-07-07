`timescale 1ns / 1ps


module top_floppy_slug(
    input clkin, btnR, btnD, btnU, btnC,
    output Hsync, Vsync,
    output [3:0] vgaRed, vgaBlue, vgaGreen
    );
    
    wire clk, aR, frame, slugUp, slugDown; 
    wire [9:0] slugTop, slugBot; //Slug Top and Bottom pixel limits
    wire [15:0] framesQ; //frameCounter
    wire [9:0] x, y;
    
    
   
   
   
   
 
   
   ////////Constants////////////
   // 0 <= y < 480
   // 0 <= x < 640
   wire wall, obstacle0, obstacle1, obstacle2, obstacle3, obstacleReset, obstacleColumn, slug,
              hitWallTop, hitWallBot;
   wire [9:0] wallTopBound, wallBotBound, wallLeftBound,wallRightBound,
              obstacleTop, obstacleBot, obstacleLeft, obstacleRight;
   
   assign obstacleBot   = 10'd0;
   assign obstacleTop   = 10'd32;

   assign wallBotBound = 10'd8;
   assign wallTopBound = 10'd472;
   assign wallLeftBound = 10'd8;
   assign wallRightBound = 10'd632;
   
   
   
    /// RNG HEIGHT START //// 
    wire [6:0] rng;
    wire [7:0] lfsrQ;
    LFSR randomHeight(.clk(clk), .Q(lfsrQ));
    Register_4bit rngHold0(.inData(lfsrQ[3:0]), .clk(clk), .enable(obstacleReset), .reset(1'b0), .outQ(rng[3:0]));
    Register_4bit rngHold1(.inData(lfsrQ[7:4]), .clk(clk), .enable(obstacleReset), .reset(1'b0), .outQ(rng[6:4]));
    
    
   /////////// Drawing Constraints ///////////////
   assign wall = ~(y>wallBotBound & y<wallTopBound) | ~(x>wallLeftBound & x<wallRightBound);
   assign slug =  (y>slugBot & y<slugTop) & (x>10'd312 & x<10'd328); // 16x16 slug
   
   assign obstacle0  = (  y>obstacleBot + {3'b000,rng} )                  & (y<obstacleTop + {3'b000,rng} )                & (x>obstacleLeft & x<obstacleRight);      //640<x<664 240<y<272 24x32 obstacle
   assign obstacle1  = ( (y>obstacleBot + {3'b000,rng} + 10'd96)          & (y<obstacleTop + {3'b000,rng} + 10'd96)  )     & (x>obstacleLeft & x<obstacleRight);
   assign obstacle2  = ( (y>obstacleBot + {3'b000,rng} + 10'd192)         & (y<obstacleTop + {3'b000,rng} + 10'd192) )     & (x>obstacleLeft & x<obstacleRight);
   assign obstacle3  = ( (y>obstacleBot + {3'b000,rng} + 10'd288)         & (y<obstacleTop + {3'b000,rng} + 10'd288) )     & (x>obstacleLeft & x<obstacleRight);
         
   assign obstacleColumn = obstacle0 | obstacle1 | obstacle2 | obstacle3 ;
   
   /////////// Hit Detection ////////////
   assign obstacleReset = obstacleRight < wallLeftBound;    // Reset for when the obstacle hits left of screen
   assign hitWallTop = (slugTop > wallTopBound);           // hit detection for slugh hitting bottom of screen
   assign hitWallBot = (slugBot < wallBotBound);           // hit detection for slug hitting top of screen
   
  
   
   ////////////moving logic///////////
   
                //Obstacle Column 0//
   wire obstacleLeftStop;
   countUD16L obstacleMoveLeft ( .clk(clk), .up(1'b0), .down(frame & ~obstacleLeftStop), .loadControl(btnC | obstacleReset), .reset(1'b0), .loadData( {6'b0000 ,10'd640} ), .upperLimit(), .lowerLimit(obstacleLeftStop), .outQ(obstacleLeft));
   countUD16L obstacleMoveRight( .clk(clk), .up(1'b0), .down(frame),                     .loadControl(btnC | obstacleReset), .reset(1'b0), .loadData( {6'b0000 ,10'd664} ), .upperLimit(), .lowerLimit(),                 .outQ(obstacleRight));
   
                 //SLUG//
   edgeDetector slug_up  (.in(btnD  | hitWallBot), .reset(btnU | hitWallTop), .clk(clk), .out(slugUp)); //NOT ACTUALLY EDGE DETECTOR. MAKES THE BUTTON BEHAVE LIKE A SWITCH
   edgeDetector slug_down(.in(btnU  | hitWallTop), .reset(btnD | hitWallBot), .clk(clk), .out(slugDown));
    
   countUD16L slugMoveTop( .clk(clk), .up(frame & slugUp), .down(frame & slugDown), .loadControl(btnC), .reset(1'b0), .loadData( {6'b0000 ,10'd248} ), .upperLimit(), .lowerLimit(), .outQ(slugTop));
   countUD16L slugMoveBot( .clk(clk), .up(frame & slugUp), .down(frame & slugDown), .loadControl(btnC), .reset(1'b0), .loadData( {6'b0000 ,10'd232} ), .upperLimit(), .lowerLimit(), .outQ(slugBot));
      
   
   //////////////////////////////////
   
   
   // Display
    LCD_Display vgaController(.clk(clk), .activeRegion(aR), .row(y), .column(x), .Hsync(Hsync), .Vsync(Vsync), .frame(frame));
    lab7_clks clock(.clkin(clkin), .greset(btnR), .clk(clk), .digsel(), .fastclk());
    
    assign vgaBlue[3:0]  = {4{ aR & ( ~wall & ~slug & ~obstacleColumn) }} ; //Dont Draw these objects
    assign vgaRed[3:0]   = {4{ aR & ( (wall |  slug)  ) }}  ; //draw these objects
    assign vgaGreen[3:0] = {4{ aR & slug   }} ; //draw these objects
    
    
   // countUD16L frameCounter( .clk(clk), .up(frame), .down(1'b0), .loadControl(1'b0), .reset(1'b0), .loadData(16'h0000), .upperLimit(), .lowerLimit(), .outQ(framesQ));
endmodule
