//
//  Everything.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//  
//

#import "Everything.h"


@implementation Everything

+ (float)bin_to_float:(char *)b0 and:(char *)b1 also:(char *)b2 finally:(char *)b3 {
	int exponent, sign;
	float significand;
	float finalvalue=0;
	
	//fraction = b0 + b1<<8 + (b2 & 0x7F)<<16 + 1<<24;
	exponent = (*b3 & 0x7F)*2 | (*b2 & 0x80)>>7;
	sign = (*b3&0x80)>>7;
	exponent = exponent-127;
	significand = 1 + (*b2&0x7F)*pow(2,-7) + *b1*pow(2,-15) + *b0*pow(2,-23);  //throwing away precision for now...
	
	if(sign!=0)significand=-significand;
	finalvalue = significand*pow(2,exponent);
	
	return finalvalue;
}

@end
