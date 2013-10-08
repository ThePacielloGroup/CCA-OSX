#import "MyColourHex.h"

@implementation MyColourHex

- (void)awakeFromNib
{
	NSColor *color;
	if ([self isForeground]) {
		color = [[NSColor blackColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		previousHex = [[NSString alloc] initWithString:@"#000000" ];
	} else { // Background
		color = [[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		previousHex = [[NSString alloc] initWithString:@"#FFFFFF" ];
	}
	
	[self setWellFromColor:color];
	[self setSlidersFromColor:color];
	[self setHTMLFromColor:color];
	[self setRGBFromColor:color];
}

- (IBAction)updateFromHTML:(id)sender
{
	NSColor		*color;
	NSString	*red, *green, *blue, *hex;
	NSRange		range;
	
	hex = [htmlTextField stringValue];
	
	if ( [hex length] == 7 ) {
		// assuming the first char is #
		range = NSMakeRange( 1, 2);
		red = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		range = NSMakeRange( 3, 2);
		green = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		range = NSMakeRange( 5, 2);
		blue = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		
		// Save for undo futur wrong entry
		previousHex = hex;
		
		color = [NSColor colorWithCalibratedRed:([MyColourHex hexStringToInt:red]/255.0f)
										green:([MyColourHex hexStringToInt:green]/255.0f)
										blue:([MyColourHex hexStringToInt:blue]/255.0f)
										alpha:1.0f];
		[self setWellFromColor:color];
		[self setSlidersFromColor:color];
		[self setRGBFromColor:color];
		[self setResultsFromColor:color];
	} else { // If wrong entry
		// Set previous value
		[htmlTextField setStringValue:previousHex];
	}
}

- (IBAction)updateFromWell:(id)sender
{
	NSColor*	color = [colorWell color];
//	NSColor*	color = [[colorWell color] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	if ( color != nil ) {
		[self setSlidersFromColor:color];
		[self setHTMLFromColor:color];
		[self setRGBFromColor:color];
		[self setResultsFromColor:color];
	}
}

- (IBAction)updateFromRGB:(id)sender
{
	NSColor		*color;
	NSNumber	*red, *green, *blue;
	NSNumberFormatter *stringToInt = [[NSNumberFormatter alloc] init];;
	
	red = [stringToInt numberFromString:[redField stringValue]];
	green = [stringToInt numberFromString:[greenField stringValue]];
	blue = [stringToInt numberFromString:[blueField stringValue]];
		
	color = [NSColor colorWithCalibratedRed:([red intValue]/255.0f)
									green:([green intValue]/255.0f)
									blue:([blue intValue]/255.0f)
									alpha:1.0f];

	[self setWellFromColor:color];
	[self setSlidersFromColor:color];
	[self setHTMLFromColor:color];
	[self setResultsFromColor:color];
}

- (IBAction)updateFromSliders:(id)sender
{
	NSColor*	color = [NSColor colorWithCalibratedRed:[redSlider floatValue]
                                       green:[greenSlider floatValue]
                                        blue:[blueSlider floatValue]
                                       alpha:1.0f];

	[self setWellFromColor:color];
	[self setHTMLFromColor:color];
	[self setRGBFromColor:color];
	[self setResultsFromColor:color];
}

- (void)setWellFromColor:(NSColor*)color
{
//	NSColor*	c = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[colorWell setColor:color];
}

-(void)setHTMLFromColor:(NSColor*)color
{
	CGFloat		red, green, blue;
	int			intRed, intGreen, intBlue;
    int			intRed1, intRed2, intGreen1, intGreen2, intBlue1, intBlue2;
	NSString *hex;
		
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:NULL];

//    NSLog(@"%f,%f,%f",red,green,blue);

	intRed = (int)roundf(red * 255);
	intGreen = (int)roundf(green * 255);
	intBlue = (int)roundf(blue * 255);
    
    intRed1 = (int)floor(intRed / 16);
    intRed2 = (int)((int)intRed % 16);
    intGreen1 = (int)floor(intGreen / 16);
    intGreen2 = (int)((int)intGreen % 16);
    intBlue1 = (int)floor(intBlue / 16);
    intBlue2 = (int)((int)intBlue % 16);
//    NSLog(@"%d,%d,%d",intRed,intGreen,intBlue);
//    NSLog(@"%d,%d,%d,%d,%d,%d",intRed1, intRed2,intGreen1,intGreen2,intBlue1,intBlue2);
    
	hex = [NSString stringWithFormat: @"#%01X%01X%01X%01X%01X%01X",intRed1, intRed2,intGreen1,intGreen2,intBlue1,intBlue2];
    
	[htmlTextField setStringValue:hex];
}

- (void)setSlidersFromColor:(NSColor*)color
{
    // break out the components, values will be between 0 and 1
    float red = [color redComponent];
    float green = [color greenComponent];
    float blue = [color blueComponent];

    // update the sliders to reflect the current values of the color
    // the minimum and maximum values for the sliders are set to 0 and 1
    // respectively, so they directly map to the NSColor components
    [redSlider setFloatValue:red];
    [greenSlider setFloatValue:green];
    [blueSlider setFloatValue:blue];
}

- (void)setRGBFromColor:(NSColor*)color
{
	CGFloat		red,green,blue;
	NSString	*stmp;
	
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:NULL];
	
	stmp = [NSString stringWithFormat: @"%d",(int)roundf(red * 255)];
	[redField setStringValue:stmp];
	stmp = [NSString stringWithFormat: @"%d",(int)roundf(green * 255)];
	[greenField setStringValue:stmp];
	stmp = [NSString stringWithFormat: @"%d",(int)roundf(blue * 255)];
	[blueField setStringValue:stmp];
}

- (void)setResultsFromColor:(NSColor*)color
{
	NSColor		*c = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if ([self isForeground]) {
		[myResults setForegroundColor:c];
	} else { // Background
		[myResults setBackgroundColor:c];
	}
	[myResults setResults];
}


+(int)hexStringToInt:(NSString*)hexString
{
	unsigned int	returnInt = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	(void) [scanner scanHexInt:&returnInt];
	return returnInt;
}


- (bool)isForeground
{
	return nil;
}

@end
