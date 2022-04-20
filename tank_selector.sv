module tank_selector (input			Clk, Reset,
							 input [7:0] 	keycode,
							 input [1:0]	currentState,
							 output[1:0]	currentTank);

		
		logic currTank, Flag;

	
		always_ff @ (posedge Clk or posedge Reset)begin
		
			if(Reset)begin
				currTank <= 0;
				Flag <= 0;
			end
				
			else begin
			
			
				if (currentState == 0) begin
					
					if (keycode == 8'h14) begin
						Flag <= 1;
					end
					
					else if(keycode == 8'h8) begin
						Flag <= 1;
					end
					else begin
					Flag <= 0;
					end
				
						
					if ((Flag == 1) & (keycode == 8'h14)) begin
						Flag <= 0;
						currTank <= (currTank - 1) % 4;
					
					end
					
					else if ((Flag == 1) & (keycode == 8'h8)) begin
						Flag <= 0;
						currTank <= (currTank + 1) % 4;
					
					end
				
				end
			
			
				else begin
				//do nothing
				end
			
			
			end
			
		end
		
		assign currentTank = currTank;


endmodule
