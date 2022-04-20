module state_controller(input Reset, Clk,
								input nextStateSig,
								output [1:0] currentState);

		logic [1:0] currS, currT;
		logic Flag;
		
		
		always_ff @ (posedge Reset or posedge Clk ) begin
			
			if(Reset) begin
				currS <= 0;
				Flag <= 1;
			end
			
			else begin
			
				if (nextStateSig == 1'b0) begin
				Flag <= 1;
				end
						
				if ((Flag == 1) & (nextStateSig == 1'b1)) begin
					Flag <= 0;
					currS <= (currS + 1) % 2;
				end
				
			end
			
		end
		
		
		
		
		assign currentState = currS;
		

endmodule
