module ground_function(input	[9:0]			Tank_X_Pos,
							  output	[9:0]			Tank_Y_Pos
								);
								
	
	int calculation;
	assign calculation = 607*(Tank_X_Pos**2)/1562500 - 71*Tank_X_Pos/500 + 267;
	assign Tank_Y_Pos = calculation;


endmodule
