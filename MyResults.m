#import "MyResults.h"

@implementation MyResults

- (void)awakeFromNib
{	
		
	mainLuminosity = [[Luminosity alloc]
		initWithForegroundRed:0 ForegroundGreen:0 ForegroundBlue:0
		BackgroundRed:255 BackgroundGreen:255 BackgroundBlue:255];
	mainColourBrightnessDifference = [[ColourBrightnessDifference alloc] 
		initWithForegroundRed:0 ForegroundGreen:0 ForegroundBlue:0
		BackgroundRed:255 BackgroundGreen:255 BackgroundBlue:255];
			
	[textAA initWithLevel:LEVEL_AA Size:SIZE_NORMAL];
	[textAAA initWithLevel:LEVEL_AAA Size:SIZE_NORMAL];
	[largeTextAA initWithLevel:LEVEL_AA Size:SIZE_LARGE];
	[largeTextAAA initWithLevel:LEVEL_AAA Size:SIZE_LARGE];

	[textNormal initWithDeficiency:COLORBLIND_DEFICIENCY_NONE];
	[textProtanopia initWithDeficiency:COLORBLIND_DEFICIENCY_PROTANOPIA];
	[textDeuteranopia initWithDeficiency:COLORBLIND_DEFICIENCY_DEUTERANOPIA];
	[textTritanopia initWithDeficiency:COLORBLIND_DEFICIENCY_TRITANOPIA];
	[textColorBlindness initWithDeficiency:COLORBLIND_DEFICIENCY_COLORBLINDNESS];
	
	[colourBrightnessDifferenceNormal initWithDeficiency:COLORBLIND_DEFICIENCY_NONE];
	[colourBrightnessDifferenceProtanopia initWithDeficiency:COLORBLIND_DEFICIENCY_PROTANOPIA];
	[colourBrightnessDifferenceDeuteranopia initWithDeficiency:COLORBLIND_DEFICIENCY_DEUTERANOPIA];
	[colourBrightnessDifferenceTritanopia initWithDeficiency:COLORBLIND_DEFICIENCY_TRITANOPIA];
	[colourBrightnessDifferenceColorBlindness initWithDeficiency:COLORBLIND_DEFICIENCY_COLORBLINDNESS];

	[self setForegroundColor:[[NSColor blackColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]];
	[self setBackgroundColor:[[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]];
	[self setResults];
}


- (NSString*)HexFromRGB:(int)intRed intGreen:(int)intGreen intBlue:(int)intBlue
{
    int         _intR1, _intR2, _intG1, _intG2, _intB1, _intB2;
	NSString    *_hex;

    _intR1 = (int)floor(intRed / 16);
    _intR2 = (int)((int)intRed % 16);
    _intG1 = (int)floor(intGreen / 16);
    _intG2 = (int)((int)intGreen % 16);
    _intB1 = (int)floor(intBlue / 16);
    _intB2 = (int)((int)intBlue % 16);

    _hex = [NSString stringWithFormat: @"#%01X%01X%01X%01X%01X%01X", _intR1, _intR2, _intG1, _intG2, _intB1, _intB2];
//    NSLog(@"H: %d,%d,%d = %@", intRed, intGreen, intBlue, _hex);

    return _hex;
}

- (NSString*)getHexFromColor:(NSColor*)color
{
    CGFloat		_red, _green, _blue;
    int         _intR, _intG, _intB;

    [color getRed:&_red
			green:&_green
             blue:&_blue
			alpha:NULL];

//    NSLog(@"H: %f %f %f", _red, _green, _blue);
    
	_intR = (int)roundf(_red * 255);
	_intG = (int)roundf(_green * 255);
	_intB = (int)roundf(_blue * 255);
    
    return [self HexFromRGB:_intR intGreen:_intG intBlue:_intB];
}

- (NSString*)getForegroundHex
{
    return [self getHexFromColor:foregroundColor];
}

- (NSString*)getBackgroundHex
{
    return [self getHexFromColor:backgroundColor];
}

- (void)setForegroundColor:(NSColor*)color
{
    CGFloat		_red, _green, _blue;
    int         _intR, _intG, _intB;
    
    [color getRed:&_red
			green:&_green
             blue:&_blue
			alpha:NULL];
    
	_intR = (int)roundf(_red * 255);
	_intG = (int)roundf(_green * 255);
	_intB = (int)roundf(_blue * 255);


    NSLog(@"FC: %d %d %d", _intR, _intG, _intB);
    
	[mainLuminosity setForegroundRed:_intR Green:_intG Blue:_intB];
	[mainColourBrightnessDifference setForegroundRed:_intR Green:_intG Blue:_intB];
	
	foregroundColor = color;
	[self setTextForeground:color];
}

- (void)setBackgroundColor:(NSColor*)color
{
    CGFloat		_red, _green, _blue;
    int         _intR, _intG, _intB;
    
    [color getRed:&_red
			green:&_green
             blue:&_blue
			alpha:NULL];
    
	_intR = (int)roundf(_red * 255);
	_intG = (int)roundf(_green * 255);
	_intB = (int)roundf(_blue * 255);
    
	[mainLuminosity setBackgroundRed:_intR Green:_intG Blue:_intB];
	[mainColourBrightnessDifference setBackgroundRed:_intR Green:_intG Blue:_intB];
    
	backgroundColor = color;
	[self setTextBackground:color];
}

-(void)setTextForeground:(NSColor*)color
{
	[textAA setTextColor:color];
	[textAAA setTextColor:color];
	[largeTextAA setTextColor:color];
	[largeTextAAA setTextColor:color];
	
	[textNormal setTextColor:color];
	[textProtanopia setTextColor:color];
	[textDeuteranopia setTextColor:color];
	[textTritanopia setTextColor:color];
	[textColorBlindness setTextColor:color];

	[textColourBrightnessDifference setTextColor:color];
	
	[colourBrightnessDifferenceNormal setTextColor:color];
	[colourBrightnessDifferenceProtanopia setTextColor:color];
	[colourBrightnessDifferenceDeuteranopia setTextColor:color];
	[colourBrightnessDifferenceTritanopia setTextColor:color];
	[colourBrightnessDifferenceColorBlindness setTextColor:color];
}

-(void)setTextBackground:(NSColor*)color
{	
	[textAA setBackgroundColor:color];
	[textAAA setBackgroundColor:color];
	[largeTextAA setBackgroundColor:color];
	[largeTextAAA setBackgroundColor:color];
	
	[textNormal setBackgroundColor:color];
	[textProtanopia setBackgroundColor:color];
	[textDeuteranopia setBackgroundColor:color];
	[textTritanopia setBackgroundColor:color];
	[textColorBlindness setBackgroundColor:color];

	[textColourBrightnessDifference setBackgroundColor:color];

	[colourBrightnessDifferenceNormal setBackgroundColor:color];
	[colourBrightnessDifferenceProtanopia setBackgroundColor:color];
	[colourBrightnessDifferenceDeuteranopia setBackgroundColor:color];
	[colourBrightnessDifferenceTritanopia setBackgroundColor:color];
	[colourBrightnessDifferenceColorBlindness setBackgroundColor:color];
}

-(void)setResults
{
	mainContrastRatio = [mainLuminosity getResult];
	brightnessDifference = [mainColourBrightnessDifference getBrightnessDifference];
	colourDifference = [mainColourBrightnessDifference getColourDifference];
	[self displayResults];
	[self displayDetailedResults];
}

-(void)displayResults
{
	NSString *crs, *dbs;
	
	crs = [NSString stringWithFormat: @"%@: %.2f:1"
	, [NSApp Localisation:@"Contrast ratio"]
	, mainContrastRatio];
	[contrastRatio setStringValue:crs];
		
	dbs = [NSString stringWithFormat: @"%@: %d / %d"
	, [NSApp Localisation:@"Colour/Brightness difference"]
	, colourDifference, brightnessDifference];
	[colourBrightnessDifference setStringValue:dbs];
		
	[textColourBrightnessDifference validateDifferenceBrightness:brightnessDifference Colour:colourDifference];
		
	[textAA validateText:mainContrastRatio];
	[textAAA validateText:mainContrastRatio];
	[largeTextAA validateText:mainContrastRatio];
	[largeTextAAA validateText:mainContrastRatio];
	
	[textNormal displayContrastRatio];
	[textProtanopia displayContrastRatio];
	[textDeuteranopia displayContrastRatio];
	[textTritanopia displayContrastRatio];
	[textColorBlindness displayContrastRatio];
	
	[colourBrightnessDifferenceNormal displayColourBrightnessDifference];
	[colourBrightnessDifferenceProtanopia displayColourBrightnessDifference];
	[colourBrightnessDifferenceDeuteranopia displayColourBrightnessDifference];
	[colourBrightnessDifferenceTritanopia displayColourBrightnessDifference];
	[colourBrightnessDifferenceColorBlindness displayColourBrightnessDifference];
}

- (void)displayDetailedResults
{
	NSString *resBrightness, *resColour;
	NSString *detailedText = [[NSString alloc] initWithFormat: @"%@: ", [NSApp Localisation:@"Foreground"]];
    detailedText = [detailedText stringByAppendingString:[self getForegroundHex]];
    detailedText = [detailedText stringByAppendingFormat: @" - %@: ", [NSApp Localisation:@"Background"]];
    detailedText = [detailedText stringByAppendingString:[self getBackgroundHex]];
    
	if (algorithm == ALGORITHM_COLOUR_BRIGHTNESS_DIFFERENCE) {
		detailedText = [detailedText stringByAppendingFormat: 
			@"\n\n%@:%d / %@:%d"
			, [NSApp Localisation:@"colour difference"]
			, colourDifference
			, [NSApp Localisation:@"brightness difference"]
			, brightnessDifference];
		
		if (brightnessDifference >= 125) {
			resBrightness = [NSApp Localisation:@"sufficient"];
		} else {
			resBrightness = [NSApp Localisation:@"not sufficient"];
		}
		
		detailedText = [detailedText stringByAppendingFormat:
			@"\n\n%@ %@. %@ %d."
			, [NSApp Localisation:@"detail_1"]
			, resBrightness
			, [NSApp Localisation:@"detail_2"]
			, brightnessDifference];
		
		if (colourDifference >= 500) {
			resColour = [NSApp Localisation:@"sufficient"];
		} else {
			resColour = [NSApp Localisation:@"not sufficient"];
		}
		
		detailedText = [detailedText stringByAppendingFormat:			
			@"\n\n%@ %@. %@ %d."
			, [NSApp Localisation:@"detail_3"]
			, resColour
			, [NSApp Localisation:@"detail_4"]
			, colourDifference];
		
		if (colourDifference < 500 && colourDifference >= 400) {
			detailedText = [detailedText stringByAppendingFormat:
				@"\n\n%@"
				, [NSApp Localisation:@"detail_5"]];
		}
	} else {
		NSString *ntAA = [textAA getStatus];
		NSString *ntAAA = [textAAA getStatus];
		NSString *ltAA = [largeTextAA getStatus];
		NSString *ltAAA = [largeTextAAA getStatus];
	
		detailedText = [detailedText stringByAppendingString:[NSString stringWithFormat: 
			@"\n\n%@: %.2f:1"
			, [NSApp Localisation:@"The contrast ratio is"]
			, mainContrastRatio]];
		detailedText = [detailedText stringByAppendingString:[NSString stringWithFormat: 			
			@"\n\n%@\n%@\n%@\n%@"
			, ntAA, ntAAA, ltAA, ltAAA]];
		detailedText = [detailedText stringByAppendingString:[NSString stringWithFormat:
			@"\n\n%@"
			, [NSApp Localisation:@"detail_6"]]];
		detailedText = [detailedText stringByAppendingString:[NSString stringWithFormat:
			@"\n\n%@"
			, [NSApp Localisation:@"detail_7"]]];
		detailedText = [detailedText stringByAppendingString:[NSString stringWithFormat:
			@"\n\n%@"
			, [NSApp Localisation:@"detail_8"]]];
			
	}
	[detailedView setString:detailedText];	

}

- (void)setAlgorithm:(Algorithm)algo
{
	algorithm = algo;
}
@end
