module timer(input frameclk, Reset,
				 output [3:0] currNum,
				 output control_EN);
				 

	int accumulator, mod;
	assign mod = accumulator % 60;
	always_ff @(posedge frameclk)begin
		if(Reset)begin
			currNum <= 0;
			accumulator <= 0;
			control_EN <= 0;
		end
		
		else begin
			accumulator <= accumulator + 1;
			if(mod == 59) currNum <= currNum + 1;
			
			if(currNum > 9)begin
				currNum <= 0;
			end
			
			control_EN <= accumulator / 600;		
			
			
		end
			
	end
			
	

endmodule
