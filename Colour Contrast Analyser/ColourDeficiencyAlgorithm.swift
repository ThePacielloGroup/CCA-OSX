//
//  ColourDeficiencyAlgorithm.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 20/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ColourDeficiency {
    /* For most modern Cathode-Ray Tube monitors (CRTs), the following
    * are good estimates of the RGB->LMS and LMS->RGB transform
    * matrices.  They are based on spectra measured on a typical CRT
    * with a PhotoResearch PR650 spectral photometer and the Stockman
    * human cone fundamentals. NOTE: these estimates will NOT work well
    * for LCDs!
    */
    let rgb2lms:[Double] = [0.05059983, 0.08585369, 0.00952420, 0.01893033, 0.08925308, 0.01370054, 0.00292202, 0.00975732, 0.07145979]
    let lms2rgb:[Double] = [30.830854, -29.832659, 1.610474, -6.481468, 17.715578, -2.532642, -0.375690, -1.199062, 14.273846]
    
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
    let gammaRGB:[Double] = [2.1, 2.0, 2.1]
    
    /* Performs protan, deutan or tritan color image simulation based on
    * Brettel, Vienot and Mollon JOSA 14/10 1997
    *  L,M,S for lambda=475,485,575,660
    *
    * Load the LMS anchor-point values for lambda = 475 & 485 nm (for
    * protans & deutans) and the LMS values for lambda = 575 & 660 nm
    * (for tritans)
    */
    let anchor:[Double] = [0.08008, 0.1579, 0.5897, 0.1284, 0.2237, 0.3636, 0.9856, 0.7325, 0.001079, 0.0914, 0.007009, 0.0]
    
    
    func convertColor(_ color:NSColor) -> NSColor {
        return color
    }
    
    func initialStep(_ color:NSColor) -> (red:Double, green:Double, blue:Double) {
        /* Remove gamma to linearize RGB intensities */
        var red   = pow (color.getRDouble(),   1.0 / gammaRGB[0])
        var green = pow (color.getGDouble(), 1.0 / gammaRGB[1])
        var blue  = pow (color.getBDouble(),  1.0 / gammaRGB[2])
        //			NSLog(@"\nA RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        /* Convert to LMS (dot product with transform matrix) */
        let redOld   = red;
        let greenOld = green;
        
        red   = redOld * rgb2lms[0] + greenOld * rgb2lms[1] + blue * rgb2lms[2];
        green = redOld * rgb2lms[3] + greenOld * rgb2lms[4] + blue * rgb2lms[5];
        blue  = redOld * rgb2lms[6] + greenOld * rgb2lms[7] + blue * rgb2lms[8];
        //			NSLog(@"\nB RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        return (red, green, blue)
    }
    
    func finalStep(_ r:Double, g:Double, b:Double) -> (red:Double, green:Double, blue:Double) {
        //			NSLog(@"\n Tmp:%f - Inflection:%f",tmp, inflection);
        //			NSLog(@"\nC RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        /* Convert back to RGB (cross product with transform matrix) */
        var red   = r * lms2rgb[0] + g * lms2rgb[1] + b * lms2rgb[2];
        var green = r * lms2rgb[3] + g * lms2rgb[4] + b * lms2rgb[5];
        var blue  = r * lms2rgb[6] + g * lms2rgb[7] + b * lms2rgb[8];
        //			NSLog(@"\nD RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        /* Apply gamma to go back to non-linear intensities */
        red   = pow (red,   gammaRGB[0]);
        green = pow (green, gammaRGB[1]);
        blue  = pow (blue,  gammaRGB[2]);
        //			NSLog(@"\nE RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        return (red, green, blue)
    }
    
    class func clamp(_ x:Double, low:Double, high:Double) -> Double {
        var ret: Double
        if x > high {
            ret = high;
        } else if x < low {
            ret = low;
        } else if x.isNaN {
            ret = low;
        } else {
            ret = x;
        }
        return ret;
    }
    class func toColor(_ r:Double, g:Double, b:Double) -> NSColor {
        /* Ensure that we stay within the RGB gamut */
        /* *** FIX THIS: it would be better to desaturate than blindly clip. */
        let red   = ColourDeficiency.clamp(r, low:0.0, high:255.0)/255.0
        let green = ColourDeficiency.clamp(g, low:0.0, high:255.0)/255.0
        let blue  = ColourDeficiency.clamp(b, low:0.0, high:255.0)/255.0
        //		NSLog(@"\nApres RED:%f - GREEN:%f - BLUE:%f",red,green,blue);
        return NSColor(redDouble:red, greenDouble:green, blueDouble:blue)!
    }
}

class ColourDeficiencyNone: ColourDeficiency {
    override func convertColor(_ color:NSColor) -> NSColor {
        return color
    }
}


class ColourDeficiencyProtanopia: ColourDeficiency {
    var a1, b1, c1: Double?
    var a2, b2, c2: Double?
    var inflection: Double?
    
    override init() {
        super.init()
        /* We also need LMS for RGB=(1,1,1)- the equal-energy point (one of
        * our anchors) (we can just peel this out of the rgb2lms transform
        * matrix)
        */
        var anchor_e = [Double]()
        anchor_e.append(rgb2lms[0] + rgb2lms[1] + rgb2lms[2])
        anchor_e.append(rgb2lms[3] + rgb2lms[4] + rgb2lms[5])
        anchor_e.append(rgb2lms[6] + rgb2lms[7] + rgb2lms[8])
        /* find a,b,c for lam=575nm and lam=475 */
        a1 = anchor_e[1] * anchor[8] - anchor_e[2] * anchor[7];
        b1 = anchor_e[2] * anchor[6] - anchor_e[0] * anchor[8];
        c1 = anchor_e[0] * anchor[7] - anchor_e[1] * anchor[6];
        a2 = anchor_e[1] * anchor[2] - anchor_e[2] * anchor[1];
        b2 = anchor_e[2] * anchor[0] - anchor_e[0] * anchor[2];
        c2 = anchor_e[0] * anchor[1] - anchor_e[1] * anchor[0];
        inflection = (anchor_e[2] / anchor_e[1]);
    }
    
