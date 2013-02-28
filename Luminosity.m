#import "Luminosity.h"

@implementation Luminosity

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

- (float)getResult;
{
	float l1, l2;
	l1 = [self relativeLuminanceRed:fR Green:fG Blue:fB];
	l2 = [self relativeLuminanceRed:bR Green:bG Blue:bB];
	return [self contrastRatio:l1 l2:l2];
}

-(float)contrastRatio:(float)l1 l2: (float)l2
{
	float cr;
	if (l1 >= l2) {
		cr = (l1 + 0.05)/(l2 + 0.05);
	} else {
		cr = (l2 + 0.05)/(l1 + 0.05);
	}
	return cr;
}

-(float)relativeLuminanceRed:(int)r Green:(int)g Blue:(int)b
{
	float Rs, Gs, Bs;
	Rs = r/255.0;
	Gs = g/255.0;
	Bs = b/255.0;
	if (Rs <= 0.03928) {
		Rs = Rs/12.92;
	} else {
		Rs = pow(((Rs+0.055)/1.055),2.4);
	}
	if (Gs <= 0.03928) {
		Gs = Gs/12.92;
	} else {
		Gs = pow(((Gs+0.055)/1.055),2.4);
	}
	if (Bs <= 0.03928) {
		Bs = Bs/12.92;
	} else {
		Bs = pow(((Bs+0.055)/1.055),2.4);
	}
	
	return 0.2126 * Rs + 0.7152 * Gs + 0.0722 * Bs;
}

@end
