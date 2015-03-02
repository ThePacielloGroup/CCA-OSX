//
//  NSPickerView.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 11/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAPickerView: NSView {

    var cgImage:CGImage?
    var cgRect:NSRect?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        CGContextSetShouldAntialias(context, false)

        // Drawing code here.
        self.lockFocus()

        if cgImage != nil {
            CGContextDrawImage(context, NSRectToCGRect(cgRect!), cgImage)
        }
        
        // drawing magnifier view borders
        CGContextSetGrayStrokeColor(context, 1.0, 1.0);
        drawBorderForRect(context, rect: CGRectMake(0.0, 0.0, 127.0, 127.0));
        CGContextSetGrayStrokeColor(context, 1.0, 1.0);
        drawBorderForRect(context, rect: CGRectMake(1.0, 1.0, 125.0, 125.0));

        // drawing magnifier view aperture
        let apertureRect:CGRect = CGRectMake(64.0, 56.0, 7.0, 7.0);
        CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1)
        drawBorderForRect(context, rect: apertureRect)
        
        self.unlockFocus()
    }
    
    func updateView(image:CGImage, rect:NSRect) {
        cgImage = image
        cgRect = rect
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    func drawBorderForRect(context:CGContextRef, rect:CGRect) {
        let x:CGFloat = rect.origin.x;
        let y:CGFloat = rect.origin.y;
        let w:CGFloat = rect.size.width;
        let h:CGFloat = rect.size.height;
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, x + w, y);
        CGContextMoveToPoint(context, x + w, y);
        CGContextAddLineToPoint(context, x + w, y + h);
        CGContextMoveToPoint(context, x + w, y + h);
        CGContextAddLineToPoint(context, x, y + h);
        CGContextMoveToPoint(context, x, y + h);
        CGContextAddLineToPoint(context, x, y);
        CGContextStrokePath(context);
    }
}
