
module background_interface(
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [18:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [3:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [3:0] AVL_READDATA,		// Avalon-MM Read Data
	
	input logic [9:0] DrawX, DrawY,
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  colorIdx	// VGA color channels (mapped to output pins in top-level)
	//output logic hs, vs						// VGA HS/VS
);

//logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registerslogic [10:0] n_word;



logic [11:0] AVL_ADDR_;		
logic [31:0] AVL_WRITEDATA_;	
logic [31:0] AVL_READDATA_;	




//set the local AVL data to AVL_DATA or zero
always_comb begin
	if(AVL_CS) begin
		AVL_WRITEDATA_ = AVL_WRITEDATA;
		AVL_READDATA = AVL_READDATA_;
	
	end
	else begin
		AVL_WRITEDATA_ = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		AVL_READDATA = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
	end

end






								
	
OCM_0 on_chip_mem(
	.address_a(AVL_ADDR),
	.address_b(romADDR),
	.byteena_a(AVL_BYTE_EN),
	.byteena_b(4'b1111),
	.clock(CLK),
	.data_a(AVL_WRITEDATA_),
	.data_b(12'bxxxxxxxxxxxx),
	.rden_a(AVL_READ),
	.rden_b(1'b1),
	.wren_a(AVL_WRITE),
	.wren_b(1'b0),
	.q_a(AVL_READDATA_),
	.q_b(wordInfo));

   


//handle drawing (may either be combinational or sequential - or both).
		
	//get the n's word info
	
	
	
	//set in the OCM module
	//assign wordInfo = LOCAL_REG[(drawysig/16) * 20 + drawxsig / 32];
	
	
	assign charStartPos = 2 * ((drawxsig%16)/8 * 8);
		
	
	assign currChar = wordInfo[charStartPos +: 16];
	assign Address = drawysig - (drawysig/16)*16 + 16*currChar[15:8];
	
			 
	font_rom fr(.addr(Address),
					.data(currData)
						 );	
						 
always_comb begin						 
	
	bitNum = 7 - (drawxsig - (drawxsig/8)*8);
	currBit = currData[bitNum];				
	 	 
  end 


  
always_ff @(posedge VGA_Clk) begin

	if(blank) begin
		
		if(((currBit == 1'b0) && (currChar[15] == 1'b0)) || ((currBit == 1'b1) && (currChar[15] == 1'b1))) begin
			if(currChar[0] == 1'b0)begin
				red <= RGB_REG_[currChar[3:1]]  [12:9];
				green <= RGB_REG_[currChar[3:1]] [8:5];
				blue <= RGB_REG_[currChar[3:1]] [4:1];
			end
			else begin
				red <= RGB_REG_[currChar[3:1]] [24:21];
				green <=  RGB_REG_[currChar[3:1]] [20:17];
				blue <=  RGB_REG_[currChar[3:1]] [16:13];
			end
		end
		
		
			
		else begin
			if(currChar[4] == 1'b0)begin
				red <= RGB_REG_[currChar[7:5]]  [12:9];
				green <= RGB_REG_[currChar[7:5]] [8:5];
				blue <= RGB_REG_[currChar[7:5]] [4:1];
			end
			else begin
				red <= RGB_REG_[currChar[7:5]] [24:21];
				green <=  RGB_REG_[currChar[7:5]] [20:17];
				blue <=  RGB_REG_[currChar[7:5]] [16:13];
			end
		end
	
	end
		
	else begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end

end
	 
	 

endmodule