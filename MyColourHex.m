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
	[colorWell setColor:color];
}

-(void)setHTMLFromColor:(NSColor*)color
{
	CGFloat		_red, _green, _blue;
	int			_intR, _intG, _intB;
    int			_intR1, _intR2, _intG1, _intG2, _intB1, _intB2;
	NSString    *_hex;
		
	[color getRed:&_red
			green:&_green
			blue:&_blue
			alpha:NULL];

	_intR = (int)roundf(_red * 255);
	_intG = (int)roundf(_green * 255);
	_intB = (int)roundf(_blue * 255);
    
    _intR1 = (int)floor(_intR / 16);
    _intR2 = (int)((int)_intR % 16);
    _intG1 = (int)floor(_intG / 16);
    _intG2 = (int)((int)_intG % 16);
    _intB1 = (int)floor(_intB / 16);
    _intB2 = (int)((int)_intB % 16);
    
	_hex = [NSString stringWithFormat: @"#%01X%01X%01X%01X%01X%01X", _intR1, _intR2, _intG1, _intG2, _intB1, _intB2];
//    NSLog(@"M: %d,%d,%d = %@", _intR, _intG, _intB, _hex);
    
	[htmlTextField setStringValue: _hex];
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
	if ([self isForeground]) {
		[myResults setForegroundColor:color];
	} else { // Background
		[myResults setBackgroundColor:color];
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
