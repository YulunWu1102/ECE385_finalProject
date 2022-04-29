
module  tankB ( input Reset, frame_clk,
					input [7:0] keycode,
					input hit,
               output [9:0]  TankX, TankY, TankS,
					output [1:0] Direction,
					output shoot,
					output [9:0] y_component,
					output [3:0] HP);
    
    logic [9:0] Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion, Tank_Size;
	 logic shootFlag, adjustFlag;
	 //logic [4:0] y_component;
	 
    parameter [9:0] Tank_X_Center=500;  // Center position on the X axis
    parameter [9:0] Tank_Y_Center=200;  // Center position on the Y axis
    parameter [9:0] Tank_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Tank_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Tank_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Tank_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Tank_X_Step=1;      // Step size on the X axis
    parameter [9:0] Tank_Y_Step=1;      // Step size on the Y axis

    assign Tank_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Tank
        if (Reset)  // Asynchronous Reset
        begin 
            Tank_Y_Motion <= 10'd0; //Ball_Y_Step;
				Tank_X_Motion <= 10'd0; //Ball_X_Step;
				Tank_X_Pos <= Tank_X_Center;
				Tank_Y_Pos <= 607*(Tank_X_Center**2)/1562500 - 71*Tank_X_Center/500 + 267 - 45;
				shootFlag <= 1'b0;
				shoot <= 1'b0;
				y_component <= 9'd0;
				HP <= 10;
        end
           
        else 
        begin 
				 if(hit) HP <= HP-1;
				 if(HP == 0) begin
					HP <= 10;
				 end
				 
				 if ( (Tank_Y_Pos + Tank_Size) >= Tank_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Tank_Y_Motion <= (~ (Tank_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Tank_Y_Pos - Tank_Size) <= Tank_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Tank_Y_Motion <= Tank_Y_Step;
					  
				  else if ( (Tank_X_Pos + Tank_Size) >= Tank_X_Max )  // Ball is at the Right edge, BOUNCE!
					  Tank_X_Motion <= (~ (Tank_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Tank_X_Pos - Tank_Size) <= Tank_X_Min )  // Ball is at the Left edge, BOUNCE!
					  Tank_X_Motion <= Tank_X_Step;
					  
				 else 
					  //Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 
				 case (keycode)
					8'h0d : begin
								adjustFlag <= 1'b1;
								Direction <= 0;
								if ( (Tank_X_Pos - Tank_Size) <= Tank_X_Min )  // Ball is at the Left edge, BOUNCE!
									Tank_X_Motion <= Tank_X_Step;
								else
								Tank_X_Motion <= -1;//A
								Tank_Y_Motion<= 0;
								
								
							  end
					        
					8'h0f : begin
								adjustFlag <= 1'b1;
								Direction <= 1;
							  if ( (Tank_X_Pos + Tank_Size) >= Tank_X_Max )  // Ball is at the Right edge, BOUNCE!
									Tank_X_Motion <= (~ (Tank_X_Step) + 1'b1);  // 2's complement.
							  else
								  Tank_X_Motion <= 1;//D
								  Tank_Y_Motion <= 0;
							  end

							  
					8'h0e : begin
								
								if(adjustFlag == 1'b1)begin
									adjustFlag <= 1'b0;
									y_component <= y_component + 3;
								end
								
							  //Direction <= 2;
							  if ( (Tank_Y_Pos - Tank_Size) <= Tank_Y_Min )  // Ball is at the top edge, BOUNCE!
									Tank_Y_Motion <= Tank_Y_Step;
							  else
								  Tank_Y_Motion <= 0;//S
								  Tank_X_Motion <= 0;
							 end
							  
					8'h0c : begin
								
							  
								if(adjustFlag == 1'b1)begin
									adjustFlag <= 1'b0;
									y_component <= y_component - 3;
								end
								
							  //Direction <= 3;
							  if ( (Tank_Y_Pos - Tank_Size) <= Tank_Y_Min )  // Ball is at the top edge, BOUNCE!
									Tank_Y_Motion <= Tank_Y_Step;
							  else
								  Tank_Y_Motion <= 0;//W
								  Tank_X_Motion <= 0;
							 end
							 
							 
							 
					
					8'h13 : begin //reload
								adjustFlag <= 1'b1;
								shootFlag <= 1'b0;
							  
							 end
							 
							 
							 
					
					
					8'h28 : begin
								adjustFlag <= 1'b1;
								if (shootFlag == 1'b1)begin
									shoot <= 0;
								end
								else begin
									shootFlag <= 1'b1;
									shoot <= 1;
								
								end							
								
							  end		 
					default: begin
						Tank_X_Motion <= 0;//A
						Tank_Y_Motion <= 0;
					
					end
			   endcase
				 
				 Tank_X_Pos <= (Tank_X_Pos + Tank_X_Motion);
				 Tank_Y_Pos <= 607*(Tank_X_Pos**2)/1562500 - 71*Tank_X_Pos/500 + 267 - 45;
			
			

			
		end  
    end
       
    assign TankX = Tank_X_Pos;
   
    assign TankY = Tank_Y_Pos;
   
    assign TankS = Tank_Size;
    

endmodule