    override func convertColor(_ color:NSColor) -> NSColor {
        let initial = initialStep(color)
        var red = initial.red
        var green = initial.green
        var blue = initial.blue
        let tmp = blue / green
        
        /* See which side of the inflection line we fall... */
        if tmp < inflection {
            red = -(b1! * green + c1! * blue) / a1!
        } else {
            red = -(b2! * green + c2! * blue) / a2!
        }
        let final = finalStep(red, g:green, b:blue)
        red = final.red
        green = final.green
        blue = final.blue
        
        return ColourDeficiency.toColor(final.red, g: final.green, b: final.blue)
    }
}

class ColourDeficiencyDeuteranopia: ColourDeficiency {
    var a1, b1, c1: Double?
    var a2, b2, c2: Double?
    var inflection: Double?
    
    override init() {
        super.init()
        /* We also need LMS for RGB=(1,1,1)- the equal-energy point (one of
        * our anchors) (we can just peel this out of the rgb2lms transform
        * matrix)
        */
        var anchor_e = [Double]()
        anchor_e.append(rgb2lms[0] + rgb2lms[1] + rgb2lms[2])
        anchor_e.append(rgb2lms[3] + rgb2lms[4] + rgb2lms[5])
        anchor_e.append(rgb2lms[6] + rgb2lms[7] + rgb2lms[8])
        /* find a,b,c for lam=575nm and lam=475 */
        a1 = anchor_e[1] * anchor[8] - anchor_e[2] * anchor[7];
        b1 = anchor_e[2] * anchor[6] - anchor_e[0] * anchor[8];
        c1 = anchor_e[0] * anchor[7] - anchor_e[1] * anchor[6];
        a2 = anchor_e[1] * anchor[2] - anchor_e[2] * anchor[1];
        b2 = anchor_e[2] * anchor[0] - anchor_e[0] * anchor[2];
        c2 = anchor_e[0] * anchor[1] - anchor_e[1] * anchor[0];
        inflection = (anchor_e[2] / anchor_e[0]);
    }
    
    override func convertColor(_ color:NSColor) -> NSColor {
        let initial = initialStep(color)
        var red = initial.red
        var green = initial.green
        var blue = initial.blue
        let tmp = blue / red
        
        /* See which side of the inflection line we fall... */
        if tmp < inflection {
            green = -(a1! * red + c1! * blue) / b1!
        } else {
            green = -(a2! * red + c2! * blue) / b2!
        }
        
        let final = finalStep(red, g:green, b:blue)
        red = final.red
        green = final.green
        blue = final.blue
        
        return ColourDeficiency.toColor(final.red, g: final.green, b: final.blue)
    }
}

class ColourDeficiencyTritanopia: ColourDeficiency {
    var a1, b1, c1: Double?
    var a2, b2, c2: Double?
    var inflection: Double?
    
    override init() {
        super.init()
        /* We also need LMS for RGB=(1,1,1)- the equal-energy point (one of
        * our anchors) (we can just peel this out of the rgb2lms transform
        * matrix)
        */
        var anchor_e = [Double]()
        anchor_e.append(rgb2lms[0] + rgb2lms[1] + rgb2lms[2])
        anchor_e.append(rgb2lms[3] + rgb2lms[4] + rgb2lms[5])
        anchor_e.append(rgb2lms[6] + rgb2lms[7] + rgb2lms[8])
        /* Set 1: regions where lambda_a=575, set 2: lambda_a=475 */
        a1 = anchor_e[1] * anchor[11] - anchor_e[2] * anchor[10];
        b1 = anchor_e[2] * anchor[9]  - anchor_e[0] * anchor[11];
        c1 = anchor_e[0] * anchor[10] - anchor_e[1] * anchor[9];
        a2 = anchor_e[1] * anchor[5]  - anchor_e[2] * anchor[4];
        b2 = anchor_e[2] * anchor[3]  - anchor_e[0] * anchor[5];
        c2 = anchor_e[0] * anchor[4]  - anchor_e[1] * anchor[3];
        inflection = (anchor_e[1] / anchor_e[0]);
    }
    
    override func convertColor(_ color:NSColor) -> NSColor {
        let initial = initialStep(color)
        var red = initial.red
        var green = initial.green
        var blue = initial.blue
        let tmp = green / red
        
        /* See which side of the inflection line we fall... */
        if tmp < inflection {
            blue = -(a1! * red + b1! * green) / c1!
        } else {
            blue = -(a2! * red + b2! * green) / c2!
        }
        
        let final = finalStep(red, g:green, b:blue)
        red = final.red
        green = final.green
        blue = final.blue
        
        return ColourDeficiency.toColor(final.red, g: final.green, b: final.blue)
    }
}

class ColourDeficiencyColorBlindness: ColourDeficiency {
    override func convertColor(_ color:NSColor) -> NSColor {
        let gray = 0.3 * color.getRDouble() + 0.59 * color.getGDouble() + 0.11 * color.getBDouble()
        let red = gray
        let green = gray
        let blue = gray
        
        return ColourDeficiency.toColor(red, g: green, b: blue)
    }
}
