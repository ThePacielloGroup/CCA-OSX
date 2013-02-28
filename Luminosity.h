/* Luminosity */

#import <Cocoa/Cocoa.h>

@interface Luminosity : NSObject
{
	int fR,fG,fB,bR,bG,bB;
}
- (id)initWithForegroundRed:(int)fr ForegroundGreen:(int)fg ForegroundBlue:(int)fb
		BackgroundRed:(int)br BackgroundGreen:(int)bg BackgroundBlue:(int)bb;
- (void)setForegroundRed:(int)red Green:(int)green Blue:(int)blue;
- (void)setBackgroundRed:(int)red Green:(int)green Blue:(int)blue;

- (float)getResult;

- (float)contrastRatio:(float)l1 l2: (float)l2;
- (float)relativeLuminanceRed:(int)r Green:(int)g Blue:(int)b;

@end
