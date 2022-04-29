module palette(input[3:0] colorIdx,
					output[23:0] rgbVal);

		logic[23:0]local_Palette[16];
		
		
	    assign local_Palette[0] = 24'hFF00FF; 
		  assign local_Palette[1] = 24'hFFFFFF;
		  assign local_Palette[2] = 24'h7A7A7A;
		  assign local_Palette[3] = 24'h2D2D2D;
		  
		  assign local_Palette[4] = 24'hFF4234;
		  assign local_Palette[5] = 24'h1C43DC;
		  assign local_Palette[6] = 24'hA31313;
		  assign local_Palette[7] = 24'hEFFF6E;
		  
		  assign local_Palette[8] = 24'h359FE9;
		  assign local_Palette[9] = 24'h136096;
		  assign local_Palette[10] = 24'h0C4065; 
		  assign local_Palette[11] = 24'h96C03d;
		  
		  assign local_Palette[12] = 24'h3A572B;
		  assign local_Palette[13] = 24'h272233;
		  assign local_Palette[14] = 24'hABCCF3;
		  assign local_Palette[15] = 24'hE21A1A;

		
		
		
		always_comb begin
			rgbVal = local_Palette[colorIdx];
			
		end

					
					
endmodule
