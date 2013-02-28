//
//  ColorBrightnessColourBrightnessDifference.h
//  CCA
//
//  Created by Cedric Trevisan on 19/06/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ColourBrightnessDifference : NSObject {
	int fR,fG,fB,bR,bG,bB;
}

- (id)initWithForegroundRed:(int)fr ForegroundGreen:(int)fg ForegroundBlue:(int)fb
		BackgroundRed:(int)br BackgroundGreen:(int)bg BackgroundBlue:(int)bb;
- (void)setForegroundRed:(int)red Green:(int)green Blue:(int)blue;
- (void)setBackgroundRed:(int)red Green:(int)green Blue:(int)blue;

- (int)getBrightnessDifference;
- (int)getColourDifference;

@end
