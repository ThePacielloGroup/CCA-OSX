//
//  ColorBrightnessColourBrightnessDifference.m
//  CCA
//
//  Created by Cedric Trevisan on 19/06/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ColourBrightnessDifference.h"

#define max(a, b) a>b?a:b
#define min(a, b) a<b?a:b

@implementation ColourBrightnessDifference

- (id)initWithForegroundRed:(int)fr ForegroundGreen:(int)fg ForegroundBlue:(int)fb
		BackgroundRed:(int)br BackgroundGreen:(int)bg BackgroundBlue:(int)bb
{
	id newInstance = [self init];
	[newInstance setForegroundRed:fr Green:fg Blue:fb];
	[newInstance setBackgroundRed:br Green:bg Blue:bb];
	return newInstance;
}

- (void)setForegroundRed:(int)red Green:(int)green Blue:(int)blue
{
	fR = red;
	fG = green;
	fB = blue;
}

- (void)setBackgroundRed:(int)red Green:(int)green Blue:(int)blue
{
	bR = red;
	bG = green;
	bB = blue;
}
		
- (int)getColourDifference
{
	return ((max(bR,fR)) - (min(bR,fR))) + ((max(bG,fG)) - (min(bG,fG))) + ((max(bB,fB)) - (min(bB,fB)));
}

- (int)getBrightnessDifference
{
	int fH, bH;
	fH = ((fR * 299) + (fG * 587) + (fB * 114)) / 1000;
	bH = ((bR * 299) + (bG * 587) + (bB * 114)) / 1000;

	return abs(fH - bH);
}

@end
