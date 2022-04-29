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
							  input 			[3:0] HP_A, HP_B,
							  input        [9:0] TankX_A, TankY_A, BulletX_A, BulletY_A, DrawX, DrawY, Ball_size,
							  input 			[1:0] Direction_A,
							  input        [9:0] TankX_B, TankY_B, BulletX_B, BulletY_B, 
							  input 			[1:0] Direction_B,
							  input			transparent,
							  input 			[1:0] currentState, currentTank_A,currentTank_B,
							  input			[7:0]  vga_port_backgrounddata,
							  output 		[15:0] vga_port_local_addr,
							  output logic [7:0]  Red, Green, Blue );
    
    logic ball_on_A, bullet_on_A, select_on_A, HP_on_A;
	 logic ball_on_B, bullet_on_B, select_on_B, HP_on_B;
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
	 
	 
		
	 //-----------------calculate co-ord to HP-----------------
	 logic [9:0] HPX_A, HPY_A, HPX_B, HPY_B; 
	 assign HPX_A = 80;
	 assign HPY_A = 80;
	 assign HPX_B = 490;
	 assign HPY_B = 80;
	 
    int HP_DistX_A, HP_DistY_A, HP_DistX_B, HP_DistY_B;
	 assign HP_DistX_A = DrawX - HPX_A;
    assign HP_DistY_A = DrawY - HPY_A;
	 assign HP_DistX_B = DrawX - HPX_B;
    assign HP_DistY_B = DrawY - HPY_B;
    
	 
	 //-----------------calculate co-ord to bullet-----------------
	 int Bullet_DistX_A, Bullet_DistY_A, Size, Bullet_DistX_B, Bullet_DistY_B;
	 assign Bullet_DistX_A = DrawX - BulletX_A;
    assign Bullet_DistY_A = DrawY - BulletY_A;
	 assign Bullet_DistX_B = DrawX - BulletX_B;
    assign Bullet_DistY_B = DrawY - BulletY_B;
    assign Size = 4;
	 
	 
	 //-----------------calculate co-ord to tank-----------------
    int DistX_A, DistY_A, DistX_B, DistY_B;
	 assign DistX_A = DrawX - TankX_A;
    assign DistY_A = DrawY - TankY_A;
	 assign DistX_B = DrawX - TankX_B;
    assign DistY_B = DrawY - TankY_B;
	 
	 
	 
	 
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
	int TankA_delta_Y_temp;
	logic [5:0] TankA_delta_Y;
	assign TankA_End_Y = 607*((TankX_A+65)**2)/1562500 - 71*TankX_A/500 + 267 - 45;
	assign TankA_delta_Y_temp = TankA_End_Y - TankY_A;
	always_ff @(posedge VGA_Clk or posedge Reset)begin
		if(Reset)begin
			TankA_delta_Y <= 0;
		end
		else begin
			if(TankA_delta_Y_temp < 0) TankA_delta_Y<=0;
			if((TankA_delta_Y_temp > 0) & (TankA_delta_Y_temp < 2)) TankA_delta_Y<=1;
			if((TankA_delta_Y_temp >= 2) & (TankA_delta_Y_temp < 4)) TankA_delta_Y<=3;
			if((TankA_delta_Y_temp >= 4) & (TankA_delta_Y_temp < 6)) TankA_delta_Y<=5;
			if((TankA_delta_Y_temp >= 6) & (TankA_delta_Y_temp < 8)) TankA_delta_Y<=7;
			if((TankA_delta_Y_temp >= 8) & (TankA_delta_Y_temp < 10)) TankA_delta_Y<=9;
			if((TankA_delta_Y_temp >= 10) & (TankA_delta_Y_temp < 12)) TankA_delta_Y<=11;
			if((TankA_delta_Y_temp >= 12) & (TankA_delta_Y_temp < 14)) TankA_delta_Y<=13;
			if((TankA_delta_Y_temp >= 14) & (TankA_delta_Y_temp < 16)) TankA_delta_Y<=15;
			if((TankA_delta_Y_temp >= 16) & (TankA_delta_Y_temp < 18)) TankA_delta_Y<=17;
			if((TankA_delta_Y_temp >= 18) & (TankA_delta_Y_temp < 20)) TankA_delta_Y<=19;	
			if((TankA_delta_Y_temp >= 20) & (TankA_delta_Y_temp < 20)) TankA_delta_Y<=21;
			if((TankA_delta_Y_temp >= 22) & (TankA_delta_Y_temp < 24)) TankA_delta_Y<=23;	
			if((TankA_delta_Y_temp >= 24) & (TankA_delta_Y_temp < 26)) TankA_delta_Y<=25;	
			if((TankA_delta_Y_temp >= 26) & (TankA_delta_Y_temp < 28)) TankA_delta_Y<=27;	
			if((TankA_delta_Y_temp >= 28)) TankA_delta_Y<=29;
		end
		
	
	end
	//Rotation Matrix: 
	//x' = x*cos(a) -y*sin(a), y' = x*sin(a)+y*cos(a)
	//small angle theorem: tan(a) = a = TankA_delta_Y / Length
	//cos(a) = (1-tan^2(a/2))/(1+tan^2(a/2)) = (4*(L**2)-(TankA_delta_Y**2))/(4*(L**2)+(TankA_delta_Y**2))
	//sin(a) = (2tan(a/2))/(1+tan^2(a/2)) = (4*TankA_delta_Y*L)/(4*(L**2)+(TankA_delta_Y**2))
	int TankA_Rotate_X, TankA_Rotate_Y;
	always_comb begin
		TankA_Rotate_X = DistX_A*(4*(100**2)-(TankA_delta_Y**2))/(4*(100**2)+(TankA_delta_Y**2))+DistY_A*(4*TankA_delta_Y*70)/(4*(100**2)+(TankA_delta_Y**2));
		TankA_Rotate_Y = DistY_A*(4*(100**2)-(TankA_delta_Y**2))/(4*(100**2)+(TankA_delta_Y**2))-DistX_A*(4*TankA_delta_Y*70)/(4*(100**2)+(TankA_delta_Y**2));
			
		if(TankA_Rotate_X > 100) TankA_Rotate_X = 100;
		else begin
			if(TankA_Rotate_X < 0) TankA_Rotate_X = 0;
			else begin
				TankA_Rotate_X = TankA_Rotate_X;
			end		
		end		
		if(TankA_Rotate_Y > 80) TankA_Rotate_Y = 80;
		else begin
			if(TankA_Rotate_Y < 0) TankA_Rotate_Y = 0;
			else begin
				TankA_Rotate_Y = TankA_Rotate_Y;
			end		
		end	
	end
	
	
	
	
	
	  
	//important trY::::::::::::::::::::::::::::::::: ROTBTION MBTRIX CBLCULBTION FOR TANK B :::::::::::::::::::::::::::::::::
	int TankB_End_Y;
	int TankB_delta_Y_temp;
	logic [5:0] TankB_delta_Y;
	assign TankB_End_Y = 607*((TankX_B+65)**2)/1562500 - 71*TankX_B/500 + 267 - 45;
	assign TankB_delta_Y_temp = TankB_End_Y - TankY_B;
	always_ff @(posedge VGA_Clk or posedge Reset)begin
		if(Reset)begin
			TankB_delta_Y <= 0;
		end
		else begin
			if(TankB_delta_Y_temp < 0) TankB_delta_Y<=0;
			if((TankB_delta_Y_temp > 0) & (TankB_delta_Y_temp < 2)) TankB_delta_Y<=1;
			if((TankB_delta_Y_temp >= 2) & (TankB_delta_Y_temp < 4)) TankB_delta_Y<=3;
			if((TankB_delta_Y_temp >= 4) & (TankB_delta_Y_temp < 6)) TankB_delta_Y<=5;
			if((TankB_delta_Y_temp >= 6) & (TankB_delta_Y_temp < 8)) TankB_delta_Y<=7;
			if((TankB_delta_Y_temp >= 8) & (TankB_delta_Y_temp < 10)) TankB_delta_Y<=9;
			if((TankB_delta_Y_temp >= 10) & (TankB_delta_Y_temp < 12)) TankB_delta_Y<=11;
			if((TankB_delta_Y_temp >= 12) & (TankB_delta_Y_temp < 14)) TankB_delta_Y<=13;
			if((TankB_delta_Y_temp >= 14) & (TankB_delta_Y_temp < 16)) TankB_delta_Y<=15;
			if((TankB_delta_Y_temp >= 16) & (TankB_delta_Y_temp < 18)) TankB_delta_Y<=17;
			if((TankB_delta_Y_temp >= 18) & (TankB_delta_Y_temp < 20)) TankB_delta_Y<=19;	
			if((TankB_delta_Y_temp >= 20) & (TankB_delta_Y_temp < 20)) TankB_delta_Y<=21;
			if((TankB_delta_Y_temp >= 22) & (TankB_delta_Y_temp < 24)) TankB_delta_Y<=23;	
			if((TankB_delta_Y_temp >= 24) & (TankB_delta_Y_temp < 26)) TankB_delta_Y<=25;	
			if((TankB_delta_Y_temp >= 26) & (TankB_delta_Y_temp < 28)) TankB_delta_Y<=27;	
			if((TankB_delta_Y_temp >= 28)) TankB_delta_Y<=29;
		end
	end

	int TankB_Rotate_X, TankB_Rotate_Y;
	always_comb begin
		TankB_Rotate_X = DistX_B*(4*(100**2)-(TankB_delta_Y**2))/(4*(100**2)+(TankB_delta_Y**2))+DistY_B*(4*TankB_delta_Y*70)/(4*(100**2)+(TankB_delta_Y**2));
		TankB_Rotate_Y = DistY_B*(4*(100**2)-(TankB_delta_Y**2))/(4*(100**2)+(TankB_delta_Y**2))-DistX_B*(4*TankB_delta_Y*70)/(4*(100**2)+(TankB_delta_Y**2));
			
		if(TankB_Rotate_X > 100) TankB_Rotate_X = 100;
		else begin
			if(TankB_Rotate_X < 0) TankB_Rotate_X = 0;
			else begin
				TankB_Rotate_X = TankB_Rotate_X;
			end		
		end		
		if(TankB_Rotate_Y > 80) TankB_Rotate_Y = 80;
		else begin
			if(TankB_Rotate_Y < 0) TankB_Rotate_Y = 0;
			else begin
				TankB_Rotate_Y = TankB_Rotate_Y;
			end		
		end	
	end
	  
	  
	  
	  
	//-----------------palette on HP_A -----------------
	logic [13:0] currentHPADDR_A;
	assign currentHPADDR_A = (HP_DistY_A * 70) + HP_DistX_A;	
	logic [7:0] colorIdx_HP_A;
	hp_rom hp_A( .addr(currentHPADDR_A), .HPSelection(HP_A), .data(colorIdx_HP_A));
	logic [23:0] color_hp_0;
	palette plt_hp_0(.colorIdx(colorIdx_HP_A[7:4]), .rgbVal(color_hp_0));  
	
	
	//-----------------palette on HP_B -----------------
	logic [13:0] currentHPADDR_B;
	assign currentHPADDR_B = (HP_DistY_B * 70) + HP_DistX_B;	
	logic [7:0] colorIdx_HP_B;
	hp_rom hp_B( .addr(currentHPADDR_B), .HPSelection(HP_B), .data(colorIdx_HP_B));
	logic [23:0] color_hp_1;
	palette plt_hp_1(.colorIdx(colorIdx_HP_B[7:4]), .rgbVal(color_hp_1));  
	  
	  
	  
	  

	//-----------------palette on tank_0 (A) -----------------
	logic [15:0] currentTankADDR_A;
	assign currentTankADDR_A = (TankA_Rotate_Y * 100) + TankA_Rotate_X;	
	logic [3:0] colorIdx_tank_A;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_A( .addr(currentTankADDR_A), .tankSelection(currentTank_A), .data(colorIdx_tank_A), .Direction(Direction_A));
	logic [23:0] color_tank_0;
	palette plt_tank_0(.colorIdx(colorIdx_tank_A), .rgbVal(color_tank_0));
	
	
	
	//-----------------palette on tank_1 (B) -----------------
	logic [15:0] currentTankADDR_B;
	assign currentTankADDR_B = (TankB_Rotate_Y * 100) + TankB_Rotate_X;	
	logic [3:0] colorIdx_tank_B;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_B( .addr(currentTankADDR_B), .tankSelection(currentTank_B), .data(colorIdx_tank_B), .Direction(Direction_B));
	logic [23:0] color_tank_1;
	palette plt_tank_1(.colorIdx(colorIdx_tank_B), .rgbVal(color_tank_1));

	
	
	//-----------------palette on bullet (A) -----------------
	logic [13:0] currentBulletADDR_A;
	assign currentBulletADDR_A = 20 * Bullet_DistY_A + Bullet_DistX_A;
	logic [3:0] colorIdx_bullet_A;
	bullet_rom b0_rom (.addr(currentBulletADDR_A), .tankSelection(currentTank_A), .data(colorIdx_bullet_A));
	logic [23:0] color_bullet_0;
	palette plt_bullet_0(.colorIdx(colorIdx_bullet_A), .rgbVal(color_bullet_0));
	
	
	//-----------------palette on bullet (B) -----------------
	logic [13:0] currentBulletADDR_B;
	assign currentBulletADDR_B = 20 * Bullet_DistY_B + Bullet_DistX_B;
	logic [3:0] colorIdx_bullet_B;
	bullet_rom b1_rom (.addr(currentBulletADDR_B), .tankSelection(currentTank_B), .data(colorIdx_bullet_B));
	logic [23:0] color_bullet_1;
	palette plt_bullet_1(.colorIdx(colorIdx_bullet_B), .rgbVal(color_bullet_1));
	

	
	//-----------------palette on background -----------------
