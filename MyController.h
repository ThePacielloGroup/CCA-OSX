/* MyController */

#import <Cocoa/Cocoa.h>
#import "MyResults.h"
//#import "ImageFilter.h"

@interface MyController : NSObject
{
	IBOutlet NSWindow *myWindow;

	IBOutlet MyResults *myResults;
	
    IBOutlet NSBox *backgroundBox;
    IBOutlet NSBox *foregroundBox;
    IBOutlet NSBox *algorithmBox;
    IBOutlet NSBox *backgroundSliderBox;
    IBOutlet NSBox *foregroundSliderBox;
	IBOutlet NSMenuItem *menuShowSliders;
	IBOutlet NSMenuItem *menuHEX;
    IBOutlet NSMenuItem *menuRGB;
	IBOutlet NSMenuItem *menuAlgorithmColourBrightnessDifference;
	IBOutlet NSMenuItem *menuAlgorithmLuminosity;
	IBOutlet NSButtonCell *buttonAlgorithmColourBrightnessDifference;
	IBOutlet NSButtonCell *buttonAlgorithmLuminosity;
		
	IBOutlet NSTabView *HEXRGB_Foreground;
	IBOutlet NSTabView *HEXRGB_Background;
	IBOutlet NSTextView *detailedView;
	
	IBOutlet NSTabView *resultsColourBrightnessDifference;
	IBOutlet NSTabView *resultsLuminosity;
	
//    ImageFilter *imageFilter;
	
}

- (IBAction)showSliders:(id)sender;
- (IBAction)showHex:(id)sender;
- (IBAction)showRGB:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)copyDetails:(id)sender;
- (IBAction)showAlgorithmColourBrightnessDifference:(id)sender;
- (IBAction)showAlgorithmLuminosity:(id)sender;

- (void)hideView:(NSView *)view;
- (void)showView:(NSView *)view OnView:(NSView *)onView;
- (void)switchSliders:(BOOL)state;
- (void)resizeBox:(NSBox *)boxView diff:(float)diff;
- (void)moveView:(NSView *)boxView y:(float)y;
- (void)resizeWindowDiff:(int)diff;

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem: (NSTabViewItem *)tabViewItem;

@end