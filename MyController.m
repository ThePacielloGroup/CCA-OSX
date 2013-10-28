#import "MyController.h"

static NSString *cca_url = @"http://www.paciellogroup.com/resources/contrast-analyser.html";

@implementation MyController

- (void)awakeFromNib
{
	[NSApp setDelegate:self]; //BUG #1 - Program end with last window closed
	
	[resultsColourBrightnessDifference setDelegate:self];
	[resultsLuminosity setDelegate:self];
    
	[self switchSliders:NO];
	
	[self showAlgorithmLuminosity:nil];
	[self moveView:resultsColourBrightnessDifference y:-243];
	[self moveView:algorithmBox y:-243];
	[self moveView:backgroundBox y:-243];
	[self moveView:foregroundBox y:-243];
	[self resizeWindowDiff:-243];
    
//    imageFilter = [[ImageFilter alloc] init];
//    [imageFilter launchSession];
}

// Program end with last window closed
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication {
    return YES;
}

- (IBAction)showSliders:(id)sender
{
	if ([menuShowSliders state] == NSOnState) {
		[self switchSliders:NO];
	} else {
		[self switchSliders:YES];
	}
}

- (IBAction)showHex:(id)sender
{ 
	if ([menuHEX state] == NSOffState) { // If Hex no already selected
		[menuHEX setState:NSOnState];
		[menuRGB setState:NSOffState];
		[HEXRGB_Foreground selectTabViewItemAtIndex:0];
		[HEXRGB_Background selectTabViewItemAtIndex:0];
	}
}

- (IBAction)showRGB:(id)sender
{
	if ([menuRGB state] == NSOffState) { // If RGB no already selected
		[menuRGB setState:NSOnState];
		[menuHEX setState:NSOffState];
		[HEXRGB_Foreground selectTabViewItemAtIndex:1];
		[HEXRGB_Background selectTabViewItemAtIndex:1];
	}
}

- (IBAction)showHelp:(id)sender
{
	 NSWorkspace *ws = [NSWorkspace sharedWorkspace];
	 [ws openURL:[NSURL URLWithString:cca_url]];
}

- (IBAction)copyDetails:(id)sender
{
    NSRange range;
    range = NSMakeRange (0, [[detailedView string] length]);
	[detailedView setSelectedRange:range];
	[detailedView copy:sender];
	range = NSMakeRange (0, 0);
	[detailedView setSelectedRange:range];
}

- (IBAction)showAlgorithmColourBrightnessDifference:(id)sender
{
	[myResults setAlgorithm:ALGORITHM_COLOUR_BRIGHTNESS_DIFFERENCE];
	[myResults displayDetailedResults];
	[menuAlgorithmColourBrightnessDifference setState:NSOnState];
	[menuAlgorithmLuminosity setState:NSOffState];
	[buttonAlgorithmColourBrightnessDifference setState:NSOnState];
	[buttonAlgorithmLuminosity setState:NSOffState];
	[self hideView:resultsLuminosity];
	[self showView:resultsColourBrightnessDifference OnView:[myWindow contentView]];
}

- (IBAction)showAlgorithmLuminosity:(id)sender
{
	[myResults setAlgorithm:ALGORITHM_LUMINOSITY];
	[myResults displayDetailedResults];
	[menuAlgorithmColourBrightnessDifference setState:NSOffState];
	[menuAlgorithmLuminosity setState:NSOnState];
	[buttonAlgorithmColourBrightnessDifference setState:NSOffState];
	[buttonAlgorithmLuminosity setState:NSOnState];
	[self showView:resultsLuminosity OnView:[myWindow contentView]];
	[self hideView:resultsColourBrightnessDifference];
}

- (void)hideView:(NSView *)view
{
	[view retain];
	[view removeFromSuperview];
}

- (void)showView:(NSView *)view OnView:(NSView *)onView
{
	[onView addSubview:view];
}

- (void)switchSliders:(BOOL)state
{
	
	if (state) {
//		[self moveView:resultsBox y:-156];
		[self moveView:foregroundBox y:78];
//		[self moveView:backgroundBox y:78];
		[self resizeBox:backgroundBox diff:78];
		[self resizeBox:foregroundBox diff:78];
		[self resizeWindowDiff:156];
		
		[self showView:foregroundSliderBox OnView:foregroundBox];
		[self showView:backgroundSliderBox OnView:backgroundBox];
		[menuShowSliders setState:NSOnState];
	} else {
		[self hideView:foregroundSliderBox];
		[self hideView:backgroundSliderBox];
		[menuShowSliders setState:NSOffState];

		[self resizeWindowDiff:-156];
		[self resizeBox:foregroundBox diff:-78];
		[self resizeBox:backgroundBox diff:-78];
//		[self moveView:backgroundBox y:-78];
		[self moveView:foregroundBox y:-78];
//		[self moveView:resultsBox y:156];
	}
	
	[[myWindow contentView] setNeedsDisplay:YES];
}

- (void)resizeBox:(NSBox *)boxView diff:(float)diff
{
    NSView* contentView = [boxView contentView];
    NSRect originalContentFrame = [contentView frame];
        
    NSEnumerator* e = [[contentView subviews] objectEnumerator];
    NSView* subview;

	// Move all of the subview by that amount
	e = [[contentView subviews] objectEnumerator];
	while ( (subview=[e nextObject]) != nil )
		[subview setFrame:NSOffsetRect([subview frame],0,diff)];
	[contentView setNeedsDisplay:YES];
    
    // Adjust the size of the box's content view so that it is the exact height of its contents
	originalContentFrame.size.height += diff;
	[boxView setFrameFromContentFrame:[boxView convertRect:originalContentFrame toView:[boxView superview]]];
	[boxView setNeedsDisplay:YES];
}

- (void)moveView:(NSView *)boxView y:(float)y
{
	[boxView setFrame:NSOffsetRect([boxView frame],0,y)];
}

- (void)resizeWindowDiff:(int)diff
{
	NSRect originalFrame = [myWindow frame];
	originalFrame.size.height += diff;
	[myWindow setFrame:originalFrame display:YES];
}


// Synchonize tabViews
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	[resultsLuminosity selectTabViewItemAtIndex:[tabView indexOfTabViewItem: tabViewItem ]];
	[resultsColourBrightnessDifference selectTabViewItemAtIndex:[tabView indexOfTabViewItem: tabViewItem ]];
}

@end
