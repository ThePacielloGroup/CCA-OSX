//
//  CCAPickerWindowController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 17/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
import CoreGraphics
import AppKit

class CCAPickerController: NSWindowController {

    @IBOutlet var pickerWindow: NSWindow!
    @IBOutlet weak var pickerView: CCAPickerView!
    @IBOutlet weak var hexaText: NSTextField!
    
    var color: CCAColour!
    var cgImage:CGImage?
    var dimension:UInt = 0
    var tmpcolor:NSColor?
    
    let DEFAULT_DIMENSION:UInt = 128
    
    override func windowWillLoad() {
        super.windowWillLoad()
        
        //        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventGlobal)
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventLocal)
        dimension = DEFAULT_DIMENSION / 8
        
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask) { (aEvent) -> NSEvent? in
            self.keyDown(aEvent)
            return aEvent
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        /* Set always on top */
        pickerWindow.level = Int(CGWindowLevelForKey(CGWindowLevelKey.FloatingWindowLevelKey))
    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.color.update(self.tmpcolor!)
        self.close()
    }
    
    override func keyDown(theEvent: NSEvent) {
        if (theEvent.keyCode == 53){
            self.close()
        }
    }

    func open(color:CCAColour) {
        self.color = color
        // Hide the mouse
        CGDisplayHideCursor(CGMainDisplayID())

        super.showWindow(nil)
    }
    
    override func close() {
        // Unhide the mouse
        CGDisplayShowCursor(CGMainDisplayID())
        super.close()
    }
    
    /*
    func handlerEventGlobal(aEvent: (NSEvent!)) -> Void {
        mouseMoved(aEvent)
        pickerView.mouseMoved(aEvent)
    }*/
    
    func handlerEventLocal(aEvent: (NSEvent!)) -> NSEvent {
        mouseMoved(aEvent)
        pickerView.mouseMoved(aEvent)
        return aEvent
    }

    override func mouseMoved(theEvent:NSEvent) {
        let mouseLocation:NSPoint = NSEvent.mouseLocation()
        var center:NSPoint = mouseLocation
        center.x -= 64
        center.y -= 64
        // Center the windows to the mouse
        pickerWindow.setFrameOrigin(center)
        
        
        let screen = getScreenRect(mouseLocation)
        var location:NSPoint = mouseLocation
        location.y = screen.size.height - mouseLocation.y
        
        let cgi = imageAtLocation(location)
        
        let rect:NSRect = pickerView.bounds

//        let context:CGContext! = NSGraphicsContext.currentContext()?.CGContext

//        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None)
//        CGContextSetShouldAntialias(context, false)
        
        pickerView.updateView(cgi, rect: rect)
        
        // getting color
        self.tmpcolor = colorAtLocation(location)
        hexaText.backgroundColor = self.tmpcolor
        hexaText.stringValue = self.tmpcolor!.getHexString()
    }
    
    func getScreenRect(point:NSPoint) -> NSRect {
        var screenRect:NSRect?
        if let screens = NSScreen.screens() as [NSScreen]? {
            for screen in screens {
                if NSMouseInRect(point, screen.frame, false) {
                    screenRect = screen.frame
                }
            }
        }
        return screenRect!
    }
    
    func colorAtLocation(location: NSPoint) -> NSColor {
        var windowID = CGWindowID(0)
        if pickerWindow.windowNumber > 0 {
            windowID = CGWindowID(pickerWindow.windowNumber)
        }

        let imageRect:CGRect = CGRectMake(location.x, location.y, 1, 1)
        let imageRef:CGImageRef = CGWindowListCreateImage(
            imageRect,
            CGWindowListOption.OptionOnScreenBelowWindow,
            windowID,
            CGWindowImageOption.BestResolution)!
        let bitmap: NSBitmapImageRep = NSBitmapImageRep(CGImage: imageRef)
        return bitmap.colorAtX(0, y:0)!
    }

    func imageAtLocation(location: NSPoint) -> CGImage {
        var windowID = CGWindowID(0)
        if pickerWindow.windowNumber > 0 {
            windowID = CGWindowID(pickerWindow.windowNumber)
        }
        
        let imageRect:CGRect = CGRectMake(location.x - 8, location.y - 8, 16, 16)
        let imageRef:CGImageRef = CGWindowListCreateImage(
            imageRect,
            CGWindowListOption.OptionOnScreenBelowWindow,
            windowID,
            CGWindowImageOption.BestResolution)!
        return imageRef
    }
}
