/*
 *  text_mode_vga.h
 *	Minimal driver for text mode VGA support, ECE 385 Summer 2021 Lab 6
 *  You may wish to extend this driver for your final project/extra credit project
 * 
 *  Created on: Jul 17, 2021
 *      Author: zuofu
 */

#ifndef TEXT_MODE_VGA_COLOR_H_
#define TEXT_MODE_VGA_COLOR_H_

#define COLUMNS 80
#define ROWS 30

#include <system.h>
#include <alt_types.h>

struct BACK_STRUCT {
	alt_u8 VRAM[38400];

};



//you may have to change this line depending on your platform designer
static volatile struct BACK_STRUCT* vga_ctrl = 0x20000;

//CGA colors with names






void VGARender(); //Call this for your demo


#endif /* TEXT_MODE_VGA_COLOR_H_ */
