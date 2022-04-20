module bullet(input frame_clk, Reset,
				   input [9:0]  BallX, BallY,
					input shoot,
					input [1:0] Direction,
					output transparent,
					output [9:0] BulletX,
					output [9:0] BulletY);
					
					
	logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion;

	parameter [9:0] Bullet_X_Center=320;  // Center position on the X axis
   parameter [9:0] Bullet_Y_Center=240;  // Center position on the Y axis
   parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
   parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
   parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
   parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
   parameter [9:0] Bullet_X_Step=1;      // Step size on the X axis
   parameter [9:0] Bullet_Y_Step=1;      // Step size on the Y axis	
	parameter [2:0] Bullet_Size = 3;

	always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bullet
        if (Reset)  // Asynchronous Reset
        begin 
            Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
				Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
				Bullet_X_Pos <= Bullet_Y_Center;
				Bullet_Y_Pos <= Bullet_X_Center;
				transparent <= 1'b0;
        end
           
        else 
        begin 
				 if ( (Bullet_Y_Pos + Bullet_Size) >= Bullet_Y_Max )begin  // Ball is at the bottom edge, BOUNCE!
					  Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
				 end
					
				 else if ( (Bullet_Y_Pos - Bullet_Size) <= Bullet_Y_Min )begin  // Ball is at the top edge, BOUNCE!
					  Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
				 end
				 
				  else if ( (Bullet_X_Pos + Bullet_Size) >= Bullet_X_Max ) begin // Ball is at the Right edge, BOUNCE!
					 Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;  // 2's complement.
					end
					
				 else if ( (Bullet_X_Pos - Bullet_Size) <= Bullet_X_Min ) begin  // Ball is at the Left edge, BOUNCE!
					  Bullet_X_Motion <= 10'd0; //Ball_Y_Step;
					  Bullet_Y_Motion <= 10'd0; //Ball_X_Step;
					  transparent <= 1'b0;
					  
				 end
				 
					  //Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 else if (shoot == 1) begin
						transparent <= 1'b0;
				 
						 case (Direction)
							2'b00 : begin
										Bullet_X_Motion <= -1;//A
										Bullet_Y_Motion<= 0;
																	
										
									  end
							2'b01 : begin
										Bullet_X_Motion <= 1;//A
										Bullet_Y_Motion<= 0;
																	
										
									  end
							
							2'b10 : begin
										Bullet_X_Motion <= 0;//A
										Bullet_Y_Motion<= 1;
																	
										
									  end
							
							2'b11 : begin
										Bullet_X_Motion <= 0;//A
										Bullet_Y_Motion<= -1;
																	
										
									  end
									  
							
							
							default: ;
						endcase
				 
				 
				 end
				 
				 
				 
				 
				 
				 Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update ball position
				 Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   		
		

endmodule
