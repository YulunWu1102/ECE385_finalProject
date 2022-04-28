module tank_selector_B (input			Clk, Reset,
							 input [7:0] 	keycode,
							 input [1:0]	currentState,
							 output[1:0]	currentTank);

		
		logic Flag_U, Flag_O;
		logic [1:0] currTank;
	
		always_ff @ (posedge Clk or posedge Reset)begin
		
			if(Reset)begin
				currTank <= 0;
				Flag_U <= 0; //u=18
				Flag_O <= 0; //o=12
			end
				
			else begin
			
			
				if (currentState == 0) begin
					
					if (keycode != 8'h18) begin
						Flag_U <= 1;
					end
					
					if(keycode != 8'h12) begin
						Flag_O <= 1;
					end
					
				
						
					if ((Flag_U == 1) & (keycode == 8'h18)) begin
						Flag_U <= 0;
						currTank <= (currTank - 1);
					
					end
					
					else if ((Flag_O == 1) & (keycode == 8'h12)) begin
						Flag_O <= 0;
						currTank <= (currTank + 1);
					
					end
				
				end
			
			
				else begin
				//do nothing
				end
			
			
			end
			
		end
		
		assign currentTank = currTank;


endmodule
