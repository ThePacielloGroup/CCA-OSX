/* MyResults */

#import <Cocoa/Cocoa.h>
#import "Localization.h"
#import "Luminosity.h"
#import "ColourBrightnessDifference.h"

#import "NSTextFieldLuminosity.h"
#import "NSTextFieldColourBlindness.h"
#import "NSTextFieldColourBrightnessDifference.h"

	typedef enum {
		ALGORITHM_COLOUR_BRIGHTNESS_DIFFERENCE,
		ALGORITHM_LUMINOSITY
	} Algorithm;
	
@interface MyResults : NSObject
{
    IBOutlet NSTextField *contrastRatio;
	IBOutlet NSTextField *colourBrightnessDifference;
	
	IBOutlet NSTextFieldColourBrightnessDifference *textColourBrightnessDifference;
	
    IBOutlet NSTextFieldLuminosity *largeTextAA;
    IBOutlet NSTextFieldLuminosity *largeTextAAA;
    IBOutlet NSTextFieldLuminosity *textAA;
    IBOutlet NSTextFieldLuminosity *textAAA;
	IBOutlet NSTextView *detailedView;
	
	IBOutlet NSTextFieldColourBlindness *textNormal;
	IBOutlet NSTextFieldColourBlindness *textProtanopia;
	IBOutlet NSTextFieldColourBlindness *textDeuteranopia;
	IBOutlet NSTextFieldColourBlindness *textTritanopia;
	IBOutlet NSTextFieldColourBlindness *textColorBlindness;
	
	IBOutlet NSTextFieldColourBlindness *colourBrightnessDifferenceNormal;
	IBOutlet NSTextFieldColourBlindness *colourBrightnessDifferenceProtanopia;
	IBOutlet NSTextFieldColourBlindness *colourBrightnessDifferenceDeuteranopia;
	IBOutlet NSTextFieldColourBlindness *colourBrightnessDifferenceTritanopia;
	IBOutlet NSTextFieldColourBlindness *colourBrightnessDifferenceColorBlindness;
	
	NSColor *foregroundColor;
	NSColor *backgroundColor;
	int foregroundR, foregroundG, foregroundB;
	int backgroundR, backgroundG, backgroundB;
	
	Luminosity *mainLuminosity;
	float mainContrastRatio;

	ColourBrightnessDifference *mainColourBrightnessDifference;
	int colourDifference, brightnessDifference;
	
	Algorithm algorithm;

}

- (void)setForegroundColor:(NSColor*)color;
- (void)setBackgroundColor:(NSColor*)color;
- (void)setTextBackground:(NSColor*)color;
- (void)setTextForeground:(NSColor*)color;
- (void)setResults;

- (void)displayResults;
- (void)displayDetailedResults;
- (void)setAlgorithm:(Algorithm)algo;
@end
