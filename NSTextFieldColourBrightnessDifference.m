#import "NSTextFieldColourBrightnessDifference.h"

@implementation NSTextFieldColourBrightnessDifference

-(void)validateDifferenceBrightness:(int)brightness Colour:(int)colour
{
	if (brightness > 125 && colour > 500) {
		[self setPass];
	} else {
		[self setFail];
	}
}

-(void)setFail
{
	if (currentStatus == YES) {
		[statusImage setImage:[NSImage imageNamed:@"No"]];
		currentStatus = NO;
	}
}

-(void)setPass
{
	if (currentStatus == NO) {
		[statusImage setImage:[NSImage imageNamed:@"Yes"]];
		currentStatus = YES;
	}
}

@end
