//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Yulun Wu                                                           --
//    April 2022                                                         --
//                                                                       --                                       
//                                                                       --
//    For Final Project: Tank Stars                                      --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input logic			VGA_Clk, Reset,
							  input        [9:0] TankX_A, TankY_A, BulletX_A, BulletY_A, DrawX, DrawY, Ball_size,
							  input 			[1:0] Direction_A,
							  input        [9:0] TankX_B, TankY_B, BulletX_B, BulletY_B, 
							  input 			[1:0] Direction_B,
							  input			transparent,
							  input 			[1:0] currentState, currentTank_A,currentTank_B,
							  input			[7:0]  vga_port_backgrounddata,
							  output 		[15:0] vga_port_local_addr,
							  output logic [7:0]  Red, Green, Blue );
    
    logic ball_on_A, bullet_on_A, select_on_A;
	 logic ball_on_B, bullet_on_B, select_on_B;
	 logic [7:0] currData;
	 logic [4:0] currBGIdx;
	 logic [23:0] currBG_RGB;
	 //-----------------calculate the background address to feed to OCM-----------------
	 assign vga_port_local_addr = ((DrawY / 2) * 320 + DrawX / 2)/2;
	 
	 always_comb begin: bg_logic
		if(DrawX % 2 == 0)begin
			currBGIdx = vga_port_backgrounddata[7:4];
		end
		else begin
			currBGIdx = vga_port_backgrounddata[3:0];
		end
	 
	 end
	 
	 palette bg(.colorIdx(currBGIdx), .rgbVal(currBG_RGB));
	 
	 
		
	 //-----------------calculate co-ord to tank-----------------
    int DistX_A, DistY_A, DistX_B, DistY_B;
	 assign DistX_A = DrawX - TankX_A;
    assign DistY_A = DrawY - TankY_A;
	 assign DistX_B = DrawX - TankX_B;
    assign DistY_B = DrawY - TankY_B;
    
	 
	 //-----------------calculate co-ord to bullet-----------------
	 int Bullet_DistX_A, Bullet_DistY_A, Size, Bullet_DistX_B, Bullet_DistY_B;
	 assign Bullet_DistX_A = DrawX - BulletX_A;
    assign Bullet_DistY_A = DrawY - BulletY_A;
	 assign Bullet_DistX_B = DrawX - BulletX_B;
    assign Bullet_DistY_B = DrawY - BulletY_B;
    assign Size = 4;
	 
	 
	 
	 //state 0: select display
	 parameter [9:0] Select_X_Center=320;  // Center position on the X axis
    parameter [9:0] Select_Y_Center=240; 
	 int DistX_S, DistY_S;
	 assign DistX_s = DrawX - Select_X_Center;
    assign DistY_s = DrawY - Select_Y_Center;
	 
	 
	 
	  
	  
	  
	 int TankX_coord, TankY_coord;
	 
