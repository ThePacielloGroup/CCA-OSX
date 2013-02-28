/* NSTextFieldBrightnessColourBrightnessDifference */

#import <Cocoa/Cocoa.h>

@interface NSTextFieldColourBrightnessDifference : NSTextField
{
	bool currentStatus;
	IBOutlet NSImageView *statusImage;
}

-(void)validateDifferenceBrightness:(int)brightness Colour:(int)colour;
-(void)setFail;
-(void)setPass;

@end
