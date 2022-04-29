module bulletA(input [9:0] y_component,
					input frame_clk, Reset,
				   input [9:0]  TankX, TankY,
					input [9:0] TankX_enemy, TankY_enemy,
					input shoot,
					input [1:0] Direction,
					input [1:0] currentTank,
					output transparent,
					output [9:0] BulletX,
					output [9:0] BulletY,
					output 		 hit);
					
					
	logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion;
	logic [9:0] Clk_counter;
	logic [9:0] Bullet_Y_Change;
	
	logic isCarry, Ball_drop;

	parameter [9:0] Bullet_X_Center=320;  // Center position on the X axis
   parameter [9:0] Bullet_Y_Center=240;  // Center position on the Y axis
   parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
   parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
   parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
   parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
   parameter [9:0] Bullet_X_Step=5;      // Step size on the X axis
   parameter [9:0] Bullet_Y_Step=5;      // Step size on the Y axis	
	parameter [2:0] Bullet_Size = 3;

	always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bullet
        if (Reset)  // Asynchronous Reset
        begin 
            	Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
		Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
		Bullet_X_Pos <= (TankY+25);
		Bullet_Y_Pos <= (TankX+35);
		transparent <= 1'b0;
		isCarry <= 1'b1;
		Ball_drop <= 1'b0;
		Clk_counter <= 10'd0;
		hit <= 0;
        end
           
        else 
        begin 
				hit <= 0;
			
			
				 if ( (Bullet_Y_Pos + Bullet_Size) >= 607*(Bullet_X_Pos**2)/1562500 - 71*Bullet_X_Pos/500 + 267 )begin  // Ball is at the bottom edge, BOUNCE!
					  //Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  //Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
					  Bullet_Y_Change <= 0;
					  isCarry <= 1'b1;

				 end
					
				 else if ( (Bullet_Y_Pos - Bullet_Size) <= Bullet_Y_Min )begin  // Ball is at the top edge, BOUNCE!
					 // Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  //Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
					  isCarry <= 1'b1;
					  Bullet_Y_Change <= 0;
				 end
				 
				  else if ( (Bullet_X_Pos + Bullet_Size) >= Bullet_X_Max ) begin // Ball is at the Right edge, BOUNCE!
					 //Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  //Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;  // 2's complement.
					  Bullet_Y_Change <= 0;
					  isCarry <= 1'b1;
					end
					
				 else if ( (Bullet_X_Pos - Bullet_Size) <= Bullet_X_Min ) begin  // Ball is at the Left edge, BOUNCE!
					  //Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  //Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
					  Bullet_Y_Change <= 0;
					  isCarry <= 1'b1;
					  
				 end
				 
				 else if ( ((Bullet_X_Pos - Bullet_Size) >= (TankX_enemy + 30)) & ((Bullet_X_Pos - Bullet_Size) <= (TankX_enemy + 70)) & ((Bullet_Y_Pos - Bullet_Size) >= (TankY_enemy + 25)) & ((Bullet_Y_Pos - Bullet_Size) <= (TankY_enemy + 55))) begin  // Ball is at the Left edge, BOUNCE!
					  //Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  //Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
					  Bullet_Y_Change <= 0;
					  isCarry <= 1'b1;
					  hit <= 1;
					  
				 end
				 
					  //Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				
				else if(shoot == 0) begin
				hit <= 0;
					case (Direction)
							2'b00 : begin
										Bullet_X_Motion <= -7 - (2*currentTank);//A
										//Bullet_Y_Change <= -4;
																											
										
									  end
							2'b01 : begin
										Bullet_X_Motion <= 7 + (2*currentTank);//A
										//Bullet_Y_Change <= -4;
										
									  end
							
							2'b10 : begin
										Bullet_X_Motion <= Bullet_X_Motion;//A
										//Bullet_Y_Change <= y_component;
																
										
									  end
							
							2'b11 : begin
										Bullet_X_Motion <= Bullet_X_Motion;//A
										//Bullet_Y_Change <= y_component;
															
										
									  end
									  
							
							
							default: ;
						endcase
				 
				
				end
	
				 else if (shoot == 1) begin
				 hit <= 0;
						transparent <= 1'b0;
						isCarry <= 1'b0;
						
				 
				 end

				 if (isCarry == 1) begin
					Bullet_Y_Pos <= (TankY+15);  // Update ball position
					Bullet_X_Pos <= (TankX+35);
					Clk_counter <= 0;
					Bullet_Y_Change <= y_component;
				 
				 end
				 else begin
					Bullet_Y_Change <= ((Bullet_Y_Change + 1));
					Bullet_Y_Motion <= Bullet_Y_Change ;
					Clk_counter <= Clk_counter + 1;
					Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update ball position
					Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
					//Bullet_Y_Change <= 0;
				 end
				 
				 
				 
				 
      
			
		end  
    end
       
    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   		
		

endmodule