//	logic [18:0] currentBackgroundADDR;
//	assign currentBackgroundADDR = (DrawY * 640) + DrawX;	
//	logic [3:0] colorIdx_background;
//	//assign colorIdx = 4'h3;
//	background_rom bgd( .addr(currentBackgroundADDR), .data(colorIdx_background));
//	logic [23:0] color_background;
//	palette plt_background_1(.colorIdx(colorIdx_background), .rgbVal(color_background));

	
	
	//-----------------------Tank (phase 0) On Signals-----------------------
	always_comb
    begin:select_on_proc1
        if ( (DistX_A <= 100) & (DistY_A <= 80) & (DistX_A >= 0) & (DistY_A >= 0)  ) 
            select_on_A = 1'b1;
        else 
		  select_on_A = 1'b0;
		end 
         
	always_comb
    begin:select_on_proc2
        if ( (DistX_B <= 100) & (DistY_B <= 80) & (DistX_B >= 0) & (DistY_B >= 0)  ) 
            select_on_B = 1'b1;
        else 
		  select_on_B = 1'b0;
		end 		
	
	  
	  
	//-----------------------Tank (phase 1) On Signals-----------------------

    always_comb
    begin:Ball_on_proc1
        if ( (DistX_A <= 100) & (DistY_A <= 80) & (DistX_A >= 0) & (DistY_A >= 0)  ) 
            ball_on_A = 1'b1;
        else 
            ball_on_A = 1'b0;
     end 	
	  
    always_comb
    begin:Ball_on_proc2
        if ( (DistX_B <= 100) & (DistY_B <= 80) & (DistX_B >= 0) & (DistY_B >= 0)  ) 
            ball_on_B = 1'b1;
        else 
            ball_on_B = 1'b0;
     end 
	  
	  
	 //-----------------------Bullet On Signals-----------------------
	  
	 always_comb
    begin:Bullet_on_proc1
        if ( (Bullet_DistX_A <= 20) & (Bullet_DistY_A <= 20) & (Bullet_DistX_A >= 0) & (Bullet_DistY_A >= 0)  ) 
            bullet_on_A = 1'b1;
        else 
            bullet_on_A = 1'b0;
     end 
	  
	 always_comb
    begin:Bullet_on_proc2
        if ( (Bullet_DistX_B <= 20) & (Bullet_DistY_B <= 20) & (Bullet_DistX_B >= 0) & (Bullet_DistY_B >= 0)  ) 
            bullet_on_B = 1'b1;
        else 
            bullet_on_B = 1'b0;
     end 
	  
	  
	  //-----------------------HP On Signals-----------------------
	  always_comb
	  begin:hp_on_0
        if ( (HP_DistX_A <= 70) & (HP_DistY_A <= 20) & (HP_DistX_A >= 0) & (HP_DistY_A >= 0)  ) 
            HP_on_A = 1'b1;
        else 
            HP_on_A = 1'b0;
     end 
	  
	  always_comb
	  begin:hp_on_1
        if ( (HP_DistX_B <= 70) & (HP_DistY_B <= 20) & (HP_DistX_B >= 0) & (HP_DistY_B >= 0)  ) 
            HP_on_B = 1'b1;
        else 
            HP_on_B = 1'b0;
     end
	
		 
		 
		 
		 
	always_ff @(posedge VGA_Clk or posedge Reset)
    begin:RGB_Display
	 
		case (currentState)
			
			2'b00	:	begin //selection
				Red <= currBG_RGB[23:16];
				Green <= currBG_RGB[15:8];
				Blue <= currBG_RGB[7:0]; 
					
					
				 if(ball_on_A)begin//A is on or not
					if(color_tank_0 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
					end
					else begin
						Red <= color_tank_0[23:16];
						Green <= color_tank_0[15:8];
						Blue <= color_tank_0[7:0];
					end				
				end
				
				if (select_on_B) begin
					 if(color_tank_1 == 24'hB0B0B0)begin
							Red <= currBG_RGB[23:16];
							Green <= currBG_RGB[15:8];
							Blue <= currBG_RGB[7:0]; 
						end
						else begin
							Red <= color_tank_1[23:16];
							Green <= color_tank_1[15:8];
							Blue <= color_tank_1[7:0];
						end	 
				 end
							
											
			
			end
			
			2'b01 : begin //fight color_rtk
			Red <= currBG_RGB[23:16];
			Green <= currBG_RGB[15:8];
			Blue <= currBG_RGB[7:0]; 
					
			
			
			   if(ball_on_A)begin//A is on or not
					if(color_tank_0 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
					end
					else begin
						Red <= color_tank_0[23:16];
						Green <= color_tank_0[15:8];
						Blue <= color_tank_0[7:0];
					end				
				end
				
				if (ball_on_B) begin
					 if(color_tank_1 == 24'hB0B0B0)begin
							Red <= currBG_RGB[23:16];
							Green <= currBG_RGB[15:8];
							Blue <= currBG_RGB[7:0]; 
						end
						else begin
							Red <= color_tank_1[23:16];
							Green <= color_tank_1[15:8];
							Blue <= color_tank_1[7:0];
						end	 
				 end
				
				if(bullet_on_A) begin
					if(color_bullet_0 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
						if(ball_on_A) begin                           //use draw tank B block
							if(color_tank_0 == 24'hB0B0B0)begin
								Red <= currBG_RGB[23:16];
								Green <= currBG_RGB[15:8];
								Blue <= currBG_RGB[7:0]; 
							end
							else begin
								Red <= color_tank_0[23:16];
								Green <= color_tank_0[15:8];
								Blue <= color_tank_0[7:0];
							end				
						end
						
						if (ball_on_B) begin                           //use draw tank B block
							 if(color_tank_1 == 24'hB0B0B0)begin
									Red <= currBG_RGB[23:16];
									Green <= currBG_RGB[15:8];
									Blue <= currBG_RGB[7:0]; 
								end
								else begin
									Red <= color_tank_1[23:16];
									Green <= color_tank_1[15:8];
									Blue <= color_tank_1[7:0];
								end	 
						 end			
					end
					else begin
							Red <= color_bullet_0[23:16];
							Green <= color_bullet_0[15:8];
							Blue <= color_bullet_0[7:0];
						 
					end
					
					
				end
					
					
					
					
				if(bullet_on_B) begin
					if(color_bullet_1 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
						if(ball_on_A) begin                           //use draw tank B block
							if(color_tank_0 == 24'hB0B0B0)begin
								Red <= currBG_RGB[23:16];
								Green <= currBG_RGB[15:8];
								Blue <= currBG_RGB[7:0]; 
							end
							else begin
								Red <= color_tank_0[23:16];
								Green <= color_tank_0[15:8];
								Blue <= color_tank_0[7:0];
							end				
						end
						
						if (ball_on_B) begin                           //use draw tank B block
							 if(color_tank_1 == 24'hB0B0B0)begin
									Red <= currBG_RGB[23:16];
									Green <= currBG_RGB[15:8];
									Blue <= currBG_RGB[7:0]; 
								end
								else begin
									Red <= color_tank_1[23:16];
									Green <= color_tank_1[15:8];
									Blue <= color_tank_1[7:0];
								end	 
						 end			
					end
					else begin
							Red <= color_bullet_1[23:16];
							Green <= color_bullet_1[15:8];
							Blue <= color_bullet_1[7:0];
						 
					end
					
					
				end
			
		
			
			
			
				if(HP_on_A)begin
					if(color_hp_0 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
					end
					else begin
						Red <= 0;
						Green <= 8'hff;
						Blue <= 0;
					end	
				end
				
				
				if(HP_on_B)begin
					if(color_hp_1 == 24'hB0B0B0)begin
						Red <= currBG_RGB[23:16];
						Green <= currBG_RGB[15:8];
						Blue <= currBG_RGB[7:0]; 
					end
					else begin
						Red <= 8'hff;
						Green <= 0;
						Blue <= 0;
					end	
				end
			
			
			end
		


//		end
		
		default	: begin //over
		//always_ff @(posedge VGA_Clk or posedge Reset) begin:rendering
		
		Red <= 8'h00;
		Green <= 8'hff - DrawX[9:3];
		Blue <= 8'hff;
		

		end
					
			
		
		endcase
	 
	
	  end
	 
	 
	 
endmodule
