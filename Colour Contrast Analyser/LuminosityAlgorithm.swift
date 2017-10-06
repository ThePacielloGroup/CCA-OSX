//
//  LuminosityAlgorithm.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 28/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class Luminosity {
   
    class func getResult(_ fColor:NSColor, bColor:NSColor) -> Double {
        let lf:CGFloat = relativeLuminance(fColor)
        let lb:CGFloat = relativeLuminance(bColor)
        let cr = contrastRatio(lf, lb:lb)
        return Double(cr)
    }
    
    class func contrastRatio (_ lf:CGFloat, lb:CGFloat) -> CGFloat {
        var cr:CGFloat
        if lf >= lb {
            cr = (lf + 0.05)/(lb + 0.05);
        } else {
            cr = (lb + 0.05)/(lf + 0.05);
        }
        return cr;
    }
    
    class func relativeLuminance(_ color:NSColor) -> CGFloat {
        var Rs:CGFloat = color.redComponent
        var Gs:CGFloat = color.greenComponent
        var Bs:CGFloat = color.blueComponent
        if (Rs <= 0.03928) {
            Rs = Rs/12.92
        } else {
            Rs = pow(((Rs+0.055)/1.055),2.4)
        }
        if (Gs <= 0.03928) {
            Gs = Gs/12.92;
        } else {
            Gs = pow(((Gs+0.055)/1.055),2.4);
        }
        if (Bs <= 0.03928) {
            Bs = Bs/12.92;
        } else {
            Bs = pow(((Bs+0.055)/1.055),2.4);
        }
        return 0.2126 * Rs + 0.7152 * Gs + 0.0722 * Bs;
    }
}