//	 always_comb
//    begin: adjust_coor
//        if ( (DistX <= 70) & (DistY <= 50) & (DistX >= 0) & (DistY >= 0)  ) begin
//            TankX = DistX;
//				TankY = DistY;
//		  end
//		  
//        else begin
//            TankX = 0;
//				TankY = 0;
//		  end
//    end 
	 
	 
	 
	//important trY::::::::::::::::::::::::::::::::: ROTATION MATRIX CALCULATION FOR TANK A :::::::::::::::::::::::::::::::::
	int TankA_End_Y;
	int TankA_delta_Y;
	assign TankA_End_Y = 607*((TankX_A+65)**2)/1562500 - 71*TankX_A/500 + 267 - 45;
	assign TankA_delta_Y = TankA_End_Y - TankY_A;
	//Rotation Matrix: 
	//x' = x*cos(a) -y*sin(a), y' = x*sin(a)+y*cos(a)
	//small angle theorem: tan(a) = a = TankA_delta_Y / Length
	//cos(a) = (1-tan^2(a/2))/(1+tan^2(a/2)) = (4*(L**2)-(TankA_delta_Y**2))/(4*(L**2)+(TankA_delta_Y**2))
	//sin(a) = (2tan(a/2))/(1+tan^2(a/2)) = (4*TankA_delta_Y*L)/(4*(L**2)+(TankA_delta_Y**2))
	int TankA_Rotate_X, TankA_Rotate_Y;
	always_comb begin
		TankA_Rotate_X = DistX_A*(4*(70**2)-(TankA_delta_Y**2))/(4*(70**2)+(TankA_delta_Y**2))+DistY_A*(4*TankA_delta_Y*70)/(4*(70**2)+(TankA_delta_Y**2));
		TankA_Rotate_Y = DistY_A*(4*(70**2)-(TankA_delta_Y**2))/(4*(70**2)+(TankA_delta_Y**2))-DistX_A*(4*TankA_delta_Y*70)/(4*(70**2)+(TankA_delta_Y**2));
		
		if(TankA_Rotate_X > 70) TankA_Rotate_X = 70;
		else begin
			if(TankA_Rotate_X < 0) TankA_Rotate_X = 0;
			else begin
				TankA_Rotate_X = TankA_Rotate_X;
			end		
		end
		
		if(TankA_Rotate_Y > 50) TankA_Rotate_X = 50;
		else begin
			if(TankA_Rotate_X < 0) TankA_Rotate_X = 0;
			else begin
				TankA_Rotate_X = TankA_Rotate_X;
			end		
		end
	
	end
	
	  

	//-----------------palette on tank_0 (A) -----------------
	logic [15:0] currentTankADDR_A;
	assign currentTankADDR_A = (TankA_Rotate_Y * 70) + TankA_Rotate_X;	
	logic [7:0] colorIdx_tank_A;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_A( .addr(currentTankADDR_A), .tankSelection(currentTank_A), .data(colorIdx_tank_A), .Direction(Direction_A));
	logic [23:0] color_tank_0;
	palette plt_tank_0(.colorIdx(colorIdx_tank_A[7:4]), .rgbVal(color_tank_0));
	
	
	
	//-----------------palette on tank_1 (B) -----------------
	logic [15:0] currentTankADDR_B;
	assign currentTankADDR_B = (DistY_B * 70) + DistX_B;	
	logic [7:0] colorIdx_tank_B;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_B( .addr(currentTankADDR_B), .tankSelection(currentTank_B), .data(colorIdx_tank_B), .Direction(Direction_B));
	logic [23:0] color_tank_1;
	palette plt_tank_1(.colorIdx(colorIdx_tank_B[7:4]), .rgbVal(color_tank_1));

	
	
	//-----------------palette on bullet (A) -----------------
	logic [23:0] color_bullet_0;
	assign color_bullet_0[23:16] = (4-currentTank_A) * 16;
	assign color_bullet_0[15:8] = currentTank_A * 16;
	assign color_bullet_0[7:0] = (4-currentTank_A) * 16;
	
	
	
	//-----------------palette on bullet (B) -----------------
	logic [23:0] color_bullet_1;
	assign color_bullet_1[23:16] = (4-currentTank_B) * 16;
	assign color_bullet_1[15:8] = currentTank_B * 16;
	assign color_bullet_1[7:0] = (4-currentTank_B) * 16;
	

	
	//-----------------palette on background -----------------
