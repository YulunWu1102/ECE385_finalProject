module tank_selector (input			Clk, Reset,
							 input [7:0] 	keycode,
							 input [1:0]	currentState,
							 output[1:0]	currentTank);

		
		logic currTank, Flag_Q, Flag_E;

	
		always_ff @ (posedge Clk or posedge Reset)begin
		
			if(Reset)begin
				currTank <= 0;
				Flag_Q <= 0; //Q=14
				Flag_E <= 0; //E=8
			end
				
			else begin
			
			
				if (currentState == 0) begin
					
					if (keycode != 8'h14) begin
						Flag_Q <= 1;
					end
					
					if(keycode != 8'h8) begin
						Flag_E <= 1;
					end
					
				
						
					if ((Flag_Q == 1) & (keycode == 8'h14)) begin
						Flag_Q <= 0;
						currTank <= (currTank - 1);
					
					end
					
					else if ((Flag_E == 1) & (keycode == 8'h8)) begin
						Flag_E <= 0;
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
