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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let context = NSGraphicsContext.current!.cgContext
        context.interpolationQuality = .none
        context.setShouldAntialias(false)

        // Drawing code here.
        self.lockFocus()

        if cgImage != nil {
            context.draw(cgImage!, in: NSRectToCGRect(cgRect!))
        }
        
        // drawing magnifier view borders
        context.setStrokeColor(gray: 1.0, alpha: 1.0);
        drawBorderForRect(context, rect: CGRect(x: 0.0, y: 0.0, width: 127.0, height: 127.0));
        context.setStrokeColor(gray: 1.0, alpha: 1.0);
        drawBorderForRect(context, rect: CGRect(x: 1.0, y: 1.0, width: 125.0, height: 125.0));

        // drawing magnifier view aperture
        let apertureRect:CGRect = CGRect(x: 64.0, y: 56.0, width: 7.0, height: 7.0);
        context.setStrokeColor(red: 1.0, green: 0, blue: 0, alpha: 1)
        drawBorderForRect(context, rect: apertureRect)
        
        self.unlockFocus()
    }
    
    func updateView(_ image:CGImage, rect:NSRect) {
        cgImage = image
        cgRect = rect
        self.setNeedsDisplay(self.bounds)
    }
    
    func drawBorderForRect(_ context:CGContext, rect:CGRect) {
        let x:CGFloat = rect.origin.x;
        let y:CGFloat = rect.origin.y;
        let w:CGFloat = rect.size.width;
        let h:CGFloat = rect.size.height;
        
        context.beginPath();
        context.move(to: CGPoint(x: x, y: y));
        context.addLine(to: CGPoint(x: x + w, y: y));
        context.move(to: CGPoint(x: x + w, y: y));
        context.addLine(to: CGPoint(x: x + w, y: y + h));
        context.move(to: CGPoint(x: x + w, y: y + h));
        context.addLine(to: CGPoint(x: x, y: y + h));
        context.move(to: CGPoint(x: x, y: y + h));
        context.addLine(to: CGPoint(x: x, y: y));
        context.strokePath();
    }
}
