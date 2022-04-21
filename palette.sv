module palette(input[3:0] colorIdx,
					output[23:0] rgbVal);

		logic[23:0]local_Palette[3:0];
		
		
		assign local_Palette[0] = 24'hB0B0B0; 
		assign local_Palette[1] = 24'h0E490A;
		assign local_Palette[2] = 24'h1A8512;
		assign local_Palette[3] = 24'h21D113;
		assign local_Palette[4] = 24'h0F3D82;
		assign local_Palette[5] = 24'h1C70EE;
		assign local_Palette[6] = 24'h75A6F0;
		assign local_Palette[7] = 24'h801313;
		assign local_Palette[8] = 24'hE60E0E;
		assign local_Palette[9] = 24'hE66868;
		assign local_Palette[10] = 0; 
		assign local_Palette[11] = 0;
		assign local_Palette[12] = 0;
		assign local_Palette[13] = 0;
		assign local_Palette[14] = 0;
		assign local_Palette[15] = 0;
		
		
		always_comb begin
			rgbVal = local_Palette[colorIdx];
			
		end

					
					
endmodule
