/* NSTextFieldColourBlindness */

#import <Cocoa/Cocoa.h>
#import "Localization.h"
#import "Luminosity.h"
#import "ColourBrightnessDifference.h"

	typedef enum {
		COLORBLIND_DEFICIENCY_PROTANOPIA,
		COLORBLIND_DEFICIENCY_DEUTERANOPIA,
		COLORBLIND_DEFICIENCY_TRITANOPIA,
		COLORBLIND_DEFICIENCY_COLORBLINDNESS,
		COLORBLIND_DEFICIENCY_NONE
	} ColorblindDeficiency;
	
@interface NSTextFieldColourBlindness : NSTextField
{
	float rgb2lms[9];
	float lms2rgb[9];
	float gammaRGB[3];
	float fr,fg,fb,br,bg,bb;
	
	float                a1, b1, c1;
	float                a2, b2, c2;
	float                inflection;
	
	ColorblindDeficiency deficiency;
	Luminosity *luminosity;
	ColourBrightnessDifference *colourBrightnessDifference;
}

- (void)setBackgroundColor:(NSColor *)aColor;
- (void)setTextColor:(NSColor *)aColor;

- (void)initWithDeficiency:(ColorblindDeficiency)cd;
- (void)displayContrastRatio;
- (void)displayColourBrightnessDifference;

- (NSColor *)convertColor:(NSColor *)color;
+ (float)clamp:(float)x low:(float)low high:(float)high;

@end
