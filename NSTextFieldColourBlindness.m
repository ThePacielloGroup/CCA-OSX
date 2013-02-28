#import "NSTextFieldColourBlindness.h"

@implementation NSTextFieldColourBlindness

-(void)initWithDeficiency:(ColorblindDeficiency)cd;
{
	float              anchor_e[3];
	float              anchor[12];
 
  	deficiency = cd;
	luminosity = [[Luminosity alloc]
		initWithForegroundRed:0 ForegroundGreen:0 ForegroundBlue:0
		BackgroundRed:255 BackgroundGreen:255 BackgroundBlue:255];
	colourBrightnessDifference = [[ColourBrightnessDifference alloc]
		initWithForegroundRed:0 ForegroundGreen:0 ForegroundBlue:0
		BackgroundRed:255 BackgroundGreen:255 BackgroundBlue:255];
		
  /* For most modern Cathode-Ray Tube monitors (CRTs), the following
   * are good estimates of the RGB->LMS and LMS->RGB transform
   * matrices.  They are based on spectra measured on a typical CRT
   * with a PhotoResearch PR650 spectral photometer and the Stockman
   * human cone fundamentals. NOTE: these estimates will NOT work well
   * for LCDs!
   */
	rgb2lms[0] = 0.05059983;
	rgb2lms[1] = 0.08585369;
	rgb2lms[2] = 0.00952420;

	rgb2lms[3] = 0.01893033;
	rgb2lms[4] = 0.08925308;
	rgb2lms[5] = 0.01370054;

	rgb2lms[6] = 0.00292202;
	rgb2lms[7] = 0.00975732;
	rgb2lms[8] = 0.07145979;
  
	lms2rgb[0] =  30.830854;
	lms2rgb[1] = -29.832659;
	lms2rgb[2] =   1.610474;

	lms2rgb[3] =  -6.481468;
	lms2rgb[4] =  17.715578;
	lms2rgb[5] =  -2.532642;

	lms2rgb[6] =  -0.375690;
	lms2rgb[7] =  -1.199062;
	lms2rgb[8] =  14.273846;

  /* The RGB<->LMS transforms above are computed from the human cone
   * photo-pigment absorption spectra and the monitor phosphor
   * emission spectra. These parameters are fairly constant for most
   * humans and most montiors (at least for modern CRTs). However,
   * gamma will vary quite a bit, as it is a property of the monitor
   * (eg. amplifier gain), the video card, and even the
   * software. Further, users can adjust their gammas (either via
   * adjusting the monitor amp gains or in software). That said, the
   * following are the gamma estimates that we have used in the
   * Vischeck code. Many colorblind users have viewed our simulations
   * and told us that they "work" (simulated and original images are
   * indistinguishabled).
   */
	gammaRGB[0] = 2.1;
	gammaRGB[1] = 2.0;
	gammaRGB[2] = 2.1;
	
	/* Performs protan, deutan or tritan color image simulation based on
   * Brettel, Vienot and Mollon JOSA 14/10 1997
   *  L,M,S for lambda=475,485,575,660
   *
   * Load the LMS anchor-point values for lambda = 475 & 485 nm (for
   * protans & deutans) and the LMS values for lambda = 575 & 660 nm
   * (for tritans)
   */
  anchor[0] = 0.08008;  anchor[1]  = 0.1579;    anchor[2]  = 0.5897;
  anchor[3] = 0.1284;   anchor[4]  = 0.2237;    anchor[5]  = 0.3636;
  anchor[6] = 0.9856;   anchor[7]  = 0.7325;    anchor[8]  = 0.001079;
  anchor[9] = 0.0914;   anchor[10] = 0.007009;  anchor[11] = 0.0;

  /* We also need LMS for RGB=(1,1,1)- the equal-energy point (one of
   * our anchors) (we can just peel this out of the rgb2lms transform
   * matrix)
   */
  anchor_e[0] = rgb2lms[0] + rgb2lms[1] + rgb2lms[2];
  anchor_e[1] = rgb2lms[3] + rgb2lms[4] + rgb2lms[5];
  anchor_e[2] = rgb2lms[6] + rgb2lms[7] + rgb2lms[8];
	
  switch (deficiency)
    {
    case COLORBLIND_DEFICIENCY_DEUTERANOPIA:
      /* find a,b,c for lam=575nm and lam=475 */
      a1 = anchor_e[1] * anchor[8] - anchor_e[2] * anchor[7];
      b1 = anchor_e[2] * anchor[6] - anchor_e[0] * anchor[8];
      c1 = anchor_e[0] * anchor[7] - anchor_e[1] * anchor[6];
      a2 = anchor_e[1] * anchor[2] - anchor_e[2] * anchor[1];
      b2 = anchor_e[2] * anchor[0] - anchor_e[0] * anchor[2];
      c2 = anchor_e[0] * anchor[1] - anchor_e[1] * anchor[0];
      inflection = (anchor_e[2] / anchor_e[0]);
      break;

    case COLORBLIND_DEFICIENCY_PROTANOPIA:
      /* find a,b,c for lam=575nm and lam=475 */
      a1 = anchor_e[1] * anchor[8] - anchor_e[2] * anchor[7];
      b1 = anchor_e[2] * anchor[6] - anchor_e[0] * anchor[8];
      c1 = anchor_e[0] * anchor[7] - anchor_e[1] * anchor[6];
      a2 = anchor_e[1] * anchor[2] - anchor_e[2] * anchor[1];
      b2 = anchor_e[2] * anchor[0] - anchor_e[0] * anchor[2];
      c2 = anchor_e[0] * anchor[1] - anchor_e[1] * anchor[0];
      inflection = (anchor_e[2] / anchor_e[1]);
      break;

    case COLORBLIND_DEFICIENCY_TRITANOPIA:
      /* Set 1: regions where lambda_a=575, set 2: lambda_a=475 */
      a1 = anchor_e[1] * anchor[11] - anchor_e[2] * anchor[10];
      b1 = anchor_e[2] * anchor[9]  - anchor_e[0] * anchor[11];
      c1 = anchor_e[0] * anchor[10] - anchor_e[1] * anchor[9];
      a2 = anchor_e[1] * anchor[5]  - anchor_e[2] * anchor[4];
      b2 = anchor_e[2] * anchor[3]  - anchor_e[0] * anchor[5];
      c2 = anchor_e[0] * anchor[4]  - anchor_e[1] * anchor[3];
      inflection = (anchor_e[1] / anchor_e[0]);
      break;
            
    case COLORBLIND_DEFICIENCY_NONE:
      break;

    case COLORBLIND_DEFICIENCY_COLORBLINDNESS:
      break;
    }
}

