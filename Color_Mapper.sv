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


module  color_mapper ( input        [9:0] BallX, BallY, BulletX, BulletY, DrawX, DrawY, Ball_size,
							  input			transparent,
							  input 			[1:0] currentState, currentTank,
							  output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, bullet_on, select_on;
	 logic [7:0] currData;
	 
	 
	 
	 //test palette
	 logic [23:0] color_1;
	 logic [23:0] color_2;
	 
	 
	 palette plt_1 (.colorIdx(9), .rgbVal(color_1));
	 palette plt_2 (.colorIdx(10), .rgbVal(color_2));
	 

    int DistX, DistY;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    
	 
	 //bullet-----------------
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
	  
	  
	 int TankX, TankY;
	 
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
	//test palette on tank
	logic [15:0] currentADDR;
	assign currentADDR = (DistY * 70) + DistX;
	logic [3:0] colorIdx;
	rtank_rom rtk( .addr(1582), .data(colorIdx));
	logic [23:0] color_rtk;
	palette plt_3(.colorIdx(colorIdx), .rgbVal(color_rtk));

	  
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
					Red = color_rtk[23:16];
					Green = color_rtk[15:8];
					Blue = color_rtk[7:0];	
						
			  end 
			  
			  else begin
					if ((bullet_on == 1'b1)) begin 
							Red = color_2[23:16];
							Green = color_2[15:8];
							Blue = color_2[7:0];
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
