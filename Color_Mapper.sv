//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] TankX_A, TankY_A, BulletX_A, BulletY_A, DrawX, DrawY, Ball_size,
							  input        [9:0] TankX_B, TankY_B, BulletX_B, BulletY_B, 
							  input			transparent,
							  input 			[1:0] currentState, currentTank_A,currentTank_B,
							  input			[7:0]  vga_port_backgrounddata,
							  output 		[15:0] vga_port_local_addr,
							  output logic [7:0]  Red, Green, Blue );
    
    logic ball_on_A, bullet_on_A, select_on_A;
	 logic ball_on_B, bullet_on_B, select_on_B;
	 logic [7:0] currData;
	 
	 
		
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
	 
	 
	  
//	 font_rom fr(.addr(DistY + (currentTank+2) * 17),
//					.data(currData)
//						 );	 
//	 
	//-----------------palette on tank_0 (A) -----------------
	logic [15:0] currentTankADDR_A;
	assign currentTankADDR_A = (DistY_A * 70) + DistX_A;	
	logic [3:0] colorIdx_tank_A;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_A( .addr(currentTankADDR_A), .tankSelection(currentTank_A), .data(colorIdx_tank_A));
	logic [23:0] color_tank_0;
	palette plt_tank_0(.colorIdx(colorIdx_tank_A), .rgbVal(color_tank_0));
	
	
	
	//-----------------palette on tank_1 (B) -----------------
	logic [15:0] currentTankADDR_B;
	assign currentTankADDR_B = (DistY_B * 70) + DistX_B;	
	logic [3:0] colorIdx_tan_B;
	//assign colorIdx = 4'h3;
	rtank_rom rtk_B( .addr(currentTankADDR_B), .tankSelection(currentTank_B), .data(colorIdx_tank_B));
	logic [23:0] color_tank_1;
	palette plt_tank_1(.colorIdx(colorIdx_tank_B), .rgbVal(color_tank_1));

	

	
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
	
		 
		 
		 
		 
	always_comb
    begin:RGB_Display
	 
		case (currentState)
			
			2'b00	:	begin //selection
				 if (select_on_A) begin
				 
						Red = color_tank_0[23:16];
						Green = color_tank_0[15:8];
						Blue = color_tank_0[7:0]; 
				 
				 end
				 else if (select_on_B) begin
				 
					Red = color_tank_1[23:16];
					Green = color_tank_1[15:8];
					Blue = color_tank_1[7:0]; 
					 
				 end
							
				else begin
					Red = 8'h00; 
					Green = 8'h7f - DrawX[9:3];
					Blue = 8'h00;
				
				end
							
			
			end
			
			2'b01 : begin //fight color_rtk
			
			
			
			if(ball_on_A)begin//A is on or not
				if(ball_on_B) begin//bis on or not
					if(bullet_on_A)begin
						if(bullet_on_B) begin //priority is bullet B
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						end
						else begin //second priority is bullet A
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'h00;
						end
					end
					else begin
						if(bullet_on_B) begin //priority is bullet B
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						end
						else begin //second priority is bullet A
							Red = color_tank_1[23:16];
							Green = color_tank_1[15:8];
							Blue = color_tank_1[7:0]; 
						end
					end				
				end
				else begin
					if(bullet_on_A)begin
						if(bullet_on_B) begin //priority is bullet B
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						end
						else begin //second priority is bullet A
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'h00;
						end
					end
					else begin
						if(bullet_on_B) begin //priority is bullet B
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
							end
							else begin //second priority is bullet A
							Red = color_tank_0[23:16];
							Green = color_tank_0[15:8];
							Blue = color_tank_0[7:0]; 
						end
					end				
				end		
			end
			else begin
			if(ball_on_B) begin//bis on or not
				if(bullet_on_A)begin
					if(bullet_on_B) begin //priority is bullet B
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
					end
					else begin //second priority is bullet A
						Red = 8'hff;
						Green = 8'hff;
						Blue = 8'h00;
					end
				end
				else begin
					if(bullet_on_B) begin //priority is bullet B
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
					end
					else begin //second priority is bullet A
						Red = color_tank_1[23:16];
						Green = color_tank_1[15:8];
						Blue = color_tank_1[7:0]; 
					end
				end				
			end
			else begin
				if(bullet_on_A)begin
					if(bullet_on_B) begin //priority is bullet B
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
					end
					else begin //second priority is bullet A
						Red = 8'hff;
						Green = 8'hff;
						Blue = 8'h00;
					end
				end
				else begin
					if(bullet_on_B) begin //priority is bullet B
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
						end
						else begin //second priority is bullet A
						Red = 8'h7f - DrawX[9:3];
						Green = 8'h00;
						Blue = 8'h00;
					end
				end				
			end					
		
		end
		
		end
			
		default	: begin //over
			Red = 8'h7f - DrawX[9:3];
			Green = 8'h00;
			Blue = 8'h00;
		end
					
			
		
		endcase
	 
	
	  end
	 
	 
	 
endmodule
