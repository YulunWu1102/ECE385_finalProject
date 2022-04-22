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


module  color_mapper ( input        [9:0] TankX, TankY, BulletX, BulletY, DrawX, DrawY, Ball_size,
							  input			transparent,
							  input 			[1:0] currentState, currentTank,
							  output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, bullet_on, select_on;
	 logic [7:0] currData;
	 
	 
		
	 //-----------------calculate co-ord to tank-----------------
    int DistX, DistY;
	 assign DistX = DrawX - TankX;
    assign DistY = DrawY - TankY;
    
	 
	 //-----------------calculate co-ord to bullet-----------------
	 int Bullet_DistX, Bullet_DistY, Size;
	 assign Bullet_DistX = DrawX - BulletX;
    assign Bullet_DistY = DrawY - BulletY;
    assign Size = 4;
	 
	 
	 
	 //state 0: select display
	 parameter [9:0] Select_X_Center=320;  // Center position on the X axis
    parameter [9:0] Select_Y_Center=240; 
	 int DistX_S, DistY_S;
	 assign DistX_s = DrawX - Select_X_Center;
    assign DistY_s = DrawY - Select_Y_Center;
	 
	 
	 
	 always_comb
    begin:select_on_proc
        if ( (DistX <= 70) & (DistY <= 50) & (DistX >= 0) & (DistY >= 0)  ) 
            select_on = 1'b1;
        else 
            select_on = 1'b0;
     end 
	  
	  
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
	//-----------------palette on tank_0 -----------------
	logic [15:0] currentTankADDR;
	assign currentTankADDR = (DistY * 70) + DistX;	
	logic [3:0] colorIdx_tank;
	//assign colorIdx = 4'h3;
	rtank_rom rtk( .addr(currentTankADDR), .tankSelection(1), .data(colorIdx_tank));
	logic [23:0] color_tank_0;
	palette plt_tank_0(.colorIdx(colorIdx_tank), .rgbVal(color_tank_0));

	
	//-----------------palette on background -----------------
//	logic [18:0] currentBackgroundADDR;
//	assign currentBackgroundADDR = (DrawY * 640) + DrawX;	
//	logic [3:0] colorIdx_background;
//	//assign colorIdx = 4'h3;
//	background_rom bgd( .addr(currentBackgroundADDR), .data(colorIdx_background));
//	logic [23:0] color_background;
//	palette plt_background_1(.colorIdx(colorIdx_background), .rgbVal(color_background));

	
	
	
	  
    always_comb
    begin:Ball_on_proc
        if ( (DistX <= 70) & (DistY <= 50) & (DistX >= 0) & (DistY >= 0)  ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
	  
	 always_comb
    begin:Bullet_on_proc
        if (( ( Bullet_DistX*Bullet_DistX + Bullet_DistY*Bullet_DistY) <= (Size * Size))) 
            bullet_on = 1'b1;
        else 
            bullet_on = 1'b0;
     end 
       
		 
		 
	always_comb
    begin:RGB_Display
	 
//		case (currentState)
//			
//			2'b00	:	begin //selection
//				if (select_on) begin
//				
//					if(currData[DistX] == 1'b1)begin
//						Red = color_1[23:16];
//						Green = color_1[15:8];
//						Blue = color_1[7:0];
//					
//					end
//					else begin
//						Red = 8'h00;
//						Green = 8'h55;
//						Blue = 8'h00;
//					
//					end
//				
//				
//				end
//				else begin
//					Red = 8'h00; 
//					Green = 8'h7f - DrawX[9:3];
//					Blue = 8'h00;
//				
//				end
//			
//			
//			
//				
//			
//			end
//			
//			2'b01 : begin //fight color_rtk
			
			 if ((ball_on == 1'b1)) begin 
					if(color_tank_0 == 24'hB0B0B0)begin
						if ((bullet_on == 1'b1)) begin 
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
					end  
							
					else begin				
							Red = 8'h00; 
							Green = 8'h00;
							Blue = 8'h7f - DrawX[9:3];
					end				
					
					end
					else begin
						Red = color_tank_0[23:16];
						Green = color_tank_0[15:8];
						Blue = color_tank_0[7:0];	
					end
					
						
			  end 
			  
			  else begin
					if ((bullet_on == 1'b1)) begin 
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
					end  
							
					else begin				
							Red = 8'h00; 
							Green = 8'h00;
							Blue = 8'h7f - DrawX[9:3];
					end
			  
							
			  end 
			
			
			end
			
			
//			default	: begin //over
//				Red = 8'h7f - DrawX[9:3];
//				Green = 8'h00;
//				Blue = 8'h00;
//			
//			
//			end
//			
//			
//		
//		
//		
//		endcase
	 
	 
	 
	 
	 

	   
	 
	 
	 
endmodule
