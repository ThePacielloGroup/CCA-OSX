//
//  CCAPickerWindowController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 17/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAPickerController: NSWindowController {

    @IBOutlet var pickerWindow: CCAPickerWindow!
    @IBOutlet weak var pickerView: CCAPickerView!
    @IBOutlet weak var hexaText: NSTextField!
    
    var cgImage:CGImage?
    var dimension:UInt = 0
    var color:NSColor?
    
    let DEFAULT_DIMENSION:UInt = 128

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        /* Set always on top */
        pickerWindow.level = Int(CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey)))

        //        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventGlobal)
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventLocal)
        dimension = DEFAULT_DIMENSION / 8
    }
    
    override func mouseUp(theEvent: NSEvent) {
        NSNotificationCenter.defaultCenter().postNotificationName("ColorSelectedNotification", object: nil)
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
        
        var rect:NSRect = pickerView.bounds
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        CGContextSetShouldAntialias(context, false)
        
        pickerView.updateView(cgi, rect: rect)
        
        // getting color
        color = colorAtLocation(location)
        hexaText.backgroundColor = color
        hexaText.stringValue = color!.getHexString()
    }
    
    func getScreenRect(point:NSPoint) -> NSRect {
        var screenRect:NSRect?
        if let screens = NSScreen.screens() as? [NSScreen] {
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
            CGWindowListOption(kCGWindowListOptionOnScreenBelowWindow),
            windowID,
            CGWindowImageOption(kCGWindowImageBestResolution)).takeRetainedValue()
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
            CGWindowListOption(kCGWindowListOptionOnScreenBelowWindow),
            windowID,
            CGWindowImageOption(kCGWindowImageBestResolution)).takeRetainedValue()
        return imageRef
    }
}
