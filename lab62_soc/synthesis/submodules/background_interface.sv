module background_interface(
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic [15:0] LOCAL_ADDR,
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [15:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [7:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [7:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [7:0]  backgroundDATA);						// VGA HS/VS)




OCM_background ocm_bg(
	.address_a(AVL_ADDR),
	.address_b(LOCAL_ADDR),
	.clock(CLK),
	.data_a(AVL_WRITEDATA),
	.data_b(8'bxxxxxxxx),
	.wren_a(AVL_WRITE),
	.wren_b(1'b0),
	.q_a(AVL_READDATA),
	.q_b(backgroundDATA));
	
	
	
	
	
	
	
	
endmodule