//	logic [18:0] currentBackgroundADDR;
//	assign currentBackgroundADDR = (DrawY * 640) + DrawX;	
//	logic [3:0] colorIdx_background;
//	//assign colorIdx = 4'h3;
//	background_rom bgd( .addr(currentBackgroundADDR), .data(colorIdx_background));
//	logic [23:0] color_background;
//	palette plt_background_1(.colorIdx(colorIdx_background), .rgbVal(color_background));

	
	always_comb
    begin:select_on_proc1
        if ( (DistX_A <= 70) & (DistY_A <= 50) & (DistX_A >= 0) & (DistY_A >= 0)  ) 
            select_on_A = 1'b1;
        else 
		  select_on_A = 1'b0;
		end 
           
	
	  
    always_comb
    begin:Ball_on_proc1
        if ( (DistX_A <= 70) & (DistY_A <= 50) & (DistX_A >= 0) & (DistY_A >= 0)  ) 
            ball_on_A = 1'b1;
        else 
            ball_on_A = 1'b0;
     end 
	  
	 always_comb
    begin:Bullet_on_proc1
        if (( ( Bullet_DistX_A*Bullet_DistX_A + Bullet_DistY_A*Bullet_DistY_A) <= (Size * Size))) 
            bullet_on_A = 1'b1;
        else 
            bullet_on_A = 1'b0;
     end 
       
		 
	
	  always_comb
    begin:select_on_proc2
        if ( (DistX_B <= 70) & (DistY_B <= 50) & (DistX_B >= 0) & (DistY_B >= 0)  ) 
            select_on_B = 1'b1;
        else 
		  select_on_B = 1'b0;
		end 
           
	
	  
    always_comb
    begin:Ball_on_proc2
        if ( (DistX_B <= 70) & (DistY_B <= 50) & (DistX_B >= 0) & (DistY_B >= 0)  ) 
            ball_on_B = 1'b1;
        else 
            ball_on_B = 1'b0;
     end 
	  
	 always_comb
    begin:Bullet_on_proc2
        if (( ( Bullet_DistX_B*Bullet_DistX_B + Bullet_DistY_B*Bullet_DistY_B) <= (Size * Size))) 
            bullet_on_B = 1'b1;
        else 
            bullet_on_B = 1'b0;
     end 
	
		 
		 
		 
		 
	always_ff @(posedge VGA_Clk or posedge Reset)
    begin:RGB_Display
	 
		case (currentState)
			
			2'b00	:	begin //selection
				 if (select_on_A) begin
				 
						Red <= color_tank_0[23:16];
						Green <= color_tank_0[15:8];
						Blue <= color_tank_0[7:0]; 
				 
				 end
				 else if (select_on_B) begin
				 
					Red <= color_tank_1[23:16];
					Green <= color_tank_1[15:8];
					Blue <= color_tank_1[7:0]; 
					 
				 end
							
				else begin
					Red <= currBG_RGB[23:16];
					Green <= currBG_RGB[15:8];
					Blue <= currBG_RGB[7:0]; 
				
				end
							
			
			end
			
			2'b01 : begin //fight color_rtk
			
			
			
			if(ball_on_A)begin//A is on or not
				if(ball_on_B) begin//bis on or not
					if(bullet_on_A)begin
						if(bullet_on_B) begin //priority is bullet B
							Red <= color_bullet_1[23:16];
							Green <= color_bullet_1[15:8];
							Blue <= color_bullet_1[7:0];
						end
						else begin //second priority is bullet A
							Red <= color_bullet_0[23:16];
							Green <= color_bullet_0[15:8];
							Blue <= color_bullet_0[7:0];
						end
					end
					else begin
						if(bullet_on_B) begin //priority is bullet B
							Red <= color_bullet_1[23:16];
							Green <= color_bullet_1[15:8];
							Blue <= color_bullet_1[7:0];
						end
						else begin //second priority is tank B
							Red <= color_tank_1[23:16];
							Green <= color_tank_1[15:8];
							Blue <= color_tank_1[7:0]; 
						end
					end				
				end
				else begin
					if(bullet_on_A)begin
						if(bullet_on_B) begin //priority is bullet B
							Red <= color_bullet_1[23:16];
							Green <= color_bullet_1[15:8];
							Blue <= color_bullet_1[7:0];
						end
						else begin //second priority is bullet A
							Red <= color_bullet_0[23:16];
							Green <= color_bullet_0[15:8];
							Blue <= color_bullet_0[7:0];
						end
					end
					else begin
						if(bullet_on_B) begin //priority is bullet B
							Red <= color_bullet_1[23:16];
							Green <= color_bullet_1[15:8];
							Blue <= color_bullet_1[7:0];
							end
							else begin //second priority is tank A
							Red <= color_tank_0[23:16];
							Green <= color_tank_0[15:8];
							Blue <= color_tank_0[7:0]; 
						end
					end				
				end		
			end
			else begin
			if(ball_on_B) begin//bis on or not
				if(bullet_on_A)begin
					if(bullet_on_B) begin //priority is bullet B
						Red <= color_bullet_1[23:16];
						Green <= color_bullet_1[15:8];
						Blue <= color_bullet_1[7:0];
					end
					else begin //second priority is bullet A
						Red <= color_bullet_0[23:16];
						Green <= color_bullet_0[15:8];
						Blue <= color_bullet_0[7:0];
					end
				end
				else begin
					if(bullet_on_B) begin //priority is bullet B
						Red <= color_bullet_1[23:16];
						Green <= color_bullet_1[15:8];
						Blue <= color_bullet_1[7:0];
					end
					else begin //second priority is tank B
						Red <= color_tank_1[23:16];
						Green <= color_tank_1[15:8];
						Blue <= color_tank_1[7:0]; 
					end
				end				
			end
			else begin
				if(bullet_on_A)begin
					if(bullet_on_B) begin //priority is bullet B
						Red <= color_bullet_1[23:16];
						Green <= color_bullet_1[15:8];
						Blue <= color_bullet_1[7:0];
					end
					else begin //second priority is bullet A
						Red <= color_bullet_0[23:16];
						Green <= color_bullet_0[15:8];
						Blue <= color_bullet_0[7:0];
					end
				end
				else begin
					if(bullet_on_B) begin //priority is bullet B
						Red <= color_bullet_1[23:16];
						Green <= color_bullet_1[15:8];
						Blue <= color_bullet_1[7:0];
						end
						else begin //second priority is bullet A
						Red <= 8'h7f - DrawX[9:3];
						Green <= 8'h00;
						Blue <= 8'h00;
						end
					end				
				end					
			
			end
//		
		end
//			
		default	: begin //over
		//always_ff @(posedge VGA_Clk or posedge Reset) begin:rendering
		
		Red <= 8'h00;
		Green <= 8'hff - DrawX[9:3];
		Blue <= 8'hff;
		

		end
					
			
		
		endcase
	 
	
	  end
	 
	 
	 
endmodule
