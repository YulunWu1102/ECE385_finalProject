module palette(input[3:0] colorIdx,
					output[23:0] rgbVal);

		logic[23:0]local_Palette[16];
		
		
		assign local_Palette[0] = 24'hB0B0B0; 
  assign local_Palette[1] = 24'h0E490A;
  assign local_Palette[2] = 24'h1A8512;
  assign local_Palette[3] = 24'h21D113;
  assign local_Palette[4] = 24'h0F3D82;
  assign local_Palette[5] = 24'h1C70EE;
  assign local_Palette[6] = 24'h75A6F0;
  assign local_Palette[7] = 24'h801313;
  assign local_Palette[8] = 24'hE60E0E;
  assign local_Palette[9] = 24'he66868;
  assign local_Palette[10] = 24'h00ffff; 
  assign local_Palette[11] = 24'hfaf7f8;
  assign local_Palette[12] = 24'h5596f0;
  assign local_Palette[13] = 24'h3a5728;
  assign local_Palette[14] = 24'h96c03d;
  assign local_Palette[15] = 24'h272233;
		
		
		always_comb begin
			rgbVal = local_Palette[colorIdx];
			
		end

					
					
endmodule