- (void)setBackgroundColor:(NSColor *)aColor
{
	CGFloat		red,green,blue,alpha;
	int			intRed, intGreen, intBlue;
	
	NSColor *color = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	NSColor *convertedColor = [self convertColor:color];
	[convertedColor getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	intRed = (int)(red * 255);
	intGreen = (int)(green * 255);
	intBlue = (int)(blue * 255);	
	[luminosity setBackgroundRed:intRed Green:intGreen Blue:intBlue];
	[colourBrightnessDifference setBackgroundRed:intRed Green:intGreen Blue:intBlue];
		
	[super setBackgroundColor:convertedColor];
}

- (void)setTextColor:(NSColor *)aColor
{
	CGFloat		red,green,blue,alpha;
	int			intRed, intGreen, intBlue;
	
	NSColor *color = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	NSColor *convertedColor = [self convertColor:color];
	[convertedColor getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	intRed = (int)(red * 255);
	intGreen = (int)(green * 255);
	intBlue = (int)(blue * 255);
	[luminosity setForegroundRed:intRed Green:intGreen Blue:intBlue];
	[colourBrightnessDifference setForegroundRed:intRed Green:intGreen Blue:intBlue];
		
	[super setTextColor:convertedColor];
}

-(void)displayContrastRatio
{
	float cr = [luminosity getResult];
	NSString *crs = [NSString stringWithFormat: @"%@: %.1f:1", [NSApp Localisation:@"The contrast ratio is"] ,cr];
	[super setStringValue:crs];
}

-(void)displayColourBrightnessDifference
{
	int bd = [colourBrightnessDifference getBrightnessDifference];
	int cd = [colourBrightnessDifference getColourDifference];
	NSString *crs = [NSString stringWithFormat: @"%@:%d / %@:%d", [NSApp Localisation:@"colour difference"], cd, [NSApp Localisation:@"brightness difference"], bd];
	[super setStringValue:crs];
}

- (NSColor *)convertColor:(NSColor *)color
{
	float	red, green, blue, gray, redOld, greenOld;
	float	tmp;
	NSColor *res;
	
	if (deficiency == COLORBLIND_DEFICIENCY_NONE) {
		res = color;
	} else {
		red = [color redComponent] * 255;
		green = [color greenComponent] * 255;
		blue = [color blueComponent] * 255;
		if (deficiency != COLORBLIND_DEFICIENCY_COLORBLINDNESS) {
			/* Remove gamma to linearize RGB intensities */
			red   = pow (red,   1.0 / gammaRGB[0]);
			green = pow (green, 1.0 / gammaRGB[1]);
			blue  = pow (blue,  1.0 / gammaRGB[2]);
//			NSLog(@"\nA RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
			/* Convert to LMS (dot product with transform matrix) */
			redOld   = red;
			greenOld = green;

			red   = redOld * rgb2lms[0] + greenOld * rgb2lms[1] + blue * rgb2lms[2];
			green = redOld * rgb2lms[3] + greenOld * rgb2lms[4] + blue * rgb2lms[5];
			blue  = redOld * rgb2lms[6] + greenOld * rgb2lms[7] + blue * rgb2lms[8];
//			NSLog(@"\nB RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
		}
		switch (deficiency){
          case COLORBLIND_DEFICIENCY_DEUTERANOPIA:
			tmp = blue / red;
				/* See which side of the inflection line we fall... */
				if (tmp < inflection)
					green = -(a1 * red + c1 * blue) / b1;
				else
					green = -(a2 * red + c2 * blue) / b2;
				break;

          case COLORBLIND_DEFICIENCY_PROTANOPIA:
            tmp = blue / green;
				/* See which side of the inflection line we fall... */
				if (tmp < inflection)
					red = -(b1 * green + c1 * blue) / a1;
				else
					red = -(b2 * green + c2 * blue) / a2;
				break;

          case COLORBLIND_DEFICIENCY_TRITANOPIA:
            tmp = green / red;
				/* See which side of the inflection line we fall... */
				if (tmp < inflection)
					blue = -(a1 * red + b1 * green) / c1;
				else
					blue = -(a2 * red + b2 * green) / c2;
				break;

          case COLORBLIND_DEFICIENCY_COLORBLINDNESS:
				gray = 0.3 * red + 0.59 * green + 0.11 * blue;
				red = gray;
				green = gray;
				blue = gray;
				break;
						  
			default:
				break;
		}
		if (deficiency != COLORBLIND_DEFICIENCY_COLORBLINDNESS) {
//			NSLog(@"\n Tmp:%f - Inflection:%f",tmp, inflection);
//			NSLog(@"\nC RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
	        /* Convert back to RGB (cross product with transform matrix) */
			redOld   = red;
			greenOld = green;

			red   = redOld * lms2rgb[0] + greenOld * lms2rgb[1] + blue * lms2rgb[2];
			green = redOld * lms2rgb[3] + greenOld * lms2rgb[4] + blue * lms2rgb[5];
			blue  = redOld * lms2rgb[6] + greenOld * lms2rgb[7] + blue * lms2rgb[8];
//			NSLog(@"\nD RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
			/* Apply gamma to go back to non-linear intensities */
			red   = pow (red,   gammaRGB[0]);
			green = pow (green, gammaRGB[1]);
			blue  = pow (blue,  gammaRGB[2]);
//			NSLog(@"\nE RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
		}
		/* Ensure that we stay within the RGB gamut */
		/* *** FIX THIS: it would be better to desaturate than blindly clip. */
		red   = [NSTextFieldColourBlindness clamp:red low:0.0 high:255.0]/255.0;
		green = [NSTextFieldColourBlindness clamp:green low:0.0 high:255.0]/255.0;
		blue  = [NSTextFieldColourBlindness clamp:blue low:0.0 high:255.0]/255.0;
//		NSLog(@"\nApres RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
		res = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
	}
	
	return res;
}

+ (float)clamp:(float)x low:(float)low high:(float)high
{
	float ret;
	if (x > high) {
		ret = high;
	} else if (x < low) {
		ret = low;
	} else if isnan(x) {
		ret = low;
	} else {
		ret = x;
	}
	return ret;
}

@end
