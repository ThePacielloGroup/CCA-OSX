//
//  ColorBrightnessDifferenceAlgorithm.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 03/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
/*
#define max(a, b) a>b?a:b
#define min(a, b) a<b?a:b
*/
class ColourBrightnessDifference {
    class func getColourDifference(_ fc: NSColor, bc:NSColor) -> Int {
        let maxR = max(bc.getRInt(),fc.getRInt())
        let minR = min(bc.getRInt(),fc.getRInt())
        let maxG = max(bc.getGInt(),fc.getGInt())
        let minG = min(bc.getGInt(),fc.getGInt())
        let maxB = max(bc.getBInt(),fc.getBInt())
        let minB = min(bc.getBInt(),fc.getBInt())
        return maxR - minR + maxG - minG + maxB - minB
    }
    
    class func getBrightnessDifference(_ fc: NSColor, bc:NSColor) -> Int {
        let fH = ((fc.getRInt() * 299) + (fc.getGInt() * 587) + (fc.getBInt() * 114)) / 1000;
        let bH = ((bc.getRInt() * 299) + (bc.getGInt() * 587) + (bc.getBInt() * 114)) / 1000;
        return abs(fH - bH);
    }
}
