/* MyColourHex */

#import <Cocoa/Cocoa.h>
#import "MyResults.h"

@interface MyColourHex : NSObject
{
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSTextField *htmlTextField;
	IBOutlet NSSlider *redSlider;
    IBOutlet NSSlider *greenSlider;
    IBOutlet NSSlider *blueSlider;
	IBOutlet NSBox *nsBox;
	IBOutlet MyResults *myResults;
	IBOutlet NSTextField *redField, *greenField, *blueField;
	NSString *previousHex;
}
+(int)hexStringToInt:(NSString*)hexString;

- (IBAction)updateFromHTML:(id)sender;
- (IBAction)updateFromWell:(id)sender;
- (IBAction)updateFromSliders:(id)sender;
- (IBAction)updateFromRGB:(id)sender;

- (void)setWellFromColor:(NSColor*)color;
- (void)setHTMLFromColor:(NSColor*)color;
- (void)setSlidersFromColor:(NSColor*)color;
- (void)setRGBFromColor:(NSColor*)color;
- (void)setResultsFromColor:(NSColor*)color;
- (bool)isForeground;//subclass

@end