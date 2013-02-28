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

	[self setForegroundColor:[[NSColor blackColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace]];
	[self setBackgroundColor:[[NSColor whiteColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace]];
	[self setResults];
}


- (void)setForegroundColor:(NSColor*)color
{
	float		red,green,blue,alpha;
	
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	foregroundR = (red * 255);
	foregroundG = (green * 255);
	foregroundB = (blue * 255);

	[mainLuminosity setForegroundRed:foregroundR Green:foregroundG Blue:foregroundB];
	[mainColourBrightnessDifference setForegroundRed:foregroundR Green:foregroundG Blue:foregroundB];
	
	foregroundColor = color;
	[self setTextForeground:color];
}

- (void)setBackgroundColor:(NSColor*)color
{
	float		red,green,blue,alpha;
	
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	backgroundR = (red * 255);
	backgroundG = (green * 255);
	backgroundB = (blue * 255);
	
	[mainLuminosity setBackgroundRed:backgroundR Green:backgroundG Blue:backgroundB];	
	[mainColourBrightnessDifference setBackgroundRed:backgroundR Green:backgroundG Blue:backgroundB];
		
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
	
	crs = [NSString stringWithFormat: @"%@: %.1f:1"
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
	NSString *detailedText = [[NSString alloc] initWithFormat: @"%@: #%02X%02X%02X - %@: #%02X%02X%02X"
			,[NSApp Localisation:@"Foreground"]
			, foregroundR, foregroundG, foregroundB
			,[NSApp Localisation:@"Background"]
			, backgroundR, backgroundG, backgroundB];

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
			@"\n\n%@: %.1f:1"
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
